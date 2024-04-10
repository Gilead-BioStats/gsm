#' Run a single step in a workflow.
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Runs a single step of an assessment workflow. Currently supports `Filter`, `Map`, and `Assess`
#' functions.
#'
#' @param lStep `list` single workflow step (typically defined in `lWorkflow$workflow`). Should
#'   include the name of the function to run (`lStep$name`), data inputs (`lStep$inputs`), name of
#'   output (`lStep$output`) and configurable parameters (`lStep$params`) (if any)
#' @param lMapping `list` A named list identifying the columns needed in each data domain.
#' @param lData `list` a named list of domain level data frames. Names should match the values
#'   specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs
#'   from `X_Map_Raw`.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`.
#'
#'
#' @examples
#' lStep <- MakeWorkflowList()[["kri0001"]][["steps"]][[1]]
#'
#' lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
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
#' ae_step <- RunStep(lStep = lStep, lMapping = lMapping, lData = lData, bQuiet = FALSE)
#'
#' @return `list` containing the results of the `lStep$name` function call should contain `.$checks`
#'   parameter with results from `is_mapping_vald` for each domain in `lStep$inputs`.
#'
#'
#'
#' @export

RunStep <- function(lStep, lMapping, lMeta, lData, bQuiet) {
  # prepare parameter list inputs
  if (!bQuiet) cli::cli_text("Preparing parameters for  {.fn {lStep$name}} ...")

  params <- lStep$params

  # This loop iterates over each parameter in the 'params' object.
  for(paramName in names(params)){
    paramVal <- params[[paramName]]

    # If the parameter value is lMeta, provides the list of metadata from the workflow header
    if(length(paramVal) == 1 && paramVal == "lMeta"){
      if (!bQuiet) cli::cli_text("Found metadata. Proceeding ...")
      params[[paramName]] <- lMeta
    }

    # If the parameter value starts with "lMapping", provides the mapping passed to the workflow
    if (stringr::str_detect(paramName, "^lMapping") & length(paramVal) == 1) {
      paramVal <- params[[paramName]]
      if(paramVal == "lMapping"){
        if (!bQuiet) cli::cli_text("Found mapping. Proceeding ...")
        params[[paramName]] <- lMapping
      } else if(stringr::str_detect(paramVal, "^lMapping\\$")){
        #if paramName starts with 'lMapping$', it removes 'lMapping$' from the parameter name and assigns the value to 'lMappingName
        lMappingDomain <- stringr::str_remove(paramVal, "lMapping\\$")

        #Check that lMappingName is a valid key in lMapping and lMapping starts with 'lMapping$'
        if(lMappingDomain %in% names(lMapping)){
          if (!bQuiet) cli::cli_text("Found mapping for `{lMappingDomain}``. Proceeding ...")
          params[[paramName]] <- lMapping[[lMappingDomain]]
        }else{
          cli::cli_alert_warning("`{lMappingDomain}` not found in Mapping. This might bomb soon ...")
        }
      } else {
        cli::cli_alert_warning("Invalid lMapping parameter specified name. This might bomb soon ...")
      }
    }

    # If the parameter name starts with 'df', it checks if the corresponding value exists in the 'lData' object.
    # If the value exists, it updates the parameter value with the corresponding data.frame from 'lData'.
    # If the value does not exist, it displays a warning message.
    if (stringr::str_detect(paramName, "^df")) {
      if(length(paramVal)==1 & all(paramVal %in% names(lData))){
        if (!bQuiet) cli::cli_text("Found data for {paramVal}. Proceeding ...")
        params[[paramName]] <- lData[[paramVal]]
      } else if(length(paramVal) > 1 & all(paramVal %in% names(lData))){
        if (!bQuiet) cli::cli_text("Found data for {paramVal}. Proceeding ...")
        params[[paramName]] <- lData[paramVal]
      } else {
        cli::cli_alert_warning("Data for {paramVal} not found in workflow. This might bomb soon ...")
      }      
    }
  }

  params$bQuiet <- bQuiet
  if (!bQuiet) cli::cli_text("Calling {.fn {lStep$name}} ...")
  return(do.call(lStep$name, params))
}
