#' Run a single step in a workflow.
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Runs a single step of an assessment workflow. This function is called by `RunWorkflow` for each
#' step in the workflow. It prepares the parameters for the function call, including the metadata,
#' mapping, and data inputs. It then calls the function specified in `lStep$name` with the prepared
#' parameters.
#'
#' @param lStep `list` single workflow step (typically defined in `lWorkflow$workflow`). Should
#'   include the name of the function to run (`lStep$name`), data inputs (`lStep$inputs`), name of
#'   output (`lStep$output`) and configurable parameters (`lStep$params`) (if any)
#' @param lData `list` a named list of domain level data frames.
#' @param lMeta `list` a named list of meta data.
#'
#' @examples
#' wf_mapping <- MakeWorkflowList("mapping")
#' lStep <- MakeWorkflowList("kri0001")[["kri0001"]][["steps"]][[1]]
#' lMeta <- MakeWorkflowList("kri0001")[["kri0001"]][["meta"]]
#' lData <- list(
#'   dfSUBJ = clindata::rawplus_dm,
#'   dfAE = clindata::rawplus_ae,
#'   dfPD = clindata::ctms_protdev,
#'   dfCONSENT = clindata::rawplus_consent,
#'   dfIE = clindata::rawplus_ie
#' )
#' lMapped <- RunWorkflow(wf_mapping, lData)$lData
#'
#' ae_step <- RunStep(lStep = lStep, lData = lMapped, lMeta = lMeta)
#'
#' @return `list` containing the results of the `lStep$name` function call should contain `.$checks`
#'   parameter with results from `is_mapping_vald` for each domain in `lStep$inputs`.
#'
#'
#'
#' @export

RunStep <- function(lStep, lData, lMeta) {
  # prepare parameter list inputs
  params <- lStep$params

  cli::cli_h3("Evaluating {length(params)} parameter(s) for {.fn {lStep$name}}")

  # This loop iterates over each parameter in the 'params' object.

  for (paramName in names(params)) {
    paramVal <- params[[paramName]]
    if (length(paramVal) == 1 && paramVal == "lMeta") {
      # If the parameter value is named "lMeta", the lMeta parameter (typically from the workflow header) is passed
      cli::cli_alert_success("{paramName} = {paramVal}:  Passing full lMeta object.")
      params[[paramName]] <- lMeta
    } else if (length(paramVal) == 1 && paramVal == "lData") {
      # If the parameter value is named "lData", the lData parameter is passed
      cli::cli_alert_success("{paramName} = {paramVal}: Passing full lData object.")
      params[[paramName]] <- lData
    } else if (length(paramVal) == 1 && paramVal %in% names(lMeta)) {
      # If the parameter value is a named item within the 'lMeta' object, it updates the parameter value with the corresponding value from 'lMeta'.
      cli::cli_alert_success("{paramName} = {paramVal}: Passing lMeta${paramVal}.")
      params[[paramName]] <- lMeta[[paramVal]]
    } else if (length(paramVal) == 1 && paramVal %in% names(lData)) {
      # If the parameter value is a named item within the 'lData' object, it updates the parameter value with the corresponding value from 'lData'.
      cli::cli_alert_success("{paramName} = {paramVal}: Passing lData${paramVal}.")
      params[[paramName]] <- lData[[paramVal]]
    } else {
      # If the parameter value is not found in 'lMeta' or 'lData', pass the parameter value as a string.
      cli::cli_alert_info("{paramName} = {paramVal}: No matching data found. Passing '{paramVal}' as a string.")
    }
  }

  cli::cli_h3("Calling {.fn {lStep$name}}")
  return(do.call(lStep$name, params))
}
