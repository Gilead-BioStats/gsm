#' config_param Dataset
#'
#' @format A data frame with 148 rows and 6 columns:
#' \describe{
#'   \item{studyid}{Study ID, chr, constant value "AA-AA-000-0000"}
#'   \item{workflowid}{workflow ID, chr, kri value "kri0001"}
#'   \item{gsm_version}{gsm version used, chr, most recent version installed i.e. "1.9.2"}
#'   \item{param}{parameter name, chr, i.e. "vThreshold"}
#'   \item{index}{index value for parameter, int}
#'   \item{value}{value for parameter at index, int, i.e. -3}
#' }
#' @source Generated from `config_param.csv` dataset in the `gsm` package.
"config_param"

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


#' meta_workflow Dataset
#'
#' @format A data frame with 26 rows and 12 columns:
#' \describe{
#'   \item{workflowid}{workflow ID, chr, kri value "kri0001"}
#'   \item{gsm_version}{gsm version used, chr, most recent version installed i.e. "1.9.2"}
#'   \item{group}{grouping used for workflow, chr, i.e. "Site"}
#'   \item{abbreviation}{abbraviated name of workflowid (max 3-letters), chr, i.e. "AE"}
#'   \item{metric}{metric label, chr, i.e. "AE Reporting Rate"}
#'   \item{numerator}{Numerator Label, chr, i.e. "AEs"}
#'   \item{denominator}{Denominator Label, chr, i.e. "Days on Study"}
#'   \item{outcome}{Metric outcome type, chr, i.e. "Rate"}
#'   \item{model}{Statistical model used to create score, chr, i.e. "Normal Approximation (Rate)"}
#'   \item{score}{Score Label, chr, i.e. "Adjusted Z-Score"}
#'   \item{data_inputs}{All data inputs for workflow, chr, i.e. "rawplus.ae"}
#'   \item{data_filters}{filters applied in workflow, chr}
#' }
#' @source Generated from `meta_workflow.csv` dataset in the `gsm` package.
"meta_workflow"

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
#'   \item{Threshold}{The number of standard deviations that the upper and lower bounds are based on}
#'   \item{Denominator}{The calculated denominator value}
#'   \item{LogDenominator}{The calculated log denominator value}
#'   \item{Numerator}{The calculated numerator value}
#'   \item{Metric}{The calculated rate/metric value}
#'   \item{MetricID}{The Metric ID}
#'   \item{StudyID}{The Study ID}
#'   \item{SnapshotDate}{The Date of the snapshot}
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
#'   \item{MetricId}{unique metric identifier}
#'   \item{File}{yaml file for workflow}
#'   \item{GroupLevel}{level of grouping variable}
#'   \item{Abbreviation}{abbreviation for the metric}
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
#'   \item{Metric}{The calculated rate/metric value}
#'   \item{Score}{The statistical score}
#'   \item{Flag}{The ordinal flag to be applied}
#'   \item{MetricID}{The Metric ID}
#'   \item{StudyID}{The Study ID}
#'   \item{SnapshotDate}{The Date of the snapshot}
#' }
#' @source Generated from `sampleResults.csv` dataset in the `gsm` package.
"sampleResults"

#' sampleSummary Dataset
#'
#' @format A data frame with 2126 rows and 7 columns:
#' \describe{
#'   \item{GroupID}{grouping variable}
#'   \item{GroupLevel}{level of grouping variable}
#'   \item{Numerator}{number of flags in group}
#'   \item{Denominator}{total subjects in group}
#'   \item{Metric}{The calculated rate/metric value}
#'   \item{Score}{The statistical score}
#'   \item{Flag}{The ordinal flag to be applied}
#' }
#' @source Generated from `sampleSummary.csv` dataset in the `gsm` package.
"sampleSummary"
