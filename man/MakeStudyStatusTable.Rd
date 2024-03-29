% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util-ReportHelpers.R
\name{MakeStudyStatusTable}
\alias{MakeStudyStatusTable}
\title{Create Status Study table in KRIReport.Rmd}
\usage{
MakeStudyStatusTable(dfStudy, overview_raw_table, longitudinal = NULL)
}
\arguments{
\item{dfStudy}{\code{data.frame} from \code{params} within \code{KRIReport.Rmd}}

\item{overview_raw_table}{\code{data.frame} non interactive output of \code{Overview_Table()} for the relevant report.}

\item{longitudinal}{\code{data.frame} optional argument for longitudinal study information}
}
\description{
Create Status Study table in KRIReport.Rmd
}
\keyword{internal}
