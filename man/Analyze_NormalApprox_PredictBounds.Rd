% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Analyze_NormalApprox_PredictBounds.R
\name{Analyze_NormalApprox_PredictBounds}
\alias{Analyze_NormalApprox_PredictBounds}
\title{Funnel Plot Analysis with Normal Approximation - Predicted Boundaries.}
\usage{
Analyze_NormalApprox_PredictBounds(
  dfTransformed,
  vThreshold = c(-3, -2, 2, 3),
  strType = "binary",
  nStep = NULL,
  bQuiet = TRUE
)
}
\arguments{
\item{dfTransformed}{\code{data.frame} in format produced by \code{\link{Transform_Rate}}.}

\item{vThreshold}{\code{numeric} upper and lower boundaries based on standard deviation. Should be identical to
the thresholds used in \verb{*_Assess()} functions.}

\item{strType}{\code{character} Statistical method. Valid values:
\itemize{
\item \code{"binary"} (default)
\item \code{"rate"}
}}

\item{nStep}{\code{numeric} step size of imputed bounds.}

\item{bQuiet}{\code{logical} Suppress warning messages? Default: \code{TRUE}}
}
\value{
\code{data.frame} containing predicted boundary values with upper and lower bounds across the
range of observed values.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#stable}{\figure{lifecycle-stable.svg}{options: alt='[Stable]'}}}{\strong{[Stable]}}
}
\details{
Applies a funnel plot analysis with normal approximation to site-level data, and then calculates predicted
percentages/rates and upper- and lower-bounds across the full range of sample sizes/total exposure values.
}
\section{Statistical Methods}{

This function applies a funnel plot analysis with normal approximation to site-level data and then calculates
predicted percentages/rates and upper- and lower- bounds (funnels) based on the standard deviation from the mean
across the full range of sample sizes/total exposure values.
}

\section{Data Specification}{


The input data (\code{dfTransformed}) for \code{Analyze_NormalApprox_PredictBounds} is typically created using
\code{\link{Transform_Rate}} and should be one record per site with columns for:
\itemize{
\item \code{GroupID} - Site ID
\item \code{Numerator} - Total number of participants at site with event of interest/Total number of events of interest at site
\item \code{Denominator} - Total number of participants at site/Total number of days of exposure at site
\item \code{Metric} - Proportion of participants at site with event of interest/Rate of events at site (Numerator / Denominator)
}
}

\examples{
# Binary
dfInput <- Disp_Map_Raw()
dfTransformed <- Transform_Rate(
  dfInput,
  strGroupCol = "SiteID",
  strNumeratorCol = "Count",
  strDenominatorCol = "Total"
)
dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "binary")
dfBounds <- Analyze_NormalApprox_PredictBounds(dfTransformed, c(-3, -2, 2, 3), strType = "binary")

# Rate
dfInput <- AE_Map_Raw() \%>\% na.omit()
dfTransformed <- Transform_Rate(
  dfInput,
  strGroupCol = "SiteID",
  strNumeratorCol = "Count",
  strDenominatorCol = "Exposure"
)
dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "rate")
dfBounds <- Analyze_NormalApprox_PredictBounds(dfTransformed, c(-3, -2, 2, 3), strType = "rate")

}
