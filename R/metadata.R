#' Workflow Metadata
#'
#' A dataset containing the metadata describing the workflows available in GSM. Each row describes a workflow defined in `inst/workflows`.
#'
#' @format A data frame with 8 rows and 12 variables:
#' \describe{
#'   \item{workflowid}{Workflow ID}
#'   \item{gsm_version}{Version of `gsm` that the workflow will be run on.}
#'   \item{group}{Description of grouping variable: `Site`, `Study`, or `Country`.}
#'   \item{abbreviation}{Metric abbreviation - 3 characters max}
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

#' Workflow Parameterization Metadata
#'
#' A dataset containing the the parameters available in GSM workflows. Each row describes a configurable parameter for a workflow defined in `inst/workflows`.
#'
#' @format A data frame with 8 rows and 12 variables:
#' \describe{
#'   \item{workflowid}{Workflow ID}
#'   \item{gsm_version}{Version of `gsm` that the workflow will be run on.}
#'   \item{param}{Name of function parameter.}
#'   \item{index}{Index that describes the position of the parameter values.}
#'   \item{default}{Default parameter.}
#'   \item{configurable}{Boolean denoting whether the parameter can be configured to use a different argument.}
#'   }
#' @source \url{https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html}
"meta_param"

#' RBM Data Specification
#'
#' A dataset containing input/output specifications for gsm and Gizmo.
#'
#' @format A data frame with 125 rows and 4 variables.
#' \describe{
#'   \item{System}{Gismo or GSM}
#'   \item{Table}{Name of the table/data source created by `gsm::Make_Snapshot()`}
#'   \item{Column}{Name of the column in the table}
#'   \item{Description}{Description of `Column`}
#'   }
#' @source \url{https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html}
"rbm_data_spec"
