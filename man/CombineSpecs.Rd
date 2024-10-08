% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util-CombineSpecs.R
\name{CombineSpecs}
\alias{CombineSpecs}
\title{Combine Multiple Specifications}
\usage{
CombineSpecs(lSpecs, bIsWorkflow = TRUE)
}
\arguments{
\item{lSpecs}{A list of lists, where each sublist represents a either a gsm workflow or a spec object from a workflow}

\item{bIsWorkflow}{Is lSpecs a list of workflows? If so, .$spec is extracted. Default: TRUE}
}
\value{
A list representing the combined specifications across all domains.
}
\description{
This function combines multiple domain specifications into a single specification list,
ensuring deduplication of columns, resolving conflicts in the \code{required} field,
and checking for type mismatches.
}
\examples{
spec1 <- list(
  df1 = list(
    col1 = list(required = TRUE),
    col2 = list(required = TRUE)
  ),
  df2 = list(
    col3 = list(required = TRUE),
    col4 = list(required = TRUE)
  )
)

spec2 <- list(
  df1 = list(
    col1 = list(required = TRUE),
    col5 = list(required = TRUE)
  ),
  df3 = list(
    col6 = list(required = TRUE),
    col7 = list(required = TRUE)
  )
)

combined <- CombineSpecs(list(spec1, spec2), bIsWorkflow = FALSE)

mappings <- MakeWorkflowList(strPath = "workflow/1_mappings")
mapping_spec <- CombineSpecs(mappings)

}
