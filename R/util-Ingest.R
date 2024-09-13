
#' Ingests data from a source based on a given specification.
#'
#' @param lSource A list of source data frames.
#' @param lSpec A list of column specifications.
#'
#' @return A list of data frames, where each data frame corresponds to a domain in the specification.
#'
#' @details This function ingests data from a source based on a given specification. It iterates over each domain in the specification and checks if the columns exist in the source data. It then constructs a query to select the columns from the source and calls the `RunQuery` function to retrieve the data. The resulting data frames are stored in a list, where each data frame corresponds to a domain in the specification.
#' 
#' @export

Ingest <- function(lSource, lSpec){
    lRaw <- lSpec %>% imap(
        function(rawDomain, columnSpec){
            # check that the columns exist in the source data

            # write a query to select the columns from the source
            strColQuery <- ''
            for(columnName in names(columns)){
                if('target_col' %in% columnSpec[columnName]){
                targetName <- columSpec[columnName]$target_col  
                strColQuery <- glue("{strColQuery}, {columnName} as {targetName}")
                } else {
                strColQuery <- glue("{strColQuery}, {columnName} ")
                }
            }
            strQuery <- glue("SELECT {strColQuery} FROM df")

            # call RunQuery to get the data
            #replace "source_" with "raw_" in the domain name
            sourceDomain <- rawDomain %>% str_replace("Source_", "Raw_")
            df <- RunQuery(lSource[[sourceDomain]], strQuery =  strQuery)
            return(df)
        }
    )

    names(lRaw) <- names(lSpec)

    return(lRaw)
}