% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ExportCode.R
\name{ExportCode}
\alias{ExportCode}
\title{Export gsm analysis script using Data, Mapping, and Workflow.}
\usage{
ExportCode(
  lData,
  lMapping,
  lAssessments,
  bInsertText = FALSE,
  strPath = NULL,
  strFileName = NULL
)
}
\arguments{
\item{lData}{\code{list} rawplus data to use as inputs.}

\item{lMapping}{\code{list} Standard mapping provided for \code{\link[=FilterDomain]{FilterDomain()}} and \verb{*_Map_Raw()} functions.}

\item{lAssessments}{\code{list} The result of running \code{\link[=MakeWorkflowList]{MakeWorkflowList()}}, or a custom workflow.}

\item{bInsertText}{\code{logical} Should code be inserted into a new .R file? Default: \code{TRUE}.}

\item{strPath}{\code{character} Path for where the code should be saved.}

\item{strFileName}{\code{character} Name of file to save.}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}
}
\examples{
\dontrun{

lData <- list(
  dfSUBJ = clindata::rawplus_dm,
  dfAE = clindata::rawplus_ae,
  dfPD = clindata::ctms_protdev,
  dfCONSENT = clindata::rawplus_consent,
  dfIE = clindata::rawplus_ie,
  dfLB = clindata::rawplus_lb,
  dfSTUDCOMP = clindata::rawplus_studcomp,
  dfSDRGCOMP = clindata::rawplus_sdrgcomp
)


lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

lAssessments <- gsm::MakeWorkflowList()

code <- ExportCode(lData, lMapping, lAssessments)
}

}
