% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Report_StudyInfo.R
\name{Report_StudyInfo}
\alias{Report_StudyInfo}
\title{Report Study Information}
\usage{
Report_StudyInfo(
  dfGroups,
  lStudyLabels = NULL,
  strId = "study_table",
  tagHeader = htmltools::h2("Study Status"),
  lStudy = deprecated()
)
}
\arguments{
\item{dfGroups}{\code{data.frame} Group-level metadata dictionary. Created by
passing CTMS site and study data to \code{\link[=MakeLongMeta]{MakeLongMeta()}}. Expected columns:
\code{GroupID}, \code{GroupLevel}, \code{Param}, \code{Value}.}

\item{lStudyLabels}{\code{list} A list containing study labels. Default is NULL.}

\item{strId}{\code{character} A string to identify the output table.}

\item{tagHeader}{\code{shiny.tag} An HTML tag or tags to use as a header for the
table.}

\item{lStudy}{\code{deprecated} Study information as a named list.}
}
\value{
A \code{\link[htmltools:tagList]{htmltools::tagList()}} to display a table of study information.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#stable}{\figure{lifecycle-stable.svg}{options: alt='[Stable]'}}}{\strong{[Stable]}}

This function generates a table summarizing study metadata as an interactive
\code{\link[gt:gt]{gt::gt()}} wrapped in HTML.
}
