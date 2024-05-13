#' Transform Count
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Convert from input data format to needed input format to derive KRI for an Assessment. Calculate site-level count.
#'
#' @details
#'
#' This function transforms data to prepare it for the analysis step. It is currently only sourced for the Consent and IE Assessments.
#'
#' @section Data Specification:
#'
#' (`dfInput`) must include the columns specified by `strCountCol` and `strGroupCol`.
#' Required columns include:
#' - `SiteID` - Site ID
#' - `StudyID` - Study ID
#' - `CustomGroupID` - Custom Group ID
#' - `Count` - Number of events of interest; the actual name of this column is specified by the parameter `strCountCol.`
#'
#' The input data has one or more rows per site. `Transform_Count()` sums `strCountCol` for a `TotalCount` for each site. `Metric` is set to `TotalCount` to be used downstream in the workflow.
#'
#' @param dfInput A data.frame with one record per subject.
#' @param strCountCol Required. Numerical or logical. Column to be counted.
#' @param strGroupCol `character` Name of column for grouping variable. Default: `"SiteID"`
#'
#' @return `data.frame` with one row per site with columns `GroupID`, `TotalCount`, and `Metric.`
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
#' dfTransformed <- Transform_Count(dfInput, strCountCol = "Count")
#'
#' @export

Transform_Count <- function(
  dfInput,
  strCountCol,
  strGroupCol = "SiteID"
) {
  stopifnot(
    "dfInput is not a data frame" = is.data.frame(dfInput),
    "strCountCol not found in input data" = strCountCol %in% names(dfInput),
    "strCountCol is not numeric or logical" = is.numeric(dfInput[[strCountCol]]) | is.logical(dfInput[[strCountCol]]),
    "NA's found in strCountCol" = !anyNA(dfInput[[strCountCol]])
  )

  dfTransformed <- dfInput %>%
    group_by(GroupID = .data[[strGroupCol]]) %>%
    summarise(
      TotalCount = sum(.data[[strCountCol]])
    ) %>%
    mutate(Metric = .data$TotalCount) %>%
    select("GroupID", everything())

  return(dfTransformed)
}
