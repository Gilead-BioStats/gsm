% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util-MakeWorkflowList.R
\name{MakeWorkflowList}
\alias{MakeWorkflowList}
\title{Load workflows from a package/directory.}
\usage{
MakeWorkflowList(
  strNames = NULL,
  strPath = NULL,
  bExact = FALSE,
  bRecursive = TRUE
)
}
\arguments{
\item{strNames}{\verb{array of character} List of workflows to include. NULL (the default) includes all workflows in the specified locations.}

\item{strPath}{\code{character} The location of workflow YAML files. If package is specified, function will look in \verb{/inst} folder.}

\item{bExact}{\code{logical} Should strName matches be exact? If false, partial matches will be included. Default FALSE.}

\item{bRecursive}{\code{logical} Find files in nested folders? Default TRUE}
}
\value{
\code{list} A list of workflows with workflow and parameter metadata.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#stable}{\figure{lifecycle-stable.svg}{options: alt='[Stable]'}}}{\strong{[Stable]}}

\code{MakeWorkflowList()} is a utility function that creates a list of workflows for use in KRI pipelines.
}
\examples{
# use default
workflow <- MakeWorkflowList()

# get specific workflow files
workflow <- MakeWorkflowList(strNames = c("kri0001", "kri0005", "cou0003"))

}
