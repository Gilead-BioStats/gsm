% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util-Ingest.R
\name{Ingest}
\alias{Ingest}
\title{Ingests data from a source based on a given specification.}
\usage{
Ingest(lSourceData, lSpec, strDomain = "Raw")
}
\arguments{
\item{lSourceData}{\code{list} A named list of source data frames.}

\item{lSpec}{\code{list} A named list of column specifications.}

\item{strDomain}{\code{character} Domain name to add to the data frames after ingestions. Default: "Raw"

@return \code{list} A named list of data frames, where each data frame corresponds to a domain in the
specification.}
}
\description{
This function ingests data from a source based on a given specification. It iterates over each
domain in the specification and checks if the columns exist in the source data. It then
constructs a query to select the columns from the source and calls the \code{RunQuery} function to
retrieve the data. The resulting data frames are stored in a list, where each data frame
corresponds to a domain in the specification.
}
\examples{
lSourceData <- list(
  Source_STUDY = clindata::ctms_study,
  Source_SITE = clindata::ctms_site,
  Source_SUBJ = clindata::rawplus_dm,
  Source_AE = clindata::rawplus_ae,
  Source_PD = clindata::ctms_protdev,
  Source_LB = clindata::rawplus_lb,
  Source_STUDCOMP = clindata::rawplus_studcomp,
  Source_SDRGCOMP = clindata::rawplus_sdrgcomp,
  Source_QUERY = clindata::edc_queries,
  Source_DATAENT = clindata::edc_data_pages,
  Source_DATACHG = clindata::edc_data_points,
  Source_ENROLL = clindata::rawplus_enroll
)

lIngestWorkflow <- MakeWorkflowList(strPath = "workflow/1_mappings")[[1]]
lRawData <- Ingest(lSourceData, lIngestWorkflow$spec)

}
