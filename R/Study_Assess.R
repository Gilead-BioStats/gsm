#' `r lifecycle::badge("stable")`
#'
#' Run Multiple Assessments on a Study
#'
#' @description
#' Attempts to run one or more assessments (`lAssessments`) using shared data (`lData`) and metadata (`lMapping`). By default, the sample `rawplus` data from the {clindata} package is used, and all assessments defined in `inst/workflow` are evaluated. Individual assessments are run using `gsm::RunAssessment()`
#'
#' @param lData `list` A named list of domain level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lMapping `list` A named list identifying the columns needed in each data domain.
#' @param lAssessments `list` A named list of metadata defining how each assessment should be run. By default, `MakeWorkflowList()` imports YAML specifications from `inst/workflow`.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#' @param bLogOutput `logical` Send console output to log file? Default: `FALSE`. Note: Setting `bQuiet = FALSE` is recommended if logging your output.
#' @param strLogFileName `character` File name for log file.
#'
#' @examples
#' \dontrun{
#' results <- Study_Assess() # run using defaults
#' }
#'
#' @return `list` of assessments containing status information and results.
#'
#' @import dplyr
#' @importFrom cli cli_alert_danger
#' @importFrom purrr map
#' @importFrom yaml read_yaml
#' @importFrom utils hasName
#'
#' @export

Study_Assess <- function(
  lData = NULL,
  lMapping = NULL,
  lAssessments = NULL,
  bQuiet = TRUE,
  bLogOutput = FALSE,
  strLogFileName = NULL
) {
  if (bLogOutput) {
    # divert output to .log file
    Log(strFileName = strLogFileName)

    on.exit({
      Unlog()
    })
  }

  #### --- load defaults --- ###
  # lData from clindata
  if (is.null(lData)) {
    lData <- list(
      dfSUBJ = clindata::rawplus_dm,
      dfAE = clindata::rawplus_ae,
      dfPD = clindata::ctms_protdev,
      dfCONSENT = clindata::rawplus_consent,
      dfIE = clindata::rawplus_ie,
      dfLB = clindata::rawplus_lb,
      dfSTUDCOMP = clindata::rawplus_studcomp,
      dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(.data$phase == "Blinded Study Drug Completion"),
      dfDATACHG = clindata::edc_data_points,
      dfDATAENT = clindata::edc_data_pages,
      dfQUERY = clindata::edc_queries,
      dfENROLL = clindata::rawplus_enroll
    )
  }

  # lMapping from clindata
  if (is.null(lMapping)) {
    lMapping <- gsm::Read_Mapping()
  }

  # lAssessments from gsm inst/workflow
  if (is.null(lAssessments)) {
    lAssessments <- gsm::MakeWorkflowList()
  }

  if (exists("dfSUBJ", where = lData)) {
    if (nrow(lData$dfSUBJ) > 0) {
      ### --- Attempt to run each assessment --- ###
      lAssessments <- lAssessments %>%
        purrr::map(function(lWorkflow) {
          if (hasName(lWorkflow, "group")) {
            RunStratifiedWorkflow(
              lWorkflow,
              lData = lData,
              lMapping = lMapping,
              bQuiet = bQuiet
            )
          } else {
            RunWorkflow(
              lWorkflow,
              lData = lData,
              lMapping = lMapping,
              bQuiet = bQuiet
            )
          }
        })
    } else {
      if (!bQuiet) cli::cli_alert_danger("Subject-level data contains 0 rows. Assessment not run.")
      lAssessments <- NULL
    }
  } else {
    if (!bQuiet) cli::cli_alert_danger("Subject-level data not found. Assessment not run.")
    lAssessments <- NULL
  }

  return(lAssessments)
}
