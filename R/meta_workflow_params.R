#' Meta Workflow Parameters
#'
#' A dataset containing the parameters for the metadata needed to support kri0001 - kri0008.
#'
#' @format A data frame with 8 rows and 9 variables:
#' \describe{
#'   \item{workflowid}{Workflow ID.}
#'   \item{dfdomain}{Name of expected domain-level data for mapping (e.g., `dfAE` for an AE Assessment).}
#'   \item{dfsubj}{Name of expected subject-level data for mapping, typically `dfSUBJ`.}
#'   \item{label}{Abbreviated label for the Assessment.}
#'   \item{filtercol}{Value of the key/value pair provided to mapping for the filter column.}
#'   \item{filterval}{Value of the key/value pair provided to mapping for the value to be filtered on for the filter column.}
#'   \item{funcmap}{Name of the mapping function.}
#'   \item{funcassess}{Name of the assess function.}
#'   \item{krilabel}{KRI Label.}
#' }
#' @source \url{https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html}
"meta_workflow_params"
