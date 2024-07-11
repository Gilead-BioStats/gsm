#' config_workflow Dataset
#'
#' @format A data frame with 26 rows and 4 columns:
#' \describe{
#'   \item{studyid}{Study ID, chr, constant value "AA-AA-000-0000"}
#'   \item{workflowid}{workflow ID, chr, kri value "kri0001"}
#'   \item{gsm_version}{gsm version used, chr, most recent version installed i.e. "1.9.2"}
#'   \item{active}{active status of workflow, lgl}
#' }
#' @source Generated from `config_workflow.csv` dataset in the `gsm` package.
"config_workflow"

#' meta_param Dataset
#'
#' @format A data frame with 176 rows and 6 columns:
#' \describe{
#'   \item{workflowid}{workflow ID, chr, kri value "kri0001"}
#'   \item{gsm_version}{gsm version used, chr, most recent version installed i.e. "1.9.2"}
#'   \item{param}{parameter name, chr, i.e. "vThreshold"}
#'   \item{index}{index value for parameter, int}
#'   \item{default}{default value for parameter at index, int, i.e. -3}
#'   \item{configurable}{is parameter configuable, lgl}
#' }
#'
#' @source Generated from `meta_param.csv` dataset in the `gsm` package.
"meta_param"

#' Load Default Clindata Groups
#'
#' Load and clean group data for use as default values.
#'
#' @return A data frame with group data.
#' @export
#'
#' @examples
#' example_groups()
example_groups <- function() {
  clindata::ctms_site %>%
    dplyr::left_join(
      clindata::rawplus_dm %>%
        dplyr::group_by(.data$siteid) %>%
        dplyr::tally(name = "enrolled_participants"),
      c('site_num' = 'siteid')
    ) %>%
    dplyr::rename(
      SiteID = "site_num",
      status = "site_status"
    )
}

#' sampleBounds Dataset
#'
#' @format A data frame with 12667 rows and 8 columns:
#' \describe{
#'   \item{Threshold}{number of standard deviations that the upper and lower bounds are based on}
#'   \item{Denominator}{calculated denominator value}
#'   \item{LogDenominator}{calculated log denominator value}
#'   \item{Numerator}{calculated numerator value}
#'   \item{Metric}{calculated rate/metric value}
#'   \item{MetricID}{unique metric identifier}
#'   \item{StudyID}{unique study identifier}
#'   \item{SnapshotDate}{date of the snapshot}
#' }
#' @source Generated from `sampleBounds.csv` dataset in the `gsm` package.
"sampleBounds"

#' sampleGroups Dataset
#'
#' @format A data frame with 3903 rows and 4 columns:
#' \describe{
#'   \item{GroupID}{grouping variable}
#'   \item{GroupLevel}{level of grouping variable}
#'   \item{Param}{Parameter of interest for the group}
#'   \item{Value}{Value of specified Param}
#' }
#' @source Generated from `sampleGroups.csv` dataset in the `gsm` package.
"sampleGroups"

#' sampleInput Dataset
#'
#' @format A data frame with 25 rows and 5 columns:
#' \describe{
#'   \item{SubjectID}{unique subject identifier}
#'   \item{GroupID}{grouping variable}
#'   \item{GroupLevel}{level of grouping variable}
#'   \item{Numerator}{number of flags in group}
#'   \item{Denominator}{total subjects in group}
#' }
#' @source Generated from `sampleInput.csv` dataset in the `gsm` package.
"sampleInput"

#' sampleMetrics Dataset
#'
#' @format A data frame with 12 rows and 11 columns:
#' \describe{
#'   \item{MetricID}{unique metric identifier}
#'   \item{File}{yaml file for workflow}
#'   \item{GroupLevel}{level of grouping variable}
#'   \item{Abbreviation}{abbreviation for the metric}
#'   \item{Metric}{name of the metric}
#'   \item{Numerator}{data source for the numerator}
#'   \item{Denominator}{data source for the denominator}
#'   \item{Model}{model used to calculate metric}
#'   \item{Score}{type of score reported}
#'   \item{strThreshold}{thresholds to be used for bounds and flags}
#'   \item{nMinDenominator}{minimum denominator required to return a score and calculate a flag}
#' }
#' @source Generated from `sampleMetrics.csv` dataset in the `gsm` package.
"sampleMetrics"

#' sampleResults Dataset
#'
#' @format A data frame with 2574 rows and 10 columns:
#' \describe{
#'   \item{GroupID}{grouping variable}
#'   \item{GroupLevel}{level of grouping variable}
#'   \item{Numerator}{number of flags in group}
#'   \item{Denominator}{total subjects in group}
#'   \item{Metric}{calculated rate/metric value}
#'   \item{Score}{statistical score}
#'   \item{Flag}{ordinal flag to be applied}
#'   \item{MetricID}{unique metric identifier}
#'   \item{StudyID}{unique study identifier}
#'   \item{SnapshotDate}{date of the snapshot}
#' }
#' @source Generated from `sampleResults.csv` dataset in the `gsm` package.
"sampleResults"

#' sampleSummary Dataset
#'
#' @format A data frame with 2126 rows and 7 columns:
#' \describe{
#'   \item{GroupID}{grouping variable}
#'   \item{GroupLevel}{level of grouping variable}
#'   \item{MetricID}{unique metric identifier}
#'   \item{Numerator}{number of flags in group}
#'   \item{Denominator}{total subjects in group}
#'   \item{Metric}{calculated rate/metric value}
#'   \item{Score}{statistical score}
#'   \item{Flag}{ordinal flag to be applied}
#'   \item{StudyID}{unique study identifier}
#'   \item{SnapshotDate}{date of the snapshot}
#' }
#' @source Generated from `sampleSummary.csv` dataset in the `gsm` package.
"sampleSummary"
