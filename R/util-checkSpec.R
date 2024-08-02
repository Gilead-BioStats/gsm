# Check that all data.frames and columns in the spec are present in the data
#' Function to check if the data and spec are compatible
#'
#' This function checks if the data and spec are compatible by comparing the data.frames
#' and columns in the spec with the data.
#'
#' @param lData A list of data.frames.
#' @param lSpec A list s specifying the expected structure of the data.
#'
#' @return This function does not return any value. It either prints a message indicating
#' that all data.frames and columns in the spec are present in the data, or throws an error
#' if any data.frame or column is missing.
#'
#' @examples
#' lData <- list(reporting_groups = gsm::reportingGroups, reporting_results = gsm::reportingResults)
#' lSpec <- list(
#'   reporting_groups = list(  
#'       GroupID = "required", 
#'       GroupLevel = "required",
#'       Param = "required",
#'       Value = "required",
#'   ),
#'   reporting_results = list(
#'       GroupID = "required",
#'       GroupLevel = "required",
#'       Numerator = "required",
#'       Denominator = "required"
#'   )
#' CheckSpec(lData, lSpec) # Prints message that everything is found
#'
#' lSpec$reporting_groups$NotACol <- "required"
#' check_spec(lData, lSpec) # Throws error that NotACol is missing
#'
#' @export
#' 
CheckSpec <- function(lData, lSpec) {
    # Check that all data.frames in the spec are present in the data
    lSpecDataFrames <- names(lSpec)
    lDataFrames <- names(lData)
    if (!all(lSpecDataFrames %in% lDataFrames)) {
        MissingSpecDataFrames <- lSpecDataFrames[!lSpecDataFrames %in% lDataFrames]
        cli_alert_danger("Not all data.frames in the spec are present in the data, missing data.frames are: {MissingSpecDataFrames}")
    } else {
        cli_alert("All {length(lSpecDataFrames)} data.frame(s) in the spec are present in the data: {lSpecDataFrames}")
    }

    # Check that all columns in the spec are present in the data
    allCols <- c()
    missingCols <- c()
    for (strDataFrame in lSpecDataFrames) {
        lSpecColumns <- names(lSpec[[strDataFrame]]) 
        lDataColumns <- names(lData[[strDataFrame]])
        allCols <- c(allCols, paste(strDataFrame, lSpecColumns, sep="$"))

        thisMissingCols <- lSpecColumns[!lSpecColumns %in% lDataColumns]
        if(length(thisMissingCols) > 0){
            missingCols <- c(missingCols, paste(strDataFrame, thisMissingCols, sep="$"))  
        }   
    }
    if (length(missingCols) > 0) {
        cli_alert_danger("Not all columns in the spec are present in the data, missing columns are: {missingCols}")
    } else {
        cli_alert("All {length(allCols)} columns in the spec are present in the data: {allCols}")
    }
}

