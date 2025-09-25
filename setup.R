#########
# general script for setting up environment in R
#########

# load libraries
library('cowplot')
library('ggtext')
library('readxl')
library('tidyverse')
library("countrycode")
library('circlize')
library('here')
library("ggspatial")
library('ggmap')
library('sf')
library("rnaturalearth")
library("rnaturalearthdata")
library('scales')
library('tidygeocoder')
library('png')
library('grid')
library('parallel')
library('Ecume')
library('openalexR')
library("jsonlite")
library('textreuse')
library('stringr')
library('stringdist')
library('future.apply')
library('BayesFactor')
library('nnet')
library("compute.es")
library("brms")
library("bridgesampling")
library("bayestestR")
library("loo")
library("bayesplot")
library('psych')

# set plotting theme
theme_set(theme_classic())

# turn off scientific notation
options(scipen = 999)

# set seed for reproducibility
set.seed(1967)
