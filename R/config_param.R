#' Config Param
#'
#' A dataset containing the parameter configuration metadata needed for supported KRI/QTLs.
#'
#' @format A data frame with 8 rows and 12 variables:
#' \describe{
#'   \item{studyid}{Study ID}
#'   \item{workflowid}{Workflow ID}
#'   \item{gsm_version}{Version of `gsm` that the workflow will be run on.}
#'   \item{param}{Name of function parameter.}
#'   \item{index}{Index that describes the position of the parameter values.}
#'   \item{value}{Parameter value}
#'   }
#' @source \url{https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html}
"config_param"
