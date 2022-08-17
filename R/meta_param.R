#' Meta Param
#'
#' A dataset containing the assessment parameter metadata needed supported KRI/QTLs.
#'
#' @format A data frame with 8 rows and 12 variables:
#' \describe{
#'   \item{workflowid}{Workflow ID}
#'   \item{gsm_version}{Version of `gsm` that the workflow will be run on.}
#'   \item{param}{Name of function parameter.}
#'   \item{index}{Index that describes the position of the parameter values.}
#'   \item{default}{Default parameter.}
#'   \item{configurable}{Boolean denoting whether the parameter can be configured to use a different argument.}
#' @source \url{https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html}
"meta_param"
