#' Run a single assessment
#'
#' Attempts to run a single assessments (`lAssessment`) using shared data (`lData`) and metadata (`lMapping`).
#' Calls `RunStep` for each item in `lAssessment$Workflow` and saves the results to `lAssessment`
#'
#' @param lData `list` A named list of domain-level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lMapping `list` A named list identifying the columns needed in each data domain.
#' @param lAssessment `list` A named list of metadata defining how each assessment should be run. Properties should include: `label`, `tags` and `workflow`
#' @param lTags `list` A named list of tags describing the assessment. `lTags` is returned as part of the assessment (`lAssess$lTags`) and each tag is added as columns in `lassess$dfSummary`.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` Returns `lAssessment` with `label`, `tags`, `workflow`, `path`, `name`, `lData`, `lChecks`, `bStatus`, `checks`, and `lResults` added based on the results of the execution of `assessment$workflow`.
#'
#' @examples
#' lAssessments <- MakeAssessmentList()
#' lData <- list(
#'   dfSUBJ = clindata::rawplus_subj,
#'   dfAE = clindata::rawplus_ae,
#'   dfPD = clindata::rawplus_pd,
#'   dfCONSENT = clindata::rawplus_consent,
#'   dfIE = clindata::rawplus_ie
#' )
#' lTags <- list(
#'   Study = "myStudy"
#' )
#' lMapping <- clindata::mapping_rawplus
#'
#'
#' ae_assessment <- RunAssessment(lAssessments$ae, lData = lData, lMapping = lMapping, lTags = lTags)
#'
#' @importFrom cli cli_h1 cli_h2 cli_alert_success cli_alert_warning cli_text
#' @importFrom stringr str_detect
#' @importFrom yaml read_yaml
#'
#' @export

RunAssessment <- function(lAssessment, lData, lMapping, lTags = NULL, bQuiet = FALSE) {
  if (!bQuiet) cli::cli_h1(paste0("Initializing `", lAssessment$name, "` assessment"))

  lAssessment$lData <- lData
  lAssessment$lChecks <- list()
  lAssessment$bStatus <- TRUE

  # Run through each step in lAssessment$workflow
  stepCount <- 1
  for (step in lAssessment$workflow) {
    if (!bQuiet) cli::cli_h2(paste0("Workflow Step ", stepCount, " of ", length(lAssessment$workflow), ": `", step$name, "`"))
    if (lAssessment$bStatus) {
      result <- gsm::RunStep(
        lStep = step,
        lMapping = lMapping,
        lData = lAssessment$lData,
        lTags = c(lTags, lAssessment$tags),
        bQuiet = bQuiet
      )

      lAssessment$checks[[stepCount]] <- result$lChecks
      names(lAssessment$checks)[[stepCount]] <- step$name
      lAssessment$bStatus <- result$lChecks$status
      if (result$lChecks$status) {
        cli::cli_alert_success("{.fn {step$name}} Successful")
      } else {
        cli::cli_alert_warning("{.fn {step$name}} Failed - Skipping remaining steps")
      }

      if (stringr::str_detect(step$output, "^df")) {
        cli::cli_text("Saving {step$output} to `lAssessment$lData`")
        lAssessment$lData[[step$output]] <- result$df
      } else {
        cli::cli_text("Saving {step$output} to `lAssessment`")
        lAssessment[[step$output]] <- result
      }
    } else {
      cli::cli_text("Skipping {.fn {step$name}} ...")
    }

    stepCount <- stepCount + 1
  }


  return(lAssessment)
}
