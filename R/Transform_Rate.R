#' Transform Rate
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Convert from input data format to needed input format to derive KRI for an Assessment. Calculate a site-level rate.
#'
#' @details
#'
#' This function transforms data to prepare it for the analysis step. It is currently only sourced for the Adverse Event, Disposition, Labs, and Protocol Deviations Assessments.
#'
#' @section Data Specification:
#'
#' The input data (`dfInput`) for the Assessment is typically created using any of these functions:
#'  \code{\link{AE_Map_Raw}}
#'  \code{\link{AE_Map_Adam}}
#'  \code{\link{Disp_Map_Raw}}
#'  \code{\link{LB_Map_Raw}}
#'  \code{\link{PD_Map_Raw_Rate}}
#'
#' (`dfInput`) must include the columns specified by `strNumeratorCol`, `strDenominatorCol` and `strGroupCol`.
#' Required columns include:
#' - `SiteID` - Site ID
#' - `StudyID` - Study ID
#' - `CustomGroupID` - Custom Group ID
#' - `Count` - Number of events of interest; the actual name of this column is specified by the parameter `strNumeratorCol`
#' - `Exposure` - Number of days on treatment; the actual name of this column is specified by the parameter `strDenominatorCol`
#'
#' @param dfInput A data.frame with one record per subject.
#' @param strNumeratorCol Required. Numerical or logical. Column to be counted.
#' @param strDenominatorCol `numeric` Required. Numerical `Exposure` column.
#' @param strGroupCol `character` Required. Name of column for grouping variable. Default: `"SiteID"`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one row per site with columns `GroupID`, `Numerator`, `Denominator`, and `Metric`.
#'
#' @examples
#' dfInput <- AE_Map_Raw()
#' dfTransformed <- Transform_Rate(dfInput,
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
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
    select("GroupID", everything()) %>%
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
