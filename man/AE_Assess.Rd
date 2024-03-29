% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AE_Assess.R
\name{AE_Assess}
\alias{AE_Assess}
\title{Adverse Event Assessment}
\usage{
AE_Assess(
  dfInput,
  vThreshold = NULL,
  strMethod = "NormalApprox",
  lMapping = yaml::read_yaml(system.file("mappings", "AE_Assess.yaml", package = "gsm")),
  lLabels = list(workflowid = "", group = strGroup, abbreviation = "AE", metric =
    "Adverse Event Rate", numerator = "Adverse Events", denominator = "Days on Study",
    model = "Normal Approximation", score = "Adjusted Z-Score"),
  strGroup = "Site",
  nMinDenominator = NULL,
  bMakeCharts = FALSE,
  bQuiet = TRUE
)
}
\arguments{
\item{dfInput}{\code{data.frame} Input data, a data frame with one record per subject.}

\item{vThreshold}{\code{numeric} Threshold specification, a vector of length 4 that defaults to \code{c(-3, -2, 2, 3)} for a Normal Approximation,
\code{c(-7, -5, 5, 7)} for a Poisson model (\code{strMethod = "Poisson"}) and a vector of length 2 that defaults to \code{c(0.00006, 0.01)}
for a nominal assessment (\code{strMethod = "Identity"}).}

\item{strMethod}{\code{character} Statistical method. Valid values:
\itemize{
\item \code{"NormalApprox"} (default)
\item \code{"Poisson"}
\item \code{"Identity"}
}}

\item{lMapping}{\code{list} Column metadata with structure \code{domain$key}, where \code{key} contains the name
of the column. Default: package-defined Adverse Event Assessment mapping.}

\item{lLabels}{\code{list} Labels used to populate chart labels.}

\item{strGroup}{\code{character} Grouping variable. \code{"Site"} (the default) uses the column named in \code{mapping$strSiteCol}. Other valid options using the default mapping are \code{"Study"}, \code{"Country"}, and \code{"CustomGroup"}.
Other valid options using the default mapping are \code{"Study"} and \code{"CustomGroup"}.}

\item{nMinDenominator}{\code{numeric} Specifies the minimum denominator required to return a \code{score} and calculate a \code{flag}. Default: NULL}

\item{bMakeCharts}{\code{logical} Boolean value indicating whether to create charts.}

\item{bQuiet}{\code{logical} Suppress warning messages? Default: \code{TRUE}}
}
\value{
\code{list} \code{lData}, a named list with:
\itemize{
\item each data frame in the data pipeline
\itemize{
\item \code{dfTransformed}, returned by \code{\link[=Transform_Rate]{Transform_Rate()}}
\item \code{dfAnalyzed}, returned by \code{\link[=Analyze_NormalApprox]{Analyze_NormalApprox()}}, \code{\link[=Analyze_Poisson]{Analyze_Poisson()}}, or \code{\link[=Analyze_Identity]{Analyze_Identity()}}
\item \code{dfFlagged}, returned by \code{\link[=Flag_NormalApprox]{Flag_NormalApprox()}}, \code{\link[=Flag_Poisson]{Flag_Poisson()}}, or \code{\link[=Flag]{Flag()}}
\item \code{dfSummary}, returned by \code{\link[=Summarize]{Summarize()}}
\item \code{dfBounds}, returned by \code{\link[=Analyze_NormalApprox_PredictBounds]{Analyze_NormalApprox_PredictBounds()}} or \code{\link[=Analyze_Poisson_PredictBounds]{Analyze_Poisson_PredictBounds()}}
when \code{strMethod == "NormalApprox"} or \code{strMethod == "Poisson"}. \code{dfBounds} is not returned when using \code{strMethod == "Identity"}.
}
\item \code{list} \code{lCharts}, a named list with:
\itemize{
\item \code{scatter}, a ggplot2 object returned by \code{\link[=Visualize_Scatter]{Visualize_Scatter()}} only when \code{strMethod != "Identity"}
\item \code{barMetric}, a ggplot2 object returned by \code{\link[=Visualize_Score]{Visualize_Score()}}
\item \code{barScore}, a ggplot2 object returned by \code{\link[=Visualize_Score]{Visualize_Score()}}
}
\item \code{list} \code{lChecks}, a named list with:
\itemize{
\item \code{dfInput}, a named list returned by \code{\link[=is_mapping_valid]{is_mapping_valid()}}
\item \code{status}, a boolean returned by \code{\link[=is_mapping_valid]{is_mapping_valid()}}
\item \code{mapping}, a named list that is provided as an argument to the \code{lMapping} parameter in \code{\link[=AE_Assess]{AE_Assess()}}
\item \code{spec}, a named list used to define variable specifications
}
}
}
\description{
Evaluates Adverse Event (AE) rates to identify sites that may be over- or under-reporting AEs.
}
\details{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#stable}{\figure{lifecycle-stable.svg}{options: alt='[Stable]'}}}{\strong{[Stable]}}

The AE Assessment uses the standard \href{https://gilead-biostats.github.io/gsm/articles/DataPipeline.html}{GSM data pipeline} to flag possible outliers. Additional details regarding the data pipeline and statistical
methods are described below.
}
\section{Data specification}{
\tabular{llllll}{
   \strong{Domain} \tab \strong{Column Key} \tab \strong{Default Value} \tab \strong{Required?} \tab \strong{Require Unique Values?} \tab \strong{Accept NA/Empty Values?} \cr
   dfInput \tab strIDCol \tab SubjectID \tab TRUE \tab TRUE \tab FALSE \cr
   dfInput \tab strCountCol \tab Count \tab TRUE \tab FALSE \tab FALSE \cr
   dfInput \tab strExposureCol \tab Exposure \tab TRUE \tab FALSE \tab TRUE \cr
   dfInput \tab strRateCol \tab Rate \tab TRUE \tab FALSE \tab TRUE \cr
   dfInput \tab strGroupCol \tab SiteID \tab TRUE \tab FALSE \tab FALSE \cr
}
}

\section{Statistical assumptions}{
The default function \code{Analyze_NormalApprox} applies funnel plots using
asymptotic limits based on normal approximation of binomial distribution
for the binary outcome, or normal approximation of Poisson distribution
for the rate outcome with volume (the sample sizes or total exposure of
the sites) to assess data quality and safety.

Alternatively, a Poisson model is used to generate estimates and
p-values for each site (as specified with the \code{strMethod} parameter).
Those model outputs are then used to flag possible outliers using the
thresholds specified in \code{vThreshold}. Sites with an estimate less than
-5 are flagged as -1 and greater than 5 are flagged as 1 by default.

See \code{\link[=Analyze_NormalApprox]{Analyze_NormalApprox()}} or
\code{\link[=Analyze_Poisson]{Analyze_Poisson()}} for additional
details about the statistical methods and their assumptions.
}

\examples{
dfInput <- AE_Map_Raw()

# Run using normal approximation method (default)
ae_assessment_NormalApprox <- AE_Assess(dfInput)

# Run using Poisson method
ae_assessment_poisson <- AE_Assess(dfInput, strMethod = "Poisson")

# Run using Identity method
ae_assessment_identity <- AE_Assess(dfInput, strMethod = "Identity")

}
