#' `r lifecycle::badge("stable")`
#'
#' Run a single step in a workflow
#'
#' @description
#' Runs a single step of an assessment workflow. Currently supports `Filter`, `Map`, and `Assess`
#' functions.
#'
#' @param lStep `list` single workflow step (typically defined in `lWorkflow$workflow`). Should
#'   include the name of the function to run (`lStep$name`), data inputs (`lStep$inputs`), name of
#'   output (`lStep$output`) and configurable parameters (`lStep$params`) (if any)
#' @param lMapping `list` List containing expected columns in each data set.
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
#' @importFrom cli cli_text
#' @importFrom stringr str_detect
#' @importFrom yaml read_yaml
#'
#' @export

RunStep <- function(lStep, lMapping, lData, bQuiet) {
  # prepare parameter list inputs
  if (!bQuiet) cli::cli_text("Preparing parameters for  {.fn {lStep$name}} ...")

  params <- lStep$params
  params$bQuiet <- bQuiet
  # prepare data inputs by function type
  if (stringr::str_detect(lStep$name, "_Map")) {
    params$lMapping <- lMapping
    params$dfs <- lData[lStep$inputs]
    params$bReturnChecks <- TRUE
  } else if (stringr::str_detect(lStep$name, "_Assess")) {
    params$dfInput <- lData[[lStep$inputs]]
  } else if (lStep$name == "FilterDomain") {
    params$lMapping <- lMapping
    params$df <- lData[[lStep$inputs]]
    params$bReturnChecks <- TRUE

    if (is.null(params$df)) {
      params$df <- NA
    }
  } else if (lStep$name == "FilterData") {
    params$dfInput <- lData[[lStep$inputs]]
    params$bReturnChecks <- TRUE
  }



  if (!bQuiet) cli::cli_text("Calling {.fn {lStep$name}} ...")
  return(do.call(lStep$name, params))
}
