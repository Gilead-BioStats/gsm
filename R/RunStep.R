#' Run a single step in a workflow.
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Runs a single step of an assessment workflow. This function is called by `RunWorkflow` for each 
#' step in the workflow. It prepares the parameters for the function call, including the metadata,
#' mapping, and data inputs. It then calls the function specified in `lStep$name` with the prepared
#' parameters.
#'
#' @param lStep `list` single workflow step (typically defined in `lWorkflow$workflow`). Should
#'   include the name of the function to run (`lStep$name`), data inputs (`lStep$inputs`), name of
#'   output (`lStep$output`) and configurable parameters (`lStep$params`) (if any)
#' @param lData `list` a named list of domain level data frames. Names should match the values
#'   specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs
#'   from `X_Map_Raw`.
#'
#' @examples
#' lStep <- MakeWorkflowList()[["kri0001"]][["steps"]][[1]]
#'
#' lData <- list(
#'   dfSUBJ = clindata::rawplus_dm,
#'   dfAE = clindata::rawplus_ae,
#'   dfPD = clindata::ctms_protdev,
#'   dfCONSENT = clindata::rawplus_consent,
#'   dfIE = clindata::rawplus_ie
#' )
#'
#'
#' ae_step <- RunStep(lStep = lStep, lData = lData)
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

  for(paramName in names(params)){
    paramVal <- params[[paramName]]
    if(length(paramVal) == 1 && paramVal == "lMeta"){
      # If the parameter value is named "lMeta", the lMeta parameter (typically from the workflow header) is passed
      cli::cli_alert_success("{paramName} = {paramVal}:  Passing full lMeta object.")
      params[[paramName]] <- lMeta
    } else if(length(paramVal) == 1 && paramVal == "lData"){
      # If the parameter value is named "lData", the lData parameter (typically from the workflow header) is passed
      cli::cli_alert_success("{paramName} = {paramVal}: Passing full lData object.")
      params[[paramName]] <- lData
    } else if(length(paramVal) == 1 && paramVal %in% names(lMeta)){
      # If the parameter value is a named item within the 'lMeta' object, it updates the parameter value with the corresponding value from 'lMeta'.
      cli::cli_alert_success("{paramName} = {paramVal}: Passing lMeta${paramVal}.")
      params[[paramName]] <- lMeta[[paramVal]]
    } else if(length(paramVal) == 1 && paramVal %in% names(lData)){
      # If the parameter value is a named item within the 'lData' object, it updates the parameter value with the corresponding value from 'lData'.
      cli::cli_alert_success("{paramName} = {paramVal}: Passing lData${paramVal}.")
      params[[paramName]] <- lData[[paramVal]]
    } else {
      # If the parameter value is not found in 'lMeta' or 'lData', pass the parameter value as a string.
      cli::cli_alert_info("{paramName} = {paramVal}: No matching data found. Passing '{paramVal}' as a string.")
    }

    # If the parameter name starts with 'df', it checks if the corresponding value exists in the 'lData' object.
    # If the value exists, it updates the parameter value with the corresponding data.frame from 'lData'.
    # If the value does not exist, it displays a warning message.
    # if (stringr::str_detect(paramName, "^df")) {
    #   if(length(paramVal)==1 & all(paramVal %in% names(lData))){
    #     cli::cli_text("Found data for {paramVal}. Proceeding ...")
    #     params[[paramName]] <- lData[[paramVal]]
    #   } else if(length(paramVal) > 1 & all(paramVal %in% names(lData))){
    #     cli::cli_text("Found data for {paramVal}. Proceeding ...")
    #     params[[paramName]] <- lData[paramVal]
    #   } else {
    #     cli::cli_alert_warning("Data for {paramVal} not found in workflow. This might bomb soon ...")
    #   }      
    # }
  }

  cli::cli_h3("Calling {.fn {lStep$name}}")
  return(do.call(lStep$name, params))
}
