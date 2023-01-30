#' Run Multiple Assessments on a Study
#'
#' @description
#' Attempts to run one or more assessments (`lAssessments`) using shared data (`lData`) and metadata (`lMapping`). By default, the sample `rawplus` data from the {clindata} package is used, and all assessments defined in `inst/workflow` are evaluated. Individual assessments are run using `gsm::RunAssessment()`
#'
#' @param lData `list` a named list of domain level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lMapping `list` a named list identifying the columns needed in each data domain.
#' @param lAssessments `list` a named list of metadata defining how each assessment should be run. By default, `MakeWorkflowList()` imports YAML specifications from `inst/workflow`.
#' @param lSubjFilters `list` a named list of parameters to filter subject-level data on.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#' @param bFlowchart `logical` Create flowchart to show data pipeline? Default: `FALSE`
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
  lSubjFilters = NULL,
  bQuiet = TRUE,
  bFlowchart = FALSE
) {

  #### --- load defaults --- ###
  # lData from clindata
  if (is.null(lData)) {
    lData <- list(
      dfSUBJ = clindata::rawplus_dm,
      dfAE = clindata::rawplus_ae,
      dfPD = clindata::rawplus_protdev,
      dfCONSENT = clindata::rawplus_consent,
      dfIE = clindata::rawplus_ie,
      dfLB = clindata::rawplus_lb,
      dfSTUDCOMP = clindata::rawplus_studcomp,
      dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(.data$datapagename == "Blinded Study Drug Completion"),
      dfDATACHG = clindata::edc_data_change_rate,
      dfDATAENT = clindata::edc_data_entry_lag,
      dfQUERY = clindata::edc_queries,
      dfDATACHG = clindata::edc_data_change_rate,
      dfENROLL = clindata::rawplus_enroll
    )
  }

  # lMapping from clindata
  if (is.null(lMapping)) {
    lMapping <- c(
      yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
      yaml::read_yaml(system.file("mappings", "mapping_adam.yaml", package = "gsm")),
      yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))
    )
  }

  # lAssessments from gsm inst/workflow
  if (is.null(lAssessments)) {
    lAssessments <- gsm::MakeWorkflowList()
  }

  # Filter data$dfSUBJ based on lSubjFilters --------------------------------
  if (!is.null(lSubjFilters)) {
    for (colMapping in names(lSubjFilters)) {
      if (!utils::hasName(lMapping$dfSUBJ, colMapping)) {
        stop(paste0("`", colMapping, "` from lSubjFilters is not specified in lMapping$dfSUBJ"))
      }
      col <- colMapping
      vals <- lSubjFilters[[colMapping]]
      lData$dfSUBJ <- gsm::FilterDomain(
        df = lData$dfSUBJ,
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = col,
        strValParam = vals,
        bQuiet = bQuiet
      )
    }
  }

  if (exists("dfSUBJ", where = lData)) {
    if (nrow(lData$dfSUBJ > 0)) {
      ### --- Attempt to run each assessment --- ###
      lAssessments <- lAssessments %>%
        purrr::map(function(lWorkflow) {

          if (hasName(lWorkflow, "group")) {
            RunStratifiedWorkflow(
              lWorkflow,
              lData = lData,
              lMapping = lMapping,
              bQuiet = bQuiet,
              bFlowchart = bFlowchart
            )
          } else {
            RunWorkflow(
              lWorkflow,
              lData = lData,
              lMapping = lMapping,
              bQuiet = bQuiet,
              bFlowchart = bFlowchart
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
