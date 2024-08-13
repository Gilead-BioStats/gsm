#' Transform Rate
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Convert from input data format to needed input format to derive KRI for an Assessment. Calculate a site-level rate.
#'
#' @details
#'
#' This function transforms data to prepare it for the analysis step. It is currently only sourced for the Adverse Event, Disposition, Labs, and Protocol Deviations Assessments.
#'
#' @section Data Specification:
#'
#' (`dfInput`) must include the columns specified by `strNumeratorCol` and `strDenominatorCol`.
#' Required columns include:
#' - `GroupID` - Group ID
#' - `GroupLevel` - Group Type
#' - `Numerator` - Number of events of interest; the actual name of this column is specified by the parameter `strNumeratorCol`
#' - `Denominator` - Number of days on treatment; the actual name of this column is specified by the parameter `strDenominatorCol`
#'
#' @inheritParams shared-params
#' @param strNumeratorCol `string` Column to be counted. Defaults to "Numerator".
#' @param strDenominatorCol `string` Column name for the numerical `Exposure` column. Defaults to "Denominator".
#'
#' @return `data.frame` with one row per site with columns `GroupID`, `GroupLevel`, `Numerator`, `Denominator`, and `Metric`.
#'
#' @examples
#' dfTransformed <- Transform_Rate(
#'   analyticsInput,
#'   strNumeratorCol = "Numerator",
#'   strDenominatorCol = "Denominator"
#' )
#'
#' @export

Transform_Rate <- function(
  dfInput,
  strNumeratorCol = "Numerator",
  strDenominatorCol = "Denominator"
) {
  stopifnot(
    "dfInput is not a data frame" = is.data.frame(dfInput),
    "strNumeratorColumn is not numeric" = is.numeric(dfInput[[strNumeratorCol]]),
    "strDenominatorColumn is not numeric" = is.numeric(dfInput[[strDenominatorCol]]),
    "NA's found in numerator" = !anyNA(dfInput[[strNumeratorCol]]),
    "NA's found in denominator" = !anyNA(dfInput[[strDenominatorCol]]),
    "Required columns not found in input data" = c(strNumeratorCol, strDenominatorCol, "GroupID", "GroupLevel") %in% names(dfInput)
  )

  dfTransformed <- dfInput %>%
    group_by(.data$GroupID, .data$GroupLevel) %>%
    summarise(
      Numerator = sum(.data[[strNumeratorCol]]),
      Denominator = sum(.data[[strDenominatorCol]])
    ) %>%
    ungroup() %>%
    mutate(Metric = .data$Numerator / .data$Denominator) %>%
    filter(
      !is.nan(.data$Metric),
      .data$Metric != Inf
    ) # issue arises where a site has enrolled a participant but participant has not started treatment > exposure is 0 > rate is NaN or Inf

  if (nrow(dfTransformed) < length(unique(dfInput$GroupID))) {
    cli::cli_warn(
      "{length(unique(dfInput[['GroupID']])) - nrow(dfTransformed)} values of [ GroupID ] with a [ {strDenominatorCol} ] value of 0 removed.",
      class = "gsm_wrn-remove_rows"
    )
  }

  return(dfTransformed)
}
