####################################
#### Minhash and locality-sensitive hashing
#### https://cran.r-project.org/web/packages/textreuse/vignettes/textreuse-minhash.html
####################################

####################################
##### set-up
####################################
library('tidyverse')
library('textreuse')
library('stringr')
library('stringdist')
library('future.apply')
library('parallel')

# specify data directory
data_dir <- Sys.getenv("data_dir")

# open data
df <- 
  readRDS(
    file.path(data_dir,
              'openalex',
              'btpsych24a_data_bib_processed.Rds')
    )


####################################
##### normalize and remove duplicate titles
####################################
df <- df %>% 
  # remove non-normalized titles (less data to process)
  distinct(title,
           .keep_all = T) %>% 
  # create normalized titles
  mutate(clean_title = title %>%
           str_to_lower() %>%                 # lowercase
           str_replace_all("[^a-zA-Z0-9\\s]", " ") %>%  # keep only latin letters and numbers
           str_squish()                      # trim + collapse spaces
         ) %>% 
  # remove normalized titles (less data to process)
  distinct(clean_title,
           .keep_all = T) %>%
  # extract the first author's name from the author dataframe
  mutate(first_author = map_chr(author, ~ .x$au_display_name[[1]]),
         first_author_id = map_chr(author, ~ .x$au_id[[1]]))%>% 
  # sort the dataframe by first author name 
  arrange(first_author) %>%
  # remove titles with less than 4 words (minhash requires at least 2 engrams of 3 words)
  filter(str_count(clean_title, "\\S+") >= 4) %>%
  # select only variables necessary for the task 
  # (OpenAlex ID, clean title, first author name and id, number of citations)
  select(id, clean_title, first_author, first_author_id, cited_by_count)

####################################
# Generate MinHash signatures
####################################
# generate minhash function
minhash <- minhash_generator(seed = 1967)

# custom function to apply minhash, locally-sensitive hashing, and flag duplicate candidates
identify_duplicates <- function(df, minhash) {

# tokenize and hash
  corpus <- 
    TextReuseCorpus(
      text = df$clean_title,
      tokenizer = tokenize_ngrams,
      n = 3,
      minhash_func = minhash
    )

# rename the corpus documents to their OpenAlex IDs (if no entries were skipped)
if(length(corpus) == nrow(df)){
  names(corpus) <- df$id
} 

# bucket and identify candidates
buckets <- lsh(corpus, 
               bands = 50, 
               progress = interactive())

candidates <- 
  lsh_candidates(buckets)

####################################
# identify similar candidates and set lower limit of 0.05 similarity
similarities <- 
  lsh_compare(candidates, 
              corpus, 
              jaccard_similarity) %>% 
  filter(score > .05)

return(similarities)

}

# To speed up min hashing, we divided the data set in batches.
# Note: similarity comparisons are only made within a batch. 
# Because of that, we sorted the entries by first author name 
# and added a 50% overlap among batches
# to minimize the risk that duplicates end up in different batches

# set up number of batches
n_batch <- 10

# split the dataframe in batches and add 50% of overlap between consecutive batches
df_list <- lapply(1:n_batch, function(x,
                                      batch_size = ceiling(nrow(df)/n_batch)) {
  start <- (x - 1) * batch_size + 1 # set the starting value for each batch
  end <- min(ceiling(batch_size * (x+0.5)), nrow(df))  # Cap end at the number of rows
  if (start > nrow(df)) return(NULL) # Avoid adding empty batches
  df[start:end, c("id", "clean_title") ]
}
)

# Begin parallel processing for min hashing

# Declare the number of cores
numCores <- 10
#Create cluster
cl <- makeCluster(numCores)
# Export the data frame list and min hash custom function to each cluster 
print(start_export<- Sys.time())
clusterExport(cl, varlist = c("identify_duplicates", "df_list", "minhash"))
print(finish_export <- Sys.time()-start_export)

#Load the libraries in all clusters
clusterEvalQ(cl, {  library('tidyverse')
  library('textreuse')
  library('stringr')
  library('stringdist')})


