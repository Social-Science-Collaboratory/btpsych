#########
# general script for setting up environment in R
#########

# load libraries
library('cowplot')
library('ggtext')
library('readxl')
library('tidyverse')

# set plotting theme
theme_set(theme_classic())

# turn off scientific notation
options(scipen = 999)

# set seed for reproducibility
set.seed(1967)