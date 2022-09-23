#' Flag_Poisson
#'
#' Add columns flagging sites that represent possible statistical outliers.
#'
#' @details
#' This function provides a generalized framework for flagging sites as part of the [GSM data pipeline](https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html).
#'
#' @section Data Specification:
#' \code{Flag} is designed to support the input data (`dfAnalyzed`) from many different
#' \code{Analyze} functions.  dfTransformed must have a `score` column.
#'
#' @param dfAnalyzed data.frame where flags should be added.
#' @param vThreshold Vector of 4 numeric values representing lower and upper threshold values. All
#' values in strColumn are compared to vThreshold using strict comparisons. Values less than the lower threshold or greater than the upper threshold are flagged as -1 and 1 respectively. Values equal to the threshold values are set to 0 (i.e. not flagged). If NA is provided for either threshold value it is ignored, and no values are flagged based on the threshold. NA and NaN values in strColumn are given NA flag values.
#'
#' @return `data.frame` with `Flag` column added 
#'
#' @examples
#' dfInput <- AE_Map_Adam()
#'
#' dfTransformed <- Transform_Rate(dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
#'
#' dfAnalyzed <- Analyze_Poisson(dfTransformed)
#'
#' dfFlagged <- Flag_Poisson(dfAnalyzed, vThreshold = c(-7, -5, 5, 7))
#'
#' @import dplyr
#' @importFrom stats median
#'
#' @export

Flag_Poisson <- function(
  dfAnalyzed,
  vThreshold = NULL,
) {
  stopifnot(
    "dfAnalyzed is not a data frame" = is.data.frame(dfAnalyzed),
    "vThreshold is not numeric" = is.numeric(vThreshold),
    "vThreshold must be length of 4" = length(vThreshold) == 4,
    "vThreshold cannot be NULL" = !is.null(vThreshold),
  )

  # Flag values outside the specified threshold.
  dfFlagged <- dfAnalyzed %>%
    mutate(
      Flag = case_when(
        (.data$score < vThreshold[1]) ~ -2,
        (.data$score < vThreshold[2]) ~ -1,
        (.data$score < vThreshold[3]) ~ 0,
        (.data$score < vThreshold[4]) ~ 1,
        TRUE ~ 2
      )
    )

  dfFlagged <- dfFlagged %>%
    arrange(match(.data$Flag, c(-2,2, 1, -1, 0)))

  return(dfFlagged)
}
