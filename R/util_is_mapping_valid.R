#' Check that a data frame contains columns and fields specified in mapping
#' 
#' @param df dataframe to compare to mapping object
#' @param mapping named list specifying expected columns and fields in df
#' @param unique_cols list of columns expected to be unique. default = NULL (none)
#' @param no_cols list of columns where na values are acceptable default = NULL (none)
#' 
#' @import dplyr
#' @import purrrr
#'

#'
#' @examples
#' rdsl_mapping<- list(id_col="SubjectID", site_col="SiteID", exposure_col="TimeOnTreatment")
#' is_mapping_valid(clindata::rdsl, rdsl_mapping, unique_cols="id_col") #TRUE
#' is_mapping_valid(clindata::rdsl, rdsl_mapping, unique_cols="site_col") #FALSE - site_col not unique
#' rdsl_mapping$not_a_col<-"nope"
#' is_mapping_valid(clindata::rdsl, rdsl_mapping, unique_cols="id_col") #FALSE - column not found
#' 
#' @export
#' 
is_mapping_valid(df, mapping, unique_cols=NULL, na_cols=NULL){
    valid <- TRUE
    if(!is.data.frame(df)){
        message("df is not a data frame")
        valid<-FALSE
    }

    if(!nrows(df)>0){
        message("df has 0 rows")
        valid<-FALSE
    }

    # basic mapping checks
    if(!is.list(mapping)){
        message("Mapping is not a list")
        valid<-FALSE
    }

    if(!all(mapping%>%is.character(.x))){
        message("Non-characacter values found in mapping")
        valid<-FALSE
    }

    # expected columns not found in df
    expected_cols <- mapping[grep("_col", names(mapping))]
    expected_cols %>% map(function(col){
        if(!col %in% names(df)){
            message(paste0("Expected column not found: " ,col))  
            valid<-FALSE
        }
    })

    # No NA found in columns
    no_na_cols <- expected_cols[!names(expected_cols) %in% na_cols]
    no_na_cols %>% map(function(col){
        if(any(is.na(df[col]))){
            message(paste0("Unexpected NAs found in required column: ",col))
            valid<-FALSE
        }
        #TODO add NaN and blackspace checks
    })
    

    # Check that specified columns are unique
    if(!is.null(unique)){
        unique_cols <- expected_cols[names(expected_cols) %in% unique_cols]
        unique_cols %>% map(function(col){
            if(any(duplicated(df[[col]]))){
                message(paste0("Unexpected duplicates found column: ",col))
                valid<-FALSE
            }
        })
        
    }

    return(valid)
}