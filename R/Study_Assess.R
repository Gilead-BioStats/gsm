#' Run Multiple Workflows on a Study
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Attempts to run one or more workflows (`lWorkflows`) using shared data (`lData`). By default, the sample `rawplus` data from the {clindata} package is used, and all assessments defined in `inst/workflow` are evaluated. Individual assessments are run using `gsm::RunAssessment()`
#'
#' @param lData `list` A named list of domain level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lWorkflows `list` A named list of metadata defining how each assessment should be run. By default, `MakeWorkflowList()` imports YAML specifications from `inst/workflow`.
#' 
#' @examples
#' \dontrun{
#' results <- Study_Assess() # run using defaults
#' }
#'
#' @return `list` of results for the specified workflows.
#'
#' @export

Study_Assess <- function(
  lData = NULL,
  lWorkflows = NULL
) {

  # lData from clindata
  if (is.null(lData)) {
    lData <- gsm::UseClindata(
      list(
        "dfSUBJ" = "clindata::rawplus_dm",
        "dfAE" = "clindata::rawplus_ae",
        "dfPD" = "clindata::ctms_protdev",
        "dfCONSENT" = "clindata::rawplus_consent",
        "dfIE" = "clindata::rawplus_ie",
        "dfLB" = "clindata::rawplus_lb",
        "dfSTUDCOMP" = "clindata::rawplus_studcomp",
        "dfSDRGCOMP" = "clindata::rawplus_sdrgcomp %>%
          dplyr::filter(.data$phase == 'Blinded Study Drug Completion')",
        "dfDATACHG" = "clindata::edc_data_points",
        "dfDATAENT" = "clindata::edc_data_pages",
        "dfQUERY" = "clindata::edc_queries",
        "dfENROLL" = "clindata::rawplus_enroll"
      )
    )
  }

  # lWorkflows from gsm inst/workflow
  if (is.null(lWorkflows)) {
    lWorkflows <- gsm::MakeWorkflowList()
  }

  if (exists("dfSUBJ", where = lData)) {
    if (nrow(lData$dfSUBJ) > 0) {
      ### --- Attempt to run each assessment --- ###
      lResults <- lWorkflows %>%
        purrr::map(
          function(lWorkflow) {
              RunWorkflow(
                lWorkflow,
                lData = lData
              )
            }
        )
    } else {
      cli::cli_alert_danger("Subject-level data contains 0 rows. Workflow not run.")
      lResults <- NULL
    }
  } else {
    cli::cli_alert_danger("Subject-level data not found. Assessment not run.")
    lResults <- NULL
  }

  return(lResults)
}
