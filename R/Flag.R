#' Flag
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Add columns flagging sites that represent possible statistical outliers when the Identity statistical
#' method is used.
#'
#' @details
#' This function provides a generalized framework for flagging sites as part of the
#' GSM data model (see `vignette("DataModel")`).
#'
#' @section Data Specification:
#' \code{Flag} is designed to support the input data (`dfAnalyzed`) from the `Analyze_Identity()`
#' function. At a minimum, the input data must have a `strGroupCol` parameter and a numeric
#' `strColumn` parameter defined. `strColumn` will be compared to the specified thresholds in
#' `vThreshold` to define a new `Flag` column, which identifies possible statistical outliers. If a
#' user would like to see the directionality of those identified points, they can define the
#' `strValueColumn` parameter, which will assign a positive or negative indication to already
#' flagged points.
#'
#' The following columns are considered required:
#' - `GroupID` - Group ID; default is `SiteID`
#' - `GroupLevel` - Group Type
#' - `strColumn` - A column to use for thresholding
#'
#' The following column is considered optional:
#' - `strValueColumn` - A column to be used for the sign/directionality of the flagging
#'
#' @param dfAnalyzed `data.frame` where flags should be added.
#' @param strColumn `character` Name of the column to use for thresholding. Default: `"Score"`
#' @param vThreshold `numeric` Vector of numeric values representing threshold values. 
#' @param vFlagValues `character` Vector of flag values. There must be one more item in Flag than thresholds - that is `length(vThreshold)+1 == length(vFlagValues)`. When vFlagValues is `NULL` (the default), it is set to seq(0:length(vTreshhold)). 
#' 
#' @return `data.frame` dfAnalyzed is returned with an additional `Flag` column. 
#'
#' @examples
#' dfTransformed <- Transform_Count(analyticsInput, strCountCol = "Numerator")
#'
#' dfAnalyzed <- Analyze_Identity(dfTransformed)
#'
#' dfFlagged <- Flag(dfAnalyzed, vThreshold = c(0.001, 0.01))
#'
#' @export
#' 
#' @aliases Flag_NormalApprox Flag_Poisson 

Flag <- function(
  dfAnalyzed,
  strColumn = "Score",
  vThreshold = c(-3,-2,2,3),
  vFlag = c(-2,-1,0,1,2)
) {
  stopifnot(
    "dfAnalyzed is not a data frame" = is.data.frame(dfAnalyzed),
    "strColumn is not character" = is.character(strColumn),
    "vThreshold is not numeric" = is.numeric(vThreshold),
    "vThreshold cannot be NULL" = !is.null(vThreshold),
    "vThreshold is not in ascending order" = all(vThreshold == sort(vThreshold)),
    "strColumn must be length of 1" = length(strColumn) == 1,
    "strColumn not found in dfAnalyzed" = strColumn %in% names(dfAnalyzed),
    "vFlag must be numeric" = is.numeric(vFlag),
    "Improper number of Flag values provided" = length(vFlag) == length(vThreshold)+1
  )
    dfFlagged <- dfAnalyzed
    # generate flag values for dfAnalyzed[strColumn] based on vThresold and vFlag 
    dfFlagged$Flag <- cut(
        dfFlagged[[strColumn]],
        breaks = c(-Inf, vThreshold, Inf),
        labels = vFlag,
        right = FALSE
    ) %>% as.character() %>% as.numeric() #Parse from factor to numeric

    # If default flag is used, apply custom sort
    if(vFlag == c(-2,-1,0,1,2) ){
      dfFlagged <- dfFlagged %>% arrange(match(.data$Flag, c(2, -2, 1, -1, 0)))
    }
    
  return(dfFlagged)
}