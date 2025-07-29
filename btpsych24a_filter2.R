####################################
#### Minhash and locality-sensitive hashing
#### https://cran.r-project.org/web/packages/textreuse/vignettes/textreuse-minhash.html
####################################

####################################
##### set-up
####################################
# specify data directory
data_dir <- Sys.getenv("data_dir")

# source setup file
source('setup.R')

library('textreuse')
library('stringr')
library('stringdist')
library('future.apply')

# set multiple cores (if you're on a Mac)
options(mc.cores = parallel::detectCores() - 2)

# open data
DF <- 
  readRDS(
    file.path(data_dir,
              'openalex',
              'btpsych24a_data_bib_processed.Rds')
    )

# select subset for testing purposes
#df <- DF[1 : 10000,]

df <- DF
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
           str_replace_all("[[:punct:]]", " ") %>%  # remove punctuation
           str_squish()                      # trim + collapse spaces
         ) %>% 
  
  # remove normalized titles (less data to process)
  distinct(clean_title,
           .keep_all = T)


####################################
# Generate MinHash signatures
####################################
# generate minhash function
minhash <- minhash_generator(seed = 1967)

# tokenize and hash
corpus <- 
  TextReuseCorpus(
    text = df$clean_title,
    tokenizer = tokenize_ngrams,
    n = 3,
    minhash_func = minhash
    )

# backup corpus
corpus %>% 
  saveRDS(file.path(data_dir,
                    'openalex',
                    'corpus.Rds'))

# bucket and identify candidates
buckets <- lsh(corpus, 
               bands = 50, 
               progress = interactive())

candidates <- 
  lsh_candidates(buckets)

####################################
# identify similar candidates
similarities <- 
  lsh_compare(candidates, 
              corpus, 
              jaccard_similarity)

# backup similarities
saveRDS(file.path(data_dir,
                  'openalex',
                  'similarities.Rds')
        )

candidates <- similarities %>% 
  filter(score > .8)