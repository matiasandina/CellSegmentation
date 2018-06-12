# This function cleans the 'Realname' column
# We use it before merging the read_NIS import with the mastersheet

clean_file_names <- function(dataframe, cleanning_blobs){
  
  # Remove .xlsx and folder info from the path
  dataframe$RealName <- gsub('.xlsx', '', x = dataframe$RealName)  
  dataframe$RealName <- gsub('./3D_data/', '', x = dataframe$RealName)
  
  
  dataframe <- rename(dataframe, binary_layer = `Binary Layer`)
  
  if(cleanning_blobs){
    
    dataframe <- rename(dataframe, filename_cells = RealName)
    
  } else {
    
    dataframe  <- rename(dataframe, filename_coloc = RealName)
    
  }
  
  return(dataframe)
}