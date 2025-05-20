# Generate Profiles

## Load packages & initial set up ----------------------------------------------
library(tidyverse)
library(lubridate)
library(data.table)
source("Read in data.R")
source("Render Functions.R")

## Set variables ---------------------------------------------------------------

# Set report level - can take two values:
# "cluster" - produces a cluster level dashboard with practice level data for all practice in the cluster
# "practice" - produces same dashboard but with practice data for only one single practice
report_level <- "practice"

# Set Health Board that you want to generate profiles for
# This can be a vector containing multiple health boards
HB <-  c("NHS Ayrshire and Arran",
         "NHS Borders",
         "NHS Dumfries and Galloway",
         "NHS Fife",
         "NHS Forth Valley",
         "NHS Grampian",
         "NHS Greater Glasgow and Clyde",
         "NHS Highland",
         "NHS Lanarkshire",
         "NHS Lothian",
         "NHS Orkney",
         "NHS Shetland",
         "NHS Tayside",
         "NHS Western Isles",
         "") # need the empty quotes to get Scotland


## Filter Data to relevant health boards ---------------------------------------

profiles <- profiles %>% 
  janitor::clean_names() %>% 
  filter(nhs_board %in% HB)

## Generate report -------------------------------------------------------------
if(report_level == "cluster"){
  # clusts <- unique(profiles$geography_name[profiles$geography_type == "GP Cluster"]) # produce all cluster profiles
  # clusts <- c("Irvine Valley", "Irvine, Kilwinning, Dundonald", "Troon Cluster") # can produce for a subset of clusters
  # clusts <- "East Lothian" # can produce for a single cluster
  walk(clusts, ~generate_cluster_profile(.x, profiles))
}else if(report_level == "practice"){
  # pracs <- unique(profiles$geography_name[profiles$geography_type == "GP Practice"]) # Produce all practice profiles
  pracs <- "80787 - LOUDOUN MEDICAL PRACTICE" # can produce for individual practice (or practices if a vector)
  walk(pracs, ~generate_practice_profile(.x, profiles))
}else{
  stop('report_level must be either "cluster" or "practice"')
}



