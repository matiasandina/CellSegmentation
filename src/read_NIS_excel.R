
# Read from folder containing .xls

read_NIS_excel <- function(directory, pattern){

    myfiles <- list.files(path = directory, pattern = pattern, full.names = T)
    
    
    if(length(myfiles)<1){

      print(list.files(directory))
      stop("No such file in directory, check your files are there")
      
    } else {
      
      print(paste("Reading...", myfiles))
      
    }
    
    excel_list <- lapply(myfiles, function(x) readxl::read_excel(path = x,
                                                                 sheet = 1,
                                                                 col_types = "text"))
    
    
    # Paste the filename from which it was read to the data frames
    
    for(i in 1:length(excel_list)){
      
    excel_list[[i]]$RealName <- myfiles[i]
      
    }
    
    
    # Find the 'Statistics:' on the list
    
    first_row <- unlist(lapply(excel_list, function(x) grep("Statistics:", x$`#`)))
    
    # If you found it, remove those rows

    if(length(first_row>0)){

    #   Check the length of first_row matches the length of the data
    
       if(length(first_row) != length(excel_list)){
         error("Some data frames don't have `Statistics:` on them. Check readxl call and the data.frames")
       }    
    
       for(i in 1:length(first_row)){
    
         subset_end <- first_row[i] - 1
    
         # Only keep rows from 1 to the first_row[i]
         excel_list[[i]] <- excel_list[[i]][1:subset_end, ]
    
         # Convert to numeric to avoid issues
         excel_list[[i]]$`#` <- as.numeric(excel_list[[i]]$`#`)
    
         # Also fix NAs
    
         excel_list[[i]] <- dplyr::na_if(excel_list[[i]], "N/A")
    
       }
    
     }
    
    df <- dplyr::bind_rows(excel_list)

return(df)    
}

