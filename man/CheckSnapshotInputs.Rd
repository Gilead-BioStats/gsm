% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CheckSnapshotInputs.R
\name{CheckSnapshotInputs}
\alias{CheckSnapshotInputs}
\title{Check Snapshot Inputs}
\usage{
CheckSnapshotInputs(snapshot)
}
\arguments{
\item{snapshot}{\code{list} List (`snapshot$lSnapshot) returned from running \code{\link[=Make_Snapshot]{Make_Snapshot()}}.}
}
\value{
\code{list} Named list including:
\itemize{
\item \code{expected_tables} \code{data.frame} with columns \code{in_snapshot}, \code{expected_gismo}, and \code{status}.
\item \code{expected_columns} \code{data.frame} with columns \code{snapshot_table}, \code{snapshot_column}, \code{gismo_table}, \code{gismo_column}, and \code{status}.
\item \code{status_tables} \code{logical} TRUE if all checks pass. FALSE if not.
\item \code{status_columns} \code{logical} TRUE if all checks pass. FALSE if not.
}
}
\description{
Check that the output created from \code{\link[=Make_Snapshot]{Make_Snapshot()}} returns all expected tables and columns within tables as defined by the
data model (\link{rbm_data_spec}).
}
\details{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}
}
\examples{
\dontrun{
snapshot <- Make_Snapshot()
check_snapshot <- CheckSnapshotInputs(snapshot$lSnapshot)
}

}
