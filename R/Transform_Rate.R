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
#'
#' @return `data.frame` with one row per site with columns `GroupID`, `Numerator`, `Denominator`, and `Metric`.
#'
#' @examples
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
#'
#' dfTransformed <- Transform_Rate(dfInput,
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
#'
#' @export

Transform_Rate <- function(
  dfInput,
  strNumeratorCol = "Numerator",
  strDenominatorCol = "Denominator",
  strGroupCol = "SiteID"
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
    cli::cli_alert_warning(
      "{length(unique(dfInput[[ strGroupCol ]])) - nrow(dfTransformed)} values of [ {strGroupCol} ] with a [ {strDenominatorCol} ] value of 0 removed."
    )
  }

  return(dfTransformed)
}
