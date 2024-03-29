% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Visualize_Scatter.R
\name{Visualize_Scatter}
\alias{Visualize_Scatter}
\title{Group-level visualization of group-level results}
\usage{
Visualize_Scatter(
  dfSummary,
  dfBounds = NULL,
  strGroupCol = NULL,
  strGroupLabel = NULL,
  strUnit = "days",
  vColors = c("#999999", "#FADB14", "#FF4D4F")
)
}
\arguments{
\item{dfSummary}{\code{data.frame} returned by \code{\link[=Summarize]{Summarize()}}}

\item{dfBounds}{\code{data.frame} data.frame giving prediction bounds for range of denominator in dfSummary.}

\item{strGroupCol}{\code{character} name of stratification column for facet wrap Default: \code{NULL}}

\item{strGroupLabel}{\code{character} name of group, used for labeling axes. Default: \code{NULL}}

\item{strUnit}{\code{character} exposure time unit. Default: \code{days}}

\item{vColors}{\code{character} vector of hex colors for plotting boundaries/thresholds. Index 1: mean; index 2: first threshold boundary; index 3: second threshold boundary.}
}
\value{
group-level plot object.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#stable}{\figure{lifecycle-stable.svg}{options: alt='[Stable]'}}}{\strong{[Stable]}}
}
\examples{
dfInput <- AE_Map_Adam()
SafetyAE <- AE_Assess(dfInput)
dfBounds <- Analyze_Poisson_PredictBounds(SafetyAE$lData$dfTransformed, c(-5, 5))
Visualize_Scatter(SafetyAE$lData$dfSummary, dfBounds)

# TODO: add stratified example

}
