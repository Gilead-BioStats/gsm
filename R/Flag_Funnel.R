#' Flag_Funnel
#'
#' Add columns flagging sites that represent possible statistical outliers.
#'
#' @details
#' This function flags sites based on the funnel plot analysis result as part of the [GSM data pipeline](https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html).
#'
#' @section Data Specification:
#' \code{Flag} is designed to support the input data (`dfAnalyzed`) from \code{Analyze_Binary} or \code{Analyze_Rate} functions.
#' At a minimum, the input data must have a `SiteID` column and a column of numeric values (identified
#' by the `strColumn` parameter) that will be compared to the specified thresholds (`vThreshold`) to
#' calculate a new `Flag` column.
#' In short, the following columns are considered:
#' - `GroupID` - Group ID (required)
#' - `strColumn` - A column to use for Thresholding (required)
#' - 'strValueColumn' - A column to be used for the sign of the flag (optional)#'
#' @param dfAnalyzed data.frame where flags should be added.
#' @param vThreshold Vector of 4 numeric values representing lower and upper threshold values. All
#' values in strColumn are compared to vThreshold using strict comparisons. Values less than the lower threshold or greater than the upper threshold are flagged as -1 and 1 respectively. Values equal to the threshold values are set to 0 (i.e. not flagged). If NA is provided for either threshold value it is ignored, and no values are flagged based on the threshold. NA and NaN values in strColumn are given NA flag values.
#'
#' @return `data.frame` with "Flag" column added
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
#' dfAnalyzed <- Analyze_Rate(dfTransformed)
#'
#' dfFlagged <- Flag_Funnel(dfAnalyzed, vThreshold = c(-3, -2, 2, 3))
#'
#' @import dplyr
#'
#' @export

Flag_Poisson <- function(
  dfAnalyzed,
  vThreshold = NULL
) {
  stopifnot(
    "dfAnalyzed is not a data frame" = is.data.frame(dfAnalyzed),
    "vThreshold is not numeric" = is.numeric(vThreshold),
    "vThreshold must be length of 4" = length(vThreshold) == 4,
    "vThreshold cannot be NULL" = !is.null(vThreshold)
  )

  # ensure flags are sorted so we can use indexing below
  vThreshold <- sort(vThreshold)


  if (all(!is.na(vThreshold))) {
    stopifnot(
      "vThreshold must contain cutoff for moderate/high risks in two directions (i.e., vThreshold = c(-3, -2, 2, 3))" =
        vThreshold[1] < vThreshold[2],
      "vThreshold must contain cutoff for moderate/high risks in two directions (i.e., vThreshold = c(-3, -2, 2, 3))" =
        vThreshold[2] < vThreshold[3],
      "vThreshold must contain cutoff for moderate/high risks in two directions (i.e., vThreshold = c(-3, -2, 2, 3))" =
        vThreshold[3] < vThreshold[4]
    )
  }


  # Flag values outside the specified threshold.
  dfFlagged <- dfAnalyzed %>%
    mutate(
      Flag = case_when(
        (.data$Score < vThreshold[1]) ~ -2,
        (.data$Score < vThreshold[2]) ~ -1,
        (.data$Score < vThreshold[3]) ~ 0,
        (.data$Score < vThreshold[4]) ~ 1,
        TRUE ~ 2
      )
    )

  dfFlagged <- dfFlagged %>%
    arrange(match(.data$Flag, c(2, -2, 1, -1, 0)))


  return(dfFlagged)
}
