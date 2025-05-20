# Functions

# Cluster Level Profile



generate_cluster_profile <- function(name, df){
  
  # Extract appropriate board and HSCP to filter comparator data
  board <- unique(df$nhs_board[df$geography_name == name])
  hscp_use <- unique(df$hscp[df$geography_name == name])
  this_cluster <<- as.factor(name)
  
  # define variable for the latest quarter for default filter values
  #latest_quart = 
  
  for_clust <- df %>% 
    filter(geography_name == name |      # Get Cluster Data
           cluster == name |             # Get Practice Data
           geography_name == board |     # Get Board Data
           geography_name == hscp_use |  # Get HSCP Data
           geography_type == "Scotland"  # Get Scotland Data
           ) %>%  
    distinct() %>% 
    mutate(fy_new = case_when(fq == "Q4" ~ fy + 1,
                              .default = fy),
           fq_new = as.numeric(str_remove(fq, "Q")) + 1,
           fq_new = case_when(fq_new == 5 ~ 1,
                              .default = fq_new),
           quarter = yq(paste(fy_new, str_remove(fq_new, "Q"))),
           geography_name = factor(geography_name, 
                                   levels = c(unique(geography_name[geography_type == "GP Practice"]),
                                              name,
                                              hscp_use,
                                              board,
                                              "NHS Scotland")))

  # Takes the Template document and renders - folder structure needs to be set up in advance  
  rmarkdown::render(input = "Template.Rmd",
                    #output_format = "html_document",
                    output_file = paste0(name, ".html"),
                    output_dir = file.path("/conf","LIST_analytics", "West Hub",
                                           "02 - Scaled Up Work", 
                                           "GP cluster profiles", "R", "Outputs",
                                           board))
  
  
}

# Practice Level Profile (only difference is filtering)
generate_practice_profile <- function(name, df){
  
  # Extract appropriate board, HSCP and cluster data to filter comparator data
  board <- unique(df$nhs_board[df$geography_name == name])
  hscp_use <- unique(df$hscp[df$geography_name == name])
  cluster_use <- unique(df$cluster[df$geography_name == name])
  
  for_clust <- df %>% 
    filter(geography_name == name |              # Get practice Data
           geography_name == cluster_use |       # Get Cluster Data
           geography_name == board |             # Get Board Data
           geography_name == hscp_use |          # Get HSCP Data
           geography_type == "Scotland") %>%     # Get Scotland Data
    distinct() %>% 
    mutate(fy_new = case_when(fq == "Q4" ~ fy + 1,
                              .default = fy),
           fq_new = as.numeric(str_remove(fq, "Q")) + 1,
           fq_new = case_when(fq_new == 5 ~ 1,
                              .default = fq_new),
           quarter = yq(paste(fy_new, str_remove(fq_new, "Q"))),
           geography_name = factor(geography_name, 
                                   levels = c(name,
                                              cluster_use,
                                              hscp_use,
                                              board,
                                              "NHS Scotland")))
  # Takes the Template document and renders - folder structure needs to be set up in advance
  rmarkdown::render(input = "Template.Rmd",
                    output_file = paste0(name, ".html"),
                    output_dir = file.path("/conf","LIST_analytics", "West Hub",
                                           "02 - Scaled Up Work", 
                                           "GP cluster profiles", "R", "Outputs",
                                           board))
  
  
}
