# Read in data
# Created by Andrew Saul August 2024

# path directory to directories containing data files of interest
data_dir <- "/conf/LIST_analytics/West Hub/02 - Scaled Up Work/GP cluster profiles/R/data/GP Clusters"

# data file names using regex
data_common_name <- "^AllData.*\\.csv"

# pathnames of all data files
data_files <- 
  list.files(path = data_dir,
             pattern = data_common_name,
             recursive = TRUE,
             full.names = TRUE)

# Read each CSV file into a data.table
data_table_list <- map(data_files, fread, .progress = T)

# Combine all data.tables into one
combined_dt <- rbindlist(data_table_list, fill = TRUE)

# convert data table into a dataframe for convenience
setDF(combined_dt)

#convert to tibble
profiles <- as_tibble(combined_dt) %>% 
  select(-LOOKUP) |> 
  mutate(NHS_BOARD = case_when(GEOGRAPHY_TYPE == "Scotland" & NHS_BOARD == "" ~ "NHS Scotland", .default = NHS_BOARD))

rm(list = ls()[ls()!="profiles"])


