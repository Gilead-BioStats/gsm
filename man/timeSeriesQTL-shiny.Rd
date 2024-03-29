% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Widget_TimeSeriesQTL.R
\name{timeSeriesQTL-shiny}
\alias{timeSeriesQTL-shiny}
\alias{Widget_TimeSeriesQTLOutput}
\alias{renderWidget_TimeSeriesQTL}
\title{Shiny bindings for timeSeriesQTL}
\usage{
Widget_TimeSeriesQTLOutput(outputId, width = "100\%", height = "400px")

renderWidget_TimeSeriesQTL(expr, env = parent.frame(), quoted = FALSE)
}
\arguments{
\item{outputId}{output variable to read from}

\item{width, height}{Must be a valid CSS unit (like \code{'100\%'},
\code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
string and have \code{'px'} appended.}

\item{expr}{An expression that generates a timeSeriesQTL}

\item{env}{The environment in which to evaluate \code{expr}.}

\item{quoted}{Is \code{expr} a quoted expression (with \code{quote()})? This
is useful if you want to save an expression in a variable.}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}
}
\details{
Output and render functions for using timeSeriesQTL within Shiny
applications and interactive Rmd documents.
}
