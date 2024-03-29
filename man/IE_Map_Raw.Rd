% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/IE_Map_Raw.R
\name{IE_Map_Raw}
\alias{IE_Map_Raw}
\title{Inclusion/Exclusion Assessment - Raw Mapping}
\usage{
IE_Map_Raw(
  dfs = gsm::UseClindata(list(dfSUBJ = "clindata::rawplus_dm", dfIE =
    "clindata::rawplus_ie")),
  lMapping = gsm::Read_Mapping("rawplus"),
  bReturnChecks = FALSE,
  bQuiet = TRUE
)
}
\arguments{
\item{dfs}{\code{list} Input data frames:
\itemize{
\item \code{dfIE}: \code{data.frame} Criterion-level data with one record subject per criterion. Default: \code{clindata::rawplus_ie}
\item \code{dfSUBJ}: \code{data.frame} Subject-level data with one record per subject. Default: \code{clindata::rawplus_dm}
}}

\item{lMapping}{\code{list} Column metadata with structure \code{domain$key}, where \code{key} contains the name
of the column. Default: package-defined mapping for raw+.}

\item{bReturnChecks}{\code{logical} Return input checks from \code{\link[=is_mapping_valid]{is_mapping_valid()}}? Default: \code{FALSE}}

\item{bQuiet}{\code{logical} Suppress warning messages? Default: \code{TRUE}}
}
\value{
\code{data.frame} Data frame with one record per subject, the input to \code{\link[=IE_Assess]{IE_Assess()}}. If
\code{bReturnChecks} is \code{TRUE} \code{IE_Map_Raw} returns a named \code{list} with:
\itemize{
\item \code{df}: the data frame described above
\item \code{lChecks}: a named \code{list} of check results
}
}
\description{
Convert raw inclusion/exclusion (IE) data, typically processed case report form data, to formatted
input data to \code{\link[=IE_Assess]{IE_Assess()}}.
}
\details{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

\code{IE_Map_Raw} combines IE data with subject-level data to create formatted input data to
\code{\link[=IE_Assess]{IE_Assess()}}. This function creates an input dataset for the IE Assessment
(\code{\link[=IE_Assess]{IE_Assess()}}) by binding subject-level unmet IE criteria counts (derived from \code{dfIE}) to
subject-level data (from \code{dfSUBJ}). Note that the function can generate data summaries for
specific types of IE criteria by passing filtered IE data to \code{dfIE}.
}
\section{Data specification}{
\tabular{lllll}{
   \strong{Domain} \tab \strong{Column Key} \tab \strong{Default Value} \tab \strong{Required?} \tab \strong{Require Unique Values?} \cr
   dfSUBJ \tab strSiteCol \tab siteid \tab TRUE \tab FALSE \cr
   dfSUBJ \tab strIDCol \tab subjid \tab TRUE \tab TRUE \cr
   dfIE \tab strIDCol \tab subjid \tab TRUE \tab FALSE \cr
   dfIE \tab strCategoryCol \tab iecat \tab TRUE \tab FALSE \cr
   dfIE \tab strResultCol \tab ieorres \tab TRUE \tab FALSE \cr
}
}

\examples{
# Run with defaults.
dfInput <- IE_Map_Raw()

# Run with error checking and message log.
dfInput <- IE_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE)

}
