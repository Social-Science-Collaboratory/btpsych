###
# title: "Scramble proprietary Altmetric data for sharing"
# author: "Anonymized for peer review (JT)"
# reviewer: "Anonymized for peer review (NC)"
###

# setup
source("setup.R")

# set seed for reproducibility
set.seed(1967)

# import the two altmetric data sets
btpsych24a_altmetric1_raw <-
  read.csv(here("data", "altmetric", "btpsych24a_altmetric1_raw.csv"))

btpsych24a_altmetric2_raw <-
  read.csv(here("data", "altmetric", "btpsych24a_altmetric2_raw.csv"))

# Select relevant variables for the analysis
btpsych24a_altmetric1_raw <-
  btpsych24a_altmetric1_raw %>%
  select(
    DOI,
    News.mentions,
    Blog.mentions,
    Policy.mentions,
    X.mentions,
    Facebook.mentions
  )

btpsych24a_altmetric2_raw <-
  btpsych24a_altmetric2_raw %>%
  select(
    DOI,
    News.mentions,
    Blog.mentions,
    Policy.mentions,
    X.mentions,
    Facebook.mentions
  )

# Randomly reorder the data within each variable of interest
btpsych24a_altmetric1_scramble <-
  btpsych24a_altmetric1_raw %>%
  mutate(across(
    c(
      "News.mentions",
      "Blog.mentions",
      "Policy.mentions",
      "X.mentions",
      "Facebook.mentions"
    ),
    ~ sample(.)
  ))

btpsych24a_altmetric2_scramble <-
  btpsych24a_altmetric2_raw %>%
  mutate(across(
    c(
      "News.mentions",
      "Blog.mentions",
      "Policy.mentions",
      "X.mentions",
      "Facebook.mentions"
    ),
    ~ sample(.)
  ))

# Manually check if the data was scrambled
view(btpsych24a_altmetric1_raw)
view(btpsych24a_altmetric1_scramble)

view(btpsych24a_altmetric2_raw)
view(btpsych24a_altmetric2_scramble)

# Compare the mean absolute difference between the two data sets
## If the scramble was correct, the mean relative difference should != 0
all.equal(btpsych24a_altmetric1_raw, btpsych24a_altmetric1_scramble)
all.equal(btpsych24a_altmetric2_raw, btpsych24a_altmetric2_scramble)


btpsych24a_altmetric1_raw$News.mentions %>% mean()
btpsych24a_altmetric1_scramble$News.mentions %>% mean()

# Write the csv scrambled data files
write.csv(
  btpsych24a_altmetric1_scramble,
  here("data", "altmetric", "btpsych24a_altmetric1_scramble.csv"),
  row.names = F
)

write.csv(
  btpsych24a_altmetric2_scramble,
  here("data", "altmetric", "btpsych24a_altmetric2_scramble.csv"),
  row.names = F
)
