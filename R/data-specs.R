#' analyticsInput Dataset
#'
#' `r lifecycle::badge("stable")`
#'
#' @format A data frame with 1301 rows and 6 columns:
#' \describe{
#'   \item{SubjectID}{unique subject identifier}
#'   \item{GroupID}{grouping variable}
#'   \item{GroupLevel}{level of grouping variable}
#'   \item{Numerator}{number of flags in group}
#'   \item{Denominator}{total subjects in group}
#'   \item{Metric}{calculated rate/metric value}
#' }
#' @source Generated from `analyticsInput.csv` dataset in the `gsm` package.
"analyticsInput"

#' analyticsSummary Dataset
#'
#'  `r lifecycle::badge("stable")`
#'
#' @format A data frame with 176 rows and 7 columns:
#' \describe{
#'   \item{GroupID}{grouping variable}
#'   \item{GroupLevel}{level of grouping variable}
#'   \item{Numerator}{number of flags in group}
#'   \item{Denominator}{total subjects in group}
#'   \item{Metric}{calculated rate/metric value}
#'   \item{Score}{statistical score}
#'   \item{Flag}{ordinal flag to be applied}
#' }
#' @source Generated from `analyticsSummary.csv` dataset in the `gsm` package.
"analyticsSummary"


#' reportingGroups Dataset
#'
#'  `r lifecycle::badge("stable")`
#'
#' @format A data frame with 3903 rows and 4 columns:
#' \describe{
#'   \item{GroupID}{grouping variable}
#'   \item{GroupLevel}{level of grouping variable}
#'   \item{Param}{Parameter of interest for the group}
#'   \item{Value}{Value of specified Param}
#' }
#' @source Generated from `reportingGroups.csv` dataset in the `gsm` package.
"reportingGroups"

#' reportingMetrics Dataset
#'
#'  `r lifecycle::badge("stable")`
#'
#' @format A data frame with 2 rows and 12 columns:
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
#'   \item{Type}{statistical outcome type}
#'   \item{Threshold}{thresholds to be used for bounds and flags}
#'   \item{nMinDenominator}{minimum denominator required to return a score and calculate a flag}
#' }
#' @source Generated from `reportingMetrics.csv` dataset in the `gsm` package.
"reportingMetrics"

#' reportingBounds Dataset
#'
#'  `r lifecycle::badge("stable")`
#'
#' @format A data frame with 28701 rows and 8 columns:
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
#' @source Generated from `reportingBounds.csv` dataset in the `gsm` package.
"reportingBounds"

#' reportingResults Dataset
#'
#'  `r lifecycle::badge("stable")`
#'
#' @format A data frame with 2286 rows and 10 columns:
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
#' @source Generated from `reportingResults.csv` dataset in the `gsm` package.
"reportingResults"
