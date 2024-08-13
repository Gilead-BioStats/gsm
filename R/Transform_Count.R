#' Transform Count
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
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
#' - `GroupID` - Group ID
#' - `GroupLevel` - Group Type
#' - `Numerator` - Number of events of interest; the actual name of this column is specified by the parameter `strNumeratorCol`
#' - `Denominator` - Number of days on treatment; the actual name of this column is specified by the parameter `strDenominatorCol`
#'
#' The input data has one or more rows per site. `Transform_Count()` sums `strCountCol` for a `TotalCount` for each site. `Metric` is set to `TotalCount` to be used downstream in the workflow.
#'
#' @inheritParams shared-params
#' @param strCountCol Required. Numerical or logical. Column to be counted.
#' @param strGroupCol `character` Name of column for grouping variable. Default: `"GroupID"`
#'
#' @return `data.frame` with one row per site with columns `GroupID`, `TotalCount`, and `Metric.`
#'
#' @examples
#' dfTransformed <- Transform_Count(analyticsInput, strCountCol = "Numerator")
#'
#' @export

Transform_Count <- function(
  dfInput,
  strCountCol,
  strGroupCol = "GroupID"
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
