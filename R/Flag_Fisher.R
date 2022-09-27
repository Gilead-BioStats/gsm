#' Flag_Fisher
#'
#' Add columns flagging sites that represent possible statistical outliers.
#'
#' @details
#' This function provides a generalized framework for flagging sites as part of the [GSM data pipeline](https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html).
#'
#' @section Data Specification:
#' \code{Flag} is designed to support the input data (`dfAnalyzed`) from many different
#' \code{Analyze} functions. At a minimum, the input data must have a `SiteID` column and a column
#' of numeric values (identified by the `strColumn` parameter) that will be compared to the
#' specified thresholds (`vThreshold`) to calculate a new `Flag` column. Optionally, a second column
#' of numeric values (identified by `strValueColumn`) can be specified to set the directionality of
#' the `Flag`.
#'
#' In short, the following columns are considered:
#' - `GroupID` - Group ID (required)
#' - `strColumn` - A column to use for Thresholding (required)
#' - 'strValueColumn' - A column to be used for the sign of the flag (optional)
#'
#' @param dfAnalyzed data.frame where flags should be added.
#' @param vThreshold Vector of 2 numeric values representing lower and upper p-value thresholds.
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
#' dfAnalyzed <- Analyze_Poisson(dfTransformed)
#'
#' dfFlagged <- Flag(dfAnalyzed, vThreshold = c(-5, 5))
#'
#'
#' @import dplyr
#' @importFrom stats median
#'
#' @export

Flag_Fisher <- function(
  dfAnalyzed,
  vThreshold = NULL
) {
  stopifnot(
    "dfAnalyzed is not a data frame" = is.data.frame(dfAnalyzed),
    "vThreshold is not numeric" = is.numeric(vThreshold),
    "vThreshold must be length of 2" = length(vThreshold) == 2,
    "vThreshold cannot be NULL" = !is.null(vThreshold)
  )

  # Flag values outside the specified threshold.
  median <- median(dfTransformed$Metric)

  dfFlagged <- dfAnalyzed %>%
    mutate(
      Flag = case_when(
        (.data$Score < min(vThreshold) & .data$Metric >= median) ~ 2,
        (.data$Score < min(vThreshold) & .data$Metric < median) ~ -2,
        (.data$Score < max(vThreshold) & .data$Metric >= median) ~ 1,
        (.data$Score < max(vThreshold) & .data$Metric < median) ~ -1,
        TRUE ~ 0
      )
    )

  dfFlagged <- dfFlagged %>%
    arrange(match(.data$Flag, c(-2, 2, 1, -1, 0)))

  return(dfFlagged)
}
