#' Flag_NormalApprox
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Add columns flagging sites that represent possible statistical outliers.
#'
#' @details
#' This function flags sites based on the funnel plot with normal approximation analysis result as part of
#' the [GSM data pipeline](https://gilead-biostats.github.io/gsm/articles/DataPipeline.html).
#'
#' @section Data Specification:
#' \code{Flag_NormalApprox} is designed to support the input data (`dfAnalyzed`) from \code{Analyze_NormalApprox} function.
#' At a minimum, the input data must have a `SiteID` column and a column of numeric values (identified
#' by the `strColumn` parameter) that will be compared to the specified thresholds (`vThreshold`) to
#' calculate a new `Flag` column.
#' In short, the following columns are considered:
#' - `GroupID` - Group ID (required)
#' - `strColumn` - A column to use for Thresholding (required)
#' - `strValueColumn` - A column to be used for the sign of the flag (optional)
#'
#' @param dfAnalyzed `data.frame` where flags should be added.
#' @param vThreshold `vector` of 4 numeric values representing lower and upper threshold values. All
#' values in `strColumn` are compared to `vThreshold` using strict comparisons. Values less than the lower threshold or greater than the upper threshold are flagged as -1 and 1 respectively. Values equal to the threshold values are set to 0 (i.e. not flagged). If NA is provided for either threshold value it is ignored, and no values are flagged based on the threshold. NA and NaN values in `strColumn` are given NA flag values.
#'
#' @return `data.frame` with "Flag" column added
#'
#' @examples
#' # Binary
#' dfTransformed <- tibble::tribble(
#'   ~GroupID,  ~Numerator,  ~Denominator,  ~Metric,
#'   139, 5, 901, 0.00555,
#'   143, 3, 170, 0.0176,
#'   162, 3, 370, 0.00811,
#'   167, 3, 360, 0.00833,
#'   173, 6, 680, 0.00882,
#'   189, 4, 815, 0.00491,
#'   29,  2, 450, 0.00444,
#'   5, 5, 730, 0.00685,
#'   58, 1, 225, 0.00444,
#'   78, 2, 50, 0.04
#' )
#' dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "binary")
#' dfFlagged <- Flag_NormalApprox(dfAnalyzed, vThreshold = c(-3, -2, 2, 3))
#'
#' # Rate
#' dfInput <- tibble::tribble(
#'   ~SubjectID, ~SiteID, ~StudyID, ~CountryID, ~CustomGroupID, ~Exposure, ~Count, ~Rate,
#'   "0496", "5", "AA-AA-000-0000", "US", "0X167", 730, 5, 5/720,
#'   "1350", "78", "AA-AA-000-0000", "US", "0X002", 50, 2, 2/50,
#'   "0539", "139", "AA-AA-000-0000", "US", "0X052", 901, 5, 5/901,
#'   "0329", "162", "AA-AA-000-0000", "US", "0X049", 370, 3, 3/370,
#'   "0429", "29", "AA-AA-000-0000", "Japan", "0X116", 450, 2, 2/450,
#'   "1218", "143", "AA-AA-000-0000", "US", "0X153", 170, 3, 3/170,
#'   "0808", "173", "AA-AA-000-0000", "US", "0X124", 680, 6, 6/680,
#'   "1314", "189", "AA-AA-000-0000", "US", "0X093", 815, 4, 4/815,
#'   "1236", "58", "AA-AA-000-0000", "China", "0X091", 225, 1, 1/225,
#'   "0163", "167", "AA-AA-000-0000", "US", "0X059", 360, 3, 3/360
#' )
#' dfTransformed <- Transform_Rate(
#'   dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
#'
#' dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "rate")
#' dfFlagged <- Flag_NormalApprox(dfAnalyzed, vThreshold = c(-3, -2, 2, 3))
#'
#' @export

Flag_NormalApprox <- function(
  dfAnalyzed,
  vThreshold = NULL
) {
  stopifnot(
    "dfAnalyzed is not a data frame" = is.data.frame(dfAnalyzed),
    "vThreshold is not numeric" = is.numeric(vThreshold),
    "vThreshold must be length of 4" = length(vThreshold) == 4,
    "vThreshold cannot be NULL" = !is.null(vThreshold)
  )


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
        (.data$Score >= vThreshold[4]) ~ 2
      )
    )

  dfFlagged <- dfFlagged %>%
    arrange(match(.data$Flag, c(2, -2, 1, -1, 0)))


  return(dfFlagged)
}
