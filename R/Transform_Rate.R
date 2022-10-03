#' Transform - Rate
#'
#' Calculate a site-level Rate
#'
#' @details
#'
#' This function transforms data to prepare it for the Analysis step
#'
#' @section Data Specification:
#'
#' The input data (`dfInput`) for the AE Assessment is typically created using any of these functions:
#'  \code{\link{AE_Map_Raw}}
#'  \code{\link{AE_Map_Adam}}
#'  \code{\link{Disp_Map_Raw}}
#'  \code{\link{LB_Map_Raw}}
#'  \code{\link{PD_Map_Raw}}
#'
#' (`dfInput`) must include the columns specified by `strNumeratorCol`, `strDenominatorCol` and `strGroupCol`
#'
#' @param dfInput A data.frame with one record per person.
#' @param strNumeratorCol Required. Numerical or logical. Column to be counted.
#' @param strDenominatorCol Optional. Numerical `Exposure` column.
#' @param strGroupCol `character` Required. Name of column for grouping variable. Default: `"SiteID"`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one row per site with columns SiteID, TotalCount with additional columns Exposure and Rate if strExposureCol is used.
#'
#' @examples
#' dfInput <- AE_Map_Raw()
#' dfTransformed <- Transform_Rate(dfInput,
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
#'
#' @importFrom cli cli_alert_warning
#' @import dplyr
#'
#' @export

Transform_Rate <- function(
  dfInput,
  strNumeratorCol,
  strDenominatorCol = NULL,
  strGroupCol = "SiteID",
  bQuiet = TRUE
) {
  stopifnot(
    "dfInput is not a data frame" = is.data.frame(dfInput),
    "strNumeratorColumn is not numeric" = is.numeric(dfInput[[strNumeratorCol]]),
    "strDenominatorColumn is not numeric" = is.numeric(dfInput[[strDenominatorCol]]),
    "NA's found in numerator" = !anyNA(dfInput[[strNumeratorCol]]),
    "NA's found in denominator" = !anyNA(dfInput[[strDenominatorCol]]),
    "Required columns not found in input data" = c(strNumeratorCol, strDenominatorCol, strGroupCol) %in% names(dfInput)
  )

  dfTransformed <- dfInput %>%
    group_by(GroupID = .data[[strGroupCol]]) %>%
    summarise(
      Numerator = sum(.data[[strNumeratorCol]]),
      Denominator = sum(.data[[strDenominatorCol]])
    ) %>%
    mutate(Metric = .data$Numerator / .data$Denominator) %>%
    select(.data$GroupID, everything()) %>%
    filter(
      !is.nan(.data$Metric),
      .data$Metric != Inf
    ) # issue arises where a site has enrolled a participant but participant has not started treatment > exposure is 0 > rate is NaN or Inf

  if (nrow(dfTransformed) < length(unique(dfInput[[strGroupCol]]))) {
    if (!bQuiet) {
      cli::cli_alert_warning(
        "{length(unique(dfInput[[ strGroupCol ]])) - nrow(dfTransformed)} values of [ {strGroupCol} ] with a [ {strDenominatorCol} ] value of 0 removed."
      )
    }
  }

  return(dfTransformed)
}
