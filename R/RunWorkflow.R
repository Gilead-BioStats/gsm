#' Run a workflow via it's YAML specification.
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Attempts to run a single assessment (`lWorkflow`) using shared data (`lData`) and metadata (`lMapping`).
#' Calls `RunStep` for each item in `lWorkflow$workflow` and saves the results to `lWorkflow`.
#'
#' @param lWorkflow `list` A named list of metadata defining how the workflow should be run.
#' @param lData `list` A named list of domain-level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
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
#' lMapped <- RunWorkflow(wf_mapping, LData)$mapping$lResults
#'
#' output <- RunWorkflow(lAssessments, lMapped)
#' }
#' @return `list` containing `lAssessment` with `workflow`, `path`, `name`, `lData`, `lChecks`, `bStatus`, `checks`, and `lResults` added based on the results of the execution of `assessment$workflow`.
#'
#' @export

RunWorkflow <- function(lWorkflow, lData) {
  output <- imap(lWorkflow, function(workflow, name){
    cli::cli_h1(paste0("Initializing `", workflow$meta$file, "` Workflow"))

    workflow$lData <- lData
    workflow$lResults <- lData

    # Run through each step in lWorkflow$workflow

    stepCount <- 1
    for (step in workflow$steps) {
      cli::cli_h2(paste0("Workflow Step ", stepCount, " of ", length(workflow$steps), ": `", step$name, "`"))

      result0 <- purrr::safely(~gsm::RunStep(lStep = step, lData = workflow$lResults, lMeta = workflow$meta))()
      if(names(result0[!map_vec(result0, is.null)]) == "error"){
        cli::cli_alert_danger(paste0('Error:`', result0$error$message, '`: ', "error message stored as result"))
        result1 <- result0$error$message
      } else {
        result1 <- result0$result
      }

      workflow$lResults[[step$output]] <- result1

      if(is.data.frame(result1)){
        cli::cli_h3("{paste(dim(result1),collapse='x')} data.frame saved as `lData${step$output}`.")
      } else {
        cli::cli_h3("{typeof(result1)} of length {length(result1)} saved as `lData${step$output}`.")

      }

      stepCount <- stepCount + 1
    }

    if(name != "mapping"){
      workflow$lResults <- c(workflow$lResults[!names(workflow$lResults) %in% names(workflow$lData)],
                           workflow$lResults[imap_lgl(workflow$lResults[names(workflow$lResults) %in% names(workflow$lData)], function(result, name){
                             !identical(result, workflow$lData[[name]])
                           })]
                          )
    }
    return(workflow)
  })

  return(output)
}
