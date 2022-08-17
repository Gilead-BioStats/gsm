#' Config Workflow
#'
#' A dataset containing the workflow configuration metadata needed supported KRI/QTLs.
#'
#' @format A data frame with 8 rows and 12 variables:
#' \describe{
#'   \item{studyid}{Study ID}
#'   \item{workflowid}{Workflow ID}
#'   \item{gsm_version}{Version of `gsm` that the workflow will be run on.}
#'   \item{active}{Boolean indicating if the workflow for the specified workflowid is active.}
#'   }
#' @source \url{https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html}
"config_workflow"
