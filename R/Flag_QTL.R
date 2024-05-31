#' Flag QTL
#'
#' `r lifecycle::badge("experimental")`
#'
#' @description
#' This function flags a study-level QTL metric by comparing the mean and lower confidence bound for the metric to a single threshold.
#'
#' @section Data Specification:
#' \code{Flag_NormalApprox} is designed to support the input data (`dfAnalyzed`) from \code{Analyze_QTL} function.
#' At a minimum, the input data must have numeric `Score` and `LowCI` columns that will be compared to the specified threshold (`vThreshold`) to
#' calculate a new `Flag` column.
#'
#' @param dfAnalyzed data.frame where flags should be added.
#' @param vThreshold Numeric value representing the threshold. NA and NaN values in strColumn are given NA flag values.
#'
#' @return `data.frame` with "Flag" column added
#'
#' @examples
#' # binary
#' dfTransformed <- tibble::tibble(
#'   GroupID      = c("AA-AA-000-0000"),
#'   Numerator    = c(122),
#'   Denominator  = c(1301),
#'   Metric       = c(0.0938)
#' )
#'
#' dfAnalyzed <- Analyze_QTL(dfTransformed, strOutcome = "binary")
#' dfFlagged <- Flag_QTL(dfAnalyzed, vThreshold = 0.2)
#'
#' # rate
#' dfTransformedRate <- tibble::tibble(
#'   GroupID      = c("AA-AA-000-0000"),
#'   Numerator    = c(4473),
#'   Denominator  = c(6.19),
#'   Metric       = c(723)
#' )
#' dfAnalyzed <- Analyze_QTL(dfTransformedRate, strOutcome = "rate")
#' dfFlagged <- Flag_QTL(dfAnalyzed, vThreshold = 0.01)
#'
#' @export

Flag_QTL <- function(
  dfAnalyzed,
  vThreshold = NULL
) {
  stopifnot(
    "dfAnalyzed is not a data frame" = is.data.frame(dfAnalyzed),
    "Required columns not found" = all(c("Estimate", "LowCI") %in% names(dfAnalyzed)),
    "vThreshold is not numeric" = is.numeric(vThreshold),
    "vThreshold must be length of 1" = length(vThreshold) == 1,
    "vThreshold cannot be NULL" = !is.null(vThreshold)
  )

  # Flag values outside the specified threshold.
  dfFlagged <- dfAnalyzed %>%
    mutate(
      Flag = case_when(
        (.data$LowCI > vThreshold) ~ 2,
        (.data$Estimate > vThreshold) ~ 1,
        (.data$Estimate <= vThreshold) ~ 0
      )
    )

  dfFlagged <- dfFlagged %>%
    arrange(match(.data$Flag, c(2, 1, 0)))

  return(dfFlagged)
}
