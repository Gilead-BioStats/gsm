% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util-FilterDomain.R
\name{FilterDomain}
\alias{FilterDomain}
\title{Subset a data frame given a mapping.}
\usage{
FilterDomain(
  df,
  strDomain,
  lMapping,
  strColParam,
  strValParam,
  bReturnChecks = FALSE,
  bQuiet = TRUE,
  bRemoveVal = FALSE
)
}
\arguments{
\item{df}{\code{data.frame} A data.frame to be filtered, likely within a mapping function.}

\item{strDomain}{\code{character} Domain step that is being filtered.}

\item{lMapping}{\code{list} A named list identifying the columns needed in each data domain.}

\item{strColParam}{\code{character} Domain in \code{lMapping} that references the column to filter on.}

\item{strValParam}{\code{character} Domain in \code{lMapping} that references the value to filter on.}

\item{bReturnChecks}{\code{logical} Return input checks from \code{is_mapping_valid()}? Default: \code{FALSE}.}

\item{bQuiet}{\code{logical} Suppress warning messages? Default: \code{TRUE}.}

\item{bRemoveVal}{\code{logical} Include the ability to subset on a value or its complement? Default: \code{FALSE}.}
}
\value{
\code{data.frame} Data frame provided as \code{df} and filtered on \code{strColParam} == \code{strValParam}.
If \code{bReturnChecks} is \code{TRUE}, a \code{list} is returned with a filtered \code{df}, and a list of checks run on input data (\code{lChecks}).
}
\description{
\code{FilterDomain} is primarily used in a KRI/assessment workflow, and is used to filter or pre-process input data sources before the creation of \code{dfInput} via a \verb{*_Map_Raw} function.
}
\details{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#stable}{\figure{lifecycle-stable.svg}{options: alt='[Stable]'}}}{\strong{[Stable]}}
}
\examples{
lMapping <- list(dfAE = list(
  strIDCol = "SubjectID", strTreatmentEmergentCol = "AE_TE_FLAG",
  strTreatmentEmergentVal = TRUE, strGradeCol = "AE_GRADE",
  strSeriousCol = "aeser", strSeriousVal = "Y"
))

te_ae <- FilterDomain(
  df = clindata::rawplus_ae,
  lMapping = lMapping,
  strDomain = "dfAE",
  strColParam = "strSeriousCol",
  strValParam = "strSeriousVal"
)

}
