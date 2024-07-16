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

#' sampleSummary Dataset
#'
#' @format A data frame with 176 rows and 7 columns:
#' \describe{
#'   \item{GroupID}{grouping variable}
#'   \item{GroupLevel}{level of grouping variable}
#'   \item{MetricID}{unique metric identifier}
#'   \item{Numerator}{number of flags in group}
#'   \item{Denominator}{total subjects in group}
#'   \item{Metric}{calculated rate/metric value}
#'   \item{Score}{statistical score}
#'   \item{Flag}{ordinal flag to be applied}
#' }
#' @source Generated from `sampleSummary.csv` dataset in the `gsm` package.
"sampleSummary"

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


