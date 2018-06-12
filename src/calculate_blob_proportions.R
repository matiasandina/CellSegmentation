calculate_blob_proportions <- function(dataframe){
  
  # prepare a list
  
  li <- list()
  
  for (i in unique(dataframe$folder)){
    # Get each folder
    my_df <- joined_df %>% filter(folder == i) %>%
      mutate(filename_cells = ifelse(is.na(filename_cells),
                                     filename_coloc,
                                     filename_cells)) %>%
      rename(filename = filename_cells) %>%
      select(-filename_coloc)
    
    Cy5 <- filter(my_df, binary_layer=="Cy5") %>%
      rename(Cy5_blobs = n_blobs) %>%
      select(-binary_layer, -filename) %>% 
      left_join(my_df)
    
    TRITC <- filter(my_df, binary_layer=="TRITC") %>%
      rename(TRITC_blobs = n_blobs) %>%
      select(-binary_layer, -filename) %>% 
      left_join(my_df)
    
    FITC <- filter(my_df, binary_layer=="FITC") %>%
      rename(FITC_blobs = n_blobs) %>%
      select(-binary_layer, -filename) %>% 
      left_join(my_df)
    
    
    li[[i]] <- left_join(Cy5,left_join(TRITC,FITC)) %>%
      select(RatID, folder, filename, z_stack_id,
             binary_layer, n_blobs,
             FITC_blobs, TRITC_blobs, Cy5_blobs)
    
  }
    
    
  df_out <- bind_rows(li)
  
  return(df_out)
  
}