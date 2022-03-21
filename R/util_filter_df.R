
util_filter_df <- function(df, strCol = NULL,strValue =  NULL ){
  
  dfname <-deparse(substitute(df))
  
  strColname <- deparse(substitute(strCol))
  strValuename <- deparse(substitute(strValue))
  
  if(!is.data.frame(df)){
    stop(paste0(dfname, " is not a dataframe"))
  }
  
  if(length(strCol) > 1){
    stop(paste0("length of ", strColname, " is not a equal to one"))
  }
  
  if(length(strValue) > 1){
    stop(paste0("length of ", strValuename, " is not a equal to one"))
  }
  
  if(is.character(strCol)){
    stop(paste0( strColname, " must be a character type"))
  }
  
  

  
  if(!is.null(strCol) & is.null(strValue)){
    warning(paste0("strCol is defined as ", strCol, " but strValue is NULL. No filtering on ", strCol, " will be done for ", dfname,"." ))
  }
  
  if(is.null(strCol) & !is.null(strValue)){
    warning(paste0("strValue is defined as ", strValue, " but strcol is NULL. No filtering using ", strValue, " will be done for ", dfname,"." ))
  }
  
 
  
  if(!is.null(strCol) & !is.null(strValue) ){
    if(any(strCol %in% names(df))){
      if(any(strValue %in% unique(df %>% pull(strCol)))){
        df <- df %>% 
          filter(.data[[strCol]] == strValue) 
      }else{
        warning(paste0("No ", strValue," rows found in column ", strCol," of ",dfname,". No filtering on ", strCol, " == ", strValue, " will be done"))
      }
    }else{
      warning(paste0(strCol," is not a colname in ",dfname,", no filtering on ", strCol, " == ", strValue, " was be done"))
    }
  }
  
  return(df)
}
