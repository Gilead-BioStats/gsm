#' analyticsInput Dataset
#'
#' `r lifecycle::badge("stable")`
#'
#' @format `r df_dim_desc(analyticsInput)`
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
#' @format `r df_dim_desc(analyticsSummary)`
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
#' @format `r df_dim_desc(reportingGroups)`
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
#' @format `r df_dim_desc(reportingMetrics)`
#' \describe{
#'   \item{MetricID}{unique metric identifier}
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
#'   \item{ID}{ID}
#'   \item{Priority}{Priority in workflow}
#'   \item{Output}{output}
#'   \item{Name}{name}
#'   \item{Description}{description}
#'   \item{AnalysisType}{analysis type}
#' }
#' @source Generated from `reportingMetrics.csv` dataset in the `gsm` package.
"reportingMetrics"

#' reportingBounds Dataset
#'
#'  `r lifecycle::badge("stable")`
#'
#' @format `r df_dim_desc(reportingBounds)`
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
#' @format `r df_dim_desc(reportingResults)`
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


#' reportingGroups_country Dataset
#'
#'  `r lifecycle::badge("stable")`
#'
#' @format `r df_dim_desc(reportingGroups_country)`
#' \describe{
#'   \item{GroupID}{grouping variable}
#'   \item{GroupLevel}{level of grouping variable}
#'   \item{Param}{Parameter of interest for the group}
#'   \item{Value}{Value of specified Param}
#' }
#' @source Generated from `reportingGroups_country.csv` dataset in the `gsm` package.
"reportingGroups_country"

#' reportingMetrics_country Dataset
#'
#'  `r lifecycle::badge("stable")`
#'
#' @format `r df_dim_desc(reportingMetrics_country)`
#' \describe{
#'   \item{MetricID}{unique metric identifier}
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
#'   \item{ID}{ID}
#'   \item{Priority}{Priority in workflow}
#'   \item{Output}{output}
#'   \item{Name}{name}
#'   \item{Description}{description}
#'   \item{AnalysisType}{analysis type}
#' }
#' @source Generated from `reportingMetrics_country.csv` dataset in the `gsm` package.
"reportingMetrics_country"

#' reportingBounds_country Dataset
#'
#'  `r lifecycle::badge("stable")`
#'
#' @format `r df_dim_desc(reportingBounds_country)`
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
#' @source Generated from `reportingBounds_country.csv` dataset in the `gsm` package.
"reportingBounds_country"

#' reportingResults_country Dataset
#'
#'  `r lifecycle::badge("stable")`
#'
#' @format `r df_dim_desc(reportingResults_country)`
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
#' @source Generated from `reportingResults_country.csv` dataset in the `gsm` package.
"reportingResults_country"


#' lSource Dataset
#'
#'  `r lifecycle::badge("stable")`
#'
#' @format `r df_dim_desc(lSource)`
#' \describe{
#'   \item{"Raw_AE"}{AE Source dataset}
#'   \item{"Raw_COUNTRY"}{Country Source dataset}
#'   \item{"Raw_DATACHG"}{DATACHG ource dataset}
#'   \item{"Raw_DATAENT"}{DATAENT Source dataset}
#'   \item{"Raw_ENROLL"}{Enroll Source dataset}
#'   \item{"Raw_LB"}{Lab Source dataset}
#'   \item{"Raw_PD"}{Protocol Deviation Source dataset}
#'   \item{"Raw_PK"}{PK Source dataset}
#'   \item{"Raw_QUERY"}{Query Source dataset}
#'   \item{"Raw_STUDY"}{Study Source dataset}
#'   \item{"Raw_STUDCOMP"}{STUDCOMP Source dataset}
#'   \item{"Raw_SDRGCOMP"}{SDRGCOMP Source dataset}
#'   \item{"Raw_SITE"}{SITE Source dataset}
#'   \item{"Raw_SUBJ"}{SUBJ Source dataset}
#'   }
#' @source Generated from `data-raw/run-gsm.datasim.R`.
"lSource"

df_dim_desc <- function(df) {
  paste0("A data frame with ", dim(df)[1], " rows and ", dim(df)[2], " columns:")
}
