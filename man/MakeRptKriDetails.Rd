% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util-MakeSnapshotHelpers.R
\name{MakeRptKriDetails}
\alias{MakeRptKriDetails}
\title{Create rpt_kri_detail output for \code{Make_Snapshot()}}
\usage{
MakeRptKriDetails(
  lResults,
  status_site,
  meta_workflow,
  status_workflow,
  gsm_analysis_date = NULL
)
}
\arguments{
\item{lResults}{\code{list} the output from \code{Study_Assess()}}

\item{status_site}{\code{data.frame} the output from \code{Site_Map_Raw()}}

\item{meta_workflow}{\code{data.frame} the meta_workflow stated in lMeta argument of \code{Make_Snapshot()}}

\item{status_workflow}{\code{data.frame} the kri status workflow created with \code{MakeStatusWorkflow()}}

\item{gsm_analysis_date}{\code{string} the gsm analysis date calculated in \code{Make_Snapshot()}. leave NULL if dealing with stacked results}
}
\description{
Create rpt_kri_detail output for \code{Make_Snapshot()}
}
\keyword{internal}
