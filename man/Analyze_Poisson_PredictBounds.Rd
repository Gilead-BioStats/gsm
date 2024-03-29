% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Analyze_Poisson_PredictBounds.R
\name{Analyze_Poisson_PredictBounds}
\alias{Analyze_Poisson_PredictBounds}
\title{Poisson Analysis - Predicted Boundaries.}
\usage{
Analyze_Poisson_PredictBounds(
  dfTransformed,
  vThreshold = c(-5, 5),
  nStep = NULL,
  bQuiet = TRUE
)
}
\arguments{
\item{dfTransformed}{\code{data.frame} data.frame in format produced by
\code{\link{Transform_Rate}}. Must include GroupID, N, Numerator and Denominator.}

\item{vThreshold}{\code{numeric} upper and lower boundaries in residual space. Should be identical to
the thresholds used AE_Assess().}

\item{nStep}{\code{numeric} step size of imputed bounds.}

\item{bQuiet}{\code{logical} Suppress warning messages? Default: \code{TRUE}.}
}
\value{
\code{data.frame} containing predicted boundary values with upper and lower bounds across the
range of observed values.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#stable}{\figure{lifecycle-stable.svg}{options: alt='[Stable]'}}}{\strong{[Stable]}}
}
\details{
Fits a Poisson model to site-level data and then calculates predicted count values and upper- and
lower- bounds for across the full range of exposure values.
}
\section{Statistical Methods}{

This function fits a Poisson model to site-level data and then calculates residuals for each
site. The Poisson model is run using standard methods in the \code{stats} package by fitting a \code{glm}
model with family set to \code{poisson} using a "log" link. Upper and lower boundary values are then
calculated using the method described here TODO: Add link.
}

\section{Data Specification}{


The input data (\code{dfTransformed}) for \code{Analyze_Poisson_PredictBounds} is typically created using
\code{\link{Transform_Rate}} and should be one record per site with columns for:
\itemize{
\item \code{GroupID} - Unique subject ID
\item \code{Numerator} - Number of Events
\item \code{Denominator} - Number of days of exposure
}
}

\examples{
dfInput <- AE_Map_Raw()

dfTransformed <- Transform_Rate(dfInput,
  strGroupCol = "SiteID",
  strNumeratorCol = "Count",
  strDenominatorCol = "Exposure"
)

dfBounds <- Analyze_Poisson_PredictBounds(dfTransformed, c(-5, 5))

}
