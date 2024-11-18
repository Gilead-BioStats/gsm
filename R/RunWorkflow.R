#' Run a workflow via it's YAML specification.
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Attempts to run a single assessment (`lWorkflow`) using shared data (`lData`) and metadata (`lMapping`).
#' Calls `RunStep` for each item in `lWorkflow$workflow` and saves the results to `lWorkflow`.
#'
#' @param lWorkflow `list` A named list of metadata defining how the workflow should be run.
#' @param lData `list` A named list of domain-level data frames.
#' @param bKeepInputData `boolean` should the input data be included in `lData` after the workflow is run? Only relevant when bReturnResult is FALSE. Default is `TRUE`.
#' @param bReturnResult `boolean` should *only* the result from the last step (`lResults`) be returned? If false, the full workflow (including `lResults`) is returned. Default is `TRUE`.
#'
#' @return Object containing the results of the workflow's last step (if `bLastResult` is `TRUE`) or the full workflow object (if `bReturnResults` is `TRUE`) or the full workflow object (if `bReturnResults` is `FALSE`).
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
    bReturnResult = TRUE,
    bKeepInputData = TRUE
) {
  # Create a unique identifier for the workflow
  uid <- paste0(lWorkflow$meta$Type, "_", lWorkflow$meta$ID)
  LogMessage(level = "info", message = "Initializing `{uid}` Workflow", cli_detail = "h1")

  # check that the workflow has steps
  if (length(lWorkflow$steps) == 0) {
    LogMessage(level = "info", message = "Workflow `{uid}` has no `steps` property.", cli_detail = "alert")
  }

  if (!"meta" %in% names(lWorkflow)) {
    LogMessage(level = "info", message = "Workflow `{uid}` has no `meta` property.", cli_detail = "alert")
  }

  lWorkflow$lData <- lData

  # If the workflow has a spec, check that the data and spec are compatible
  if ("spec" %in% names(lWorkflow)) {
    LogMessage(level = "info", message = "Checking data against spec", cli_detail = "h3")
    # TODO: verify domain names in [ lData ] exist in [ lWorkflow$spec ]
    CheckSpec(lData, lWorkflow$spec)
  } else {
    lWorkflow$spec <- NULL
    LogMessage(level = "info", message = "No spec found in workflow. Proceeding without checking data.", cli_detail = "h3")
  }

  # Run through each step in lWorkflow$workflow
  stepCount <- 1
  for (step in lWorkflow$steps) {
    LogMessage(
      level = "info",
      message = paste0("Workflow Step ", stepCount, " of ", length(lWorkflow$steps), ": `", step$name, "`"),
      cli_detail = "h2"
    )
    result <- RunStep(
      lStep = step,
      lData = lWorkflow$lData,
      lMeta = lWorkflow$meta,
      lSpec = lWorkflow$spec
    )

    if (step$output %in% names(lData)) {
      LogMessage(level = "warn", message = "Overwriting existing data in `lData`.")
    }

    lWorkflow$lData[[step$output]] <- result
    lWorkflow$lResult <- result

    if (is.data.frame(result)) {
      LogMessage(
        level = "info",
        message = "{paste(dim(result),collapse='x')} data.frame saved as `lData${step$output}`.",
        cli_detail = "h3"
      )
    } else {
      LogMessage(
        level = "info",
        message = "{typeof(result)} of length {length(result)} saved as `lData${step$output}`.",
        cli_detail = "h3"
      )
    }

    stepCount <- stepCount + 1
  }

  # Return the result of the last step (the default) or the full workflow
  if (bReturnResult) {
    if (is.data.frame(lWorkflow$lResult)) {
      LogMessage(
        level = "info",
        message = "Returning results from final step: {paste(dim(lWorkflow$lResult),collapse='x')} data.frame`.",
        cli_detail = "h2"
      )
    } else {
      LogMessage(
        level = "info",
        message = "Returning results from final step: {typeof(lWorkflow$lResult)} of length {length(lWorkflow$lResult)}`.",
        cli_detail = "h2"
      )
    }
    LogMessage(level = "info", message = "Completed `{uid}` Workflow", cli_detail = "h1")
    return(lWorkflow$lResult)
  } else {
    if (!bKeepInputData) {
      outputs <- lWorkflow$steps %>% purrr::map_chr(~ .x$output)
      lWorkflow$lData <- lWorkflow$lData[outputs]
      LogMessage(
        level = "info",
        message = "Keeping only workflow outputs in $lData: {names(lWorkflow$lData)}",
        cli_detail = "alert_info"
      )
    } else {
      LogMessage(
        level = "info",
        message = "Keeping workflow inputs and outputs in $lData: {names(lWorkflow$lData)}",
        cli_detail = "alert_info"
      )
    }
    LogMessage(
      level = "info",
      message = "Returning full workflow object.",
      cli_detail = "h2"
    )
    LogMessage(level = "info", message = "Completed `{uid}` Workflow", cli_detail = "h1")
    return(lWorkflow)
  }
}
