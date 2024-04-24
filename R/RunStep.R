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

RunStep <- function(lStep, lData) {
  # prepare parameter list inputs
  cli::cli_text("Preparing parameters for  {.fn {lStep$name}} ...")

  params <- lStep$params

  # This loop iterates over each parameter in the 'params' object.
  for(paramName in names(params)){
    paramVal <- params[[paramName]]

    # If the parameter name starts with 'df', it checks if the corresponding value exists in the 'lData' object.
    # If the value exists, it updates the parameter value with the corresponding data.frame from 'lData'.
    # If the value does not exist, it displays a warning message.
    if (stringr::str_detect(paramName, "^df")) {
      if(length(paramVal)==1 & all(paramVal %in% names(lData))){
        cli::cli_text("Found data for {paramVal}. Proceeding ...")
        params[[paramName]] <- lData[[paramVal]]
      } else if(length(paramVal) > 1 & all(paramVal %in% names(lData))){
        cli::cli_text("Found data for {paramVal}. Proceeding ...")
        params[[paramName]] <- lData[paramVal]
      } else {
        cli::cli_alert_warning("Data for {paramVal} not found in workflow. This might bomb soon ...")
      }      
    }
  }

  cli::cli_text("Calling {.fn {lStep$name}} ...")
  return(do.call(lStep$name, params))
}
