#' Run a workflow via it's YAML specification.
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Attempts to run a single assessment (`lWorkflow`) using shared data (`lData`) and metadata (`lMapping`).
#' Calls `RunStep` for each item in `lWorkflow$workflow` and saves the results to `lWorkflow`.
#'
#' @param lWorkflow `list` A named list of metadata defining how the workflow should be run.
#' @param lData `list` A named list of domain-level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param bKeepInputData `boolean` should the input data be returned? Default is `FALSE`.
#' @param bReturnData `boolean` should function return only lData or should meta and steps be included? Default is `TRUE`.
#'
#' @return `list` containing objects named: `steps`, `path`, `name`, `lData`, `lChecks`, `bStatus`, `lWorkflowChecks`, and `lResults`.
#'
#' @examples
#' \dontrun{
#' lAssessments <- MakeWorkflowList("kri0001")
#' lData <- list(
#'   dfAE = clindata::rawplus_ae,
#'   dfCONSENT = clindata::rawplus_consent,
#'   dfDISP = clindata::rawplus_dm,
#'   dfIE = clindata::rawplus_ie,
#'   dfLB = clindata::rawplus_lb,
#'   dfPD = clindata::ctms_protdev,
#'   dfSUBJ = clindata::rawplus_dm
#' )
#' wf_mapping <- MakeWorkflowList("mapping")
#' lMapped <- RunWorkflow(wf_mapping, lData)$lData
#'
#' output <- map(lAssessments, ~ RunWorkflow(., lMapped))
#' }
#' @return `list` contains just lData if `bReturnData` is `TRUE`, otherwise returns the full `lWorkflow` object.
#'
#' @export

RunWorkflow <- function(
  lWorkflow,
  lData = NULL,
  lInputConfig = NULL,
  bReturnData = TRUE,
  bKeepInputData = FALSE
) {
  cli::cli_h1(paste0("Initializing `", lWorkflow$meta$File, "` Workflow"))

  # check that the workflow has steps
  if (length(lWorkflow$steps) == 0) {
    cli::cli_alert("Workflow `{lWorkflow$Meta$File}` has no `steps` property.")
  }

  if (!"meta" %in% names(lWorkflow)) {
    cli::cli_alert("Workflow `{lWorkflow$Meta$File}` has no `meta` property.")
  }

  # If no data is provided, attempt to load data from lInputConfig
  if (is.null(lData) && !is.null(lInputConfig)) {
    cli::cli_alert("No data provided. Attempting to load data from `lInputConfig`.")
    lData <- LoadData(lWorkflow, lInputConfig)
  }

  lWorkflow$lData <- lData

  # If the workflow has a spec, check that the data and spec are compatible
  if ("spec" %in% names(lWorkflow)) {
    cli::cli_h3("Checking data against spec")
    CheckSpec(lData, lWorkflow$spec)
  } else {
    lWorkflow$spec <- NULL
    cli::cli_h3("No spec found in workflow. Proceeding without checking data.")
  }

  # Run through each step in lWorkflow$workflow
  stepCount <- 1
  for (step in lWorkflow$steps) {
    cli::cli_h2(paste0("Workflow Step ", stepCount, " of ", length(lWorkflow$steps), ": `", step$name, "`"))

    result <- RunStep(lStep = step, lData = lWorkflow$lData, lMeta = lWorkflow$meta, lSpec = lWorkflow$spec)

    if (step$output %in% names(lData)) {
      cli::cli_alert_warning("Overwriting existing data in `lData`.")
    }

    lWorkflow$lData[[step$output]] <- result

    if (is.data.frame(result)) {
      cli::cli_h3("{paste(dim(result),collapse='x')} data.frame saved as `lData${step$output}`.")
    } else {
      cli::cli_h3("{typeof(result)} of length {length(result)} saved as `lData${step$output}`.")
    }

    stepCount <- stepCount + 1
  }

  if (!bKeepInputData) {
    outputs <- lWorkflow$steps %>% purrr::map_chr(~ .x$output)
    lWorkflow$lData <- lWorkflow$lData[outputs]
    cli::cli_alert_info("Returning workflow outputs: {names(lWorkflow$lData)}")
  } else {
    cli::cli_alert_info("Returning workflow inputs and outputs: {names(lWorkflow$lData)}")
  }

  cli::cli_h1(paste0("Completed `", lWorkflow$meta$File, "` Workflow"))

  # Save data.
  if (!is.null(lInputConfig)) {
    SaveData(lWorkflow$lData, lInputConfig)
  }

  if (bReturnData) {
    return(lWorkflow$lData)
  } else {
    return(lWorkflow)
  }
}
