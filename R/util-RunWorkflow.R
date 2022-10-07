#' Run a single assessment
#'
#' Attempts to run a single assessment (`lWorkflow`) using shared data (`lData`) and metadata (`lMapping`).
#' Calls `RunStep` for each item in `lWorkflow$workflow` and saves the results to `lWorkflow`
#'
#' @param lWorkflow `list` A named list of metadata defining how each assessment should be run. Properties should include: `label` and `workflow`
#' @param lData `list` A named list of domain-level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lMapping `list` A named list identifying the columns needed in each data domain.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` containing `lWorkflow` with `workflow`, `path`, `name`, `lData`, `lChecks`, `bStatus`, `checks`, and `lResults` added based on the results of the execution of `assessment$workflow`.
#'
#' @examples
#' lAssessments <- MakeWorkflowList()
#' lData <- list(
#'   dfAE = clindata::rawplus_ae,
#'   dfCONSENT = clindata::rawplus_consent,
#'   dfDISP = clindata::rawplus_dm,
#'   dfIE = clindata::rawplus_ie,
#'   dfLB = clindata::rawplus_lb,
#'   dfPD = clindata::rawplus_protdev,
#'   dfSUBJ = clindata::rawplus_dm
#' )
#'
#' lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
#'
#' output <- RunWorkflow(
#'   lAssessments$kri0001, # adverse event workflow
#'   lData,
#'   lMapping
#' )
#'
#' @return `list` containing `lAssessment` with `workflow`, `path`, `name`, `lData`, `lChecks`, `bStatus`, `checks`, and `lResults` added based on the results of the execution of `assessment$workflow`.
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h1 cli_h2 cli_text
#' @importFrom stringr str_detect
#' @importFrom yaml read_yaml
#' @importFrom purrr map_df
#'
#' @export

RunWorkflow <- function(lWorkflow, lData, lMapping, bQuiet = TRUE) {

  if (!bQuiet) cli::cli_h1(paste0("Initializing `", lWorkflow$name, "` assessment"))

  lWorkflow$lData <- lData
  lWorkflow$lChecks <- list()
  lWorkflow$bStatus <- TRUE

  if (exists("steps", where = lWorkflow)) {
    # Run through each step in lWorkflow$workflow

    stepCount <- 1
    for (step in lWorkflow$steps) {
      if (!bQuiet) cli::cli_h2(paste0("Workflow Step ", stepCount, " of ", length(lWorkflow$steps), ": `", step$name, "`"))
      if (lWorkflow$bStatus) {


        result <- gsm::RunStep(
          lStep = step,
          lMapping = lMapping,
          lData = lWorkflow$lData,
          bQuiet = bQuiet
        )

        lWorkflow$lChecks[[stepCount]] <- result$lChecks
        names(lWorkflow$lChecks)[[stepCount]] <- step$name
        lWorkflow$bStatus <- result$lChecks$status

        if (result$lChecks$status) {
          if (!bQuiet) cli::cli_alert_success("{.fn {step$name}} Successful")
        } else {
          if (!bQuiet) cli::cli_alert_warning("{.fn {step$name}} Failed - Skipping remaining steps")
        }

        if (stringr::str_detect(step$output, "^df")) {
          if (!bQuiet) cli::cli_text("Saving {step$output} to `lWorkflow$lData`")
          lWorkflow$lData[[step$output]] <- result$df
        } else {
          if (!bQuiet) cli::cli_text("Saving {step$output} to `lWorkflow`")
          lWorkflow[[step$output]] <- result
        }
      } else {
        if (!bQuiet) cli::cli_text("Skipping {.fn {step$name}} ...")
      }
      stepCount <- stepCount + 1
    }
  } else {
    if (!bQuiet) cli::cli_alert_warning("Workflow not found for {lWorkflow$name} assessment - Skipping remaining steps")
    lWorkflow$bStatus <- FALSE
  }

  lWorkflow$lChecks$flowchart <- Visualize_Workflow(list(temp_name = lWorkflow)) %>%
    set_names(nm = lWorkflow$name)
  if (!bQuiet) cli::cli_alert_success("{.fn Visualize_Workflow} created a flowchart.")


  return(lWorkflow)
}
