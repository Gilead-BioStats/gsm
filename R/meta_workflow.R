#' Meta Workflow
#'
#' A dataset containing the metadata needed supported KRI/QTLs.
#'
#' @format A data frame with 8 rows and 12 variables:
#' \describe{
#'   \item{studyid}{Study ID}
#'   \item{workflowid}{Workflow ID}
#'   \item{gsm_version}{Version of `gsm` that the workflow will be run on.}
#'   \item{group}{Description of grouping variable: `Site`, `Study`, or `CustomGroup`.}
#'   \item{metric}{Description of the assessment.}
#'   \item{numerator}{The numerator used to calculate the KRI/QTL.}
#'   \item{denominator}{The denominator used to calculate the KRI/QTL.}
#'   \item{outcome}{Description of the outcome. Either `Rate` or `Percent`.}
#'   \item{model}{Statistical model that is used for the assessment.}
#'   \item{score}{Description of the statistical score that is derived. E.g., "Residual from Poisson Model" or "P-value from Fisher's Exact Test".}
#'   \item{data_inputs}{Description of one or more data inputs needed to create the `dfInput` data.frame that is passed to the assessment function.}
#'   \item{data_filters}{Description of parameters to use to filter when creating input data (`dfInput`)}
#' }
#' @source \url{https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html}
"meta_workflow"
