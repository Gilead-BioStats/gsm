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
    use_context <- !is.null(lStep$context) && !is.null(lData$context)
    if (length(paramVal) == 1) {
      if (paramVal == "lMeta") {
        # Pass lMeta (typically from the workflow header)
        cli::cli_alert_success("{paramName} = {paramVal}:  Passing full lMeta object.")
        params[[paramName]] <- lMeta
      } else if (paramVal == "lData") {
        # Pass lData
        cli::cli_alert_success("{paramName} = {paramVal}:  Passing full lData object.")
        params[[paramName]] <- lData
      } else if (use_context && paramVal %in% names(lData$context)) {
        # Use named items from context
        cli::cli_alert_success("{paramName} = {paramVal}: Passing lData${lStep$context}${paramVal}.")
        params[[paramName]] <- lData$context[[paramVal]]
      } else if (paramVal %in% names(lData)) {
        cli::cli_alert_success("{paramName} = {paramVal}: Passing lData${paramVal}.")
        params[[paramName]] <- lData[[paramVal]]
      } else if (paramVal %in% names(lMeta)) {
        # Use named items from lMeta
        cli::cli_alert_success("{paramName} = {paramVal}: Passing lMeta${paramVal}.")
        params[[paramName]] <- lMeta[[paramVal]]
      }
    }
    # If the parameter value is not found in 'lMeta' or 'lData', pass the parameter value as a string.
    cli::cli_alert_info("{paramName} = {paramVal}: No matching data found. Passing '{paramVal}' as a string.")
  }

  cli::cli_h3("Calling {.fn {lStep$name}}")
  return(do.call(lStep$name, params))
}