# use parallel processing to identify duplicate candidates within each batch
print(start_apply<- Sys.time())
similarities <- bind_rows(
  parLapply(cl, df_list, identify_duplicates, minhash = minhash))
print(finish_apply <- Sys.time()-start_apply)

# Stop cluster after parallel processing is complete
stopCluster(cl)

# Process similarity dataframe
similarities <- similarities %>%
  # remove repeated entries (due to batch overlap)
  distinct() %>%
  # Look up document a's information in the original dataframe
  left_join(df, by = c("a" = "id")) %>%
  # rename variables for clarity
  rename(id_a = a,
         clean_title_a = clean_title,
         first_author_a = first_author,
         first_author_id_a = first_author_id,
         cited_by_count_a = cited_by_count) %>%
  # Look up document b's information in the original dataframe
  left_join(df, by = c("b" = "id")) %>%
  # rename variables for clarity
  rename(id_b = b,
         clean_title_b = clean_title,
         first_author_b = first_author,
         first_author_id_b = first_author_id,
         cited_by_count_b = cited_by_count) %>%
  # Create score bins for quality check
  mutate(score_bin = cut( score,
                          breaks = c(0, .1, .2, .3, .4, .5,
                                     .6, .7, .8, .9, 1),
                          labels = c("5-10%", "10-20%", "20-30%",
                                     "30-40%", "40-50%", "50-60%",
                                     "60-70%", "70-80%", "80-90%",
                                     "90-100%"))) %>%
  # reorder variables for readability
  select(score, score_bin, 
         clean_title_a, clean_title_b, 
         first_author_a, first_author_b, 
         first_author_id_a, first_author_id_b,
         cited_by_count_a, cited_by_count_b,
         id_a, id_b) %>%
  # reorder rows by score
  arrange(score)

# Check distribution of similarity scores
table(similarities$score_bin)

# Save duplicate candidates in the data directory (10 batches, 0.05 similarity cutoff)
# saveRDS(similarities, file.path(data_dir, "deduplication", "similarities_10batches_5%sim.Rds"))
# Optional: read similarities file
 similarities <- readRDS(file.path(data_dir, "deduplication", "similarities_10batches_5%sim.Rds"))

# -------------
# NC addition: check whether it is accurate to filter based on first author ID
similarities %>% 
  
  # filter records that have high title similarity scores
  filter(score > .9) %>% 
  
  # indicate whether they have same author
  mutate(same.auth = first_author_id_a == first_author_id_b) %>% 
  
  # inspect instances where it's highly similar but not the same author
  filter(same.auth == F) %>% 
  View()

# Conclusion: filtering pairs with matching author ids is a reasonable approach, 
# but it does miss instances where the author was misclassified by OpenAlex
# Decision: do not filter by author id match.
# -------------  

# randomly sample 20 examples from each score bin to check sensitivity by bin
similarities_validation <- similarities %>%
  group_by(score_bin) %>%
  slice_sample(n = 20)

# save document with sampled entries for sensitivity analysis
# write_csv(similarities_validation, file.path(data_dir, "deduplication", "similarities_validation_10batches.csv"))

 # reload  document with completed sensitivity analysis
similarities_validation <- read_csv(file.path(data_dir, "deduplication", "similarities_validation_10batches_J.csv"))

# group by score bin and calculate rate of true positives for duplicate detection
similarities_validation %>% 
  group_by(score_bin) %>%
  summarize( sensitivity = mean(J_coding))

# for each duplicate pair with similarity score > 0.8
# identify the id with the least citations and add to remove list
remove_duplicate <- similarities %>%
  filter(score >= 0.8) %>%
  mutate(remove_id = case_when(
    cited_by_count_a > cited_by_count_b ~ id_b,
    cited_by_count_a < cited_by_count_b ~ id_a,
    cited_by_count_a == cited_by_count_b ~ id_a)
    ) %>%
  select(remove_id, score, cited_by_count_a, id_a, cited_by_count_b, id_b) %>%
  distinct()

# save a list with the id's that need to be removed from the original dataframe
saveRDS(remove_duplicate$remove_id, 
        file.path(data_dir, "deduplication", "remove_list.Rds"))
