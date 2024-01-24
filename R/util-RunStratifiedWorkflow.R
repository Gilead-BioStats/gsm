#' `r lifecycle::badge("experimental")`
#'
#' Run a stratified workflow via workflow YAML specification.
#'
#' @description
#' Attempts to run a stratified workflow (`lWorkflow`) using shared data (`lData`) and metadata (`lMapping`).
#' Calls `RunStep` for each item in `lWorkflow$workflow` and saves the results to `lWorkflow`
#'
#' @param lWorkflow `list` A named list of metadata defining how the workflow should be run.
#' Properties should include: `label`, `tags` and `workflow`
#' @param lData `list` A named list of domain-level data frames. Names should match the values
#' specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from
#' `X_Map_Raw`.
#' @param lMapping `list` A named list identifying the columns needed in each data domain.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` with `group`, `steps`, `path`, `name`, `lData`, `lChecks`, `bStatus`, `lWorkflowChecks` and `lResults` added based on the results of the execution of
#' `lWorkflow$workflow`.
#'
#' @examples
#' lWorkflows <- MakeWorkflowList(bRecursive = TRUE)
#' lData <- list(
#'   dfAE = clindata::rawplus_ae,
#'   dfCONSENT = clindata::rawplus_consent,
#'   dfDISP_Study = clindata::rawplus_studcomp,
#'   dfDISP_Treatment = clindata::rawplus_sdrgcomp,
#'   dfIE = clindata::rawplus_ie,
#'   dfLB = clindata::rawplus_lb,
#'   dfPD = clindata::ctms_protdev,
#'   dfSUBJ = clindata::rawplus_dm
#' )
#' lMapping <- yaml::read_yaml(
#'   system.file("mappings", "mapping_rawplus.yaml", package = "gsm")
#' )
#'
#' output <- RunStratifiedWorkflow(
#'   lWorkflows$aeGrade, # adverse event workflow, stratified by AE grade
#'   lData = lData,
#'   lMapping = lMapping
#' )
#'
#' @return `list` `lWorkflow` along with `tags`, `workflow`, `path`, `name`, `lData`, `lChecks`,
#' `bStatus`, `checks`, and `lResults` added based on the results of the execution of
#' `lWorkflow$workflow`.
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h1 cli_h2 cli_text
#' @importFrom purrr map
#'
#' @export

RunStratifiedWorkflow <- function(
    lWorkflow,
    lData,
    lMapping,
    bQuiet = TRUE) {
  if (!bQuiet) cli::cli_h1(paste0("Initializing `", lWorkflow$name, "` workflow"))

  lOutput <- RunWorkflow(
    lWorkflow,
    lData,
    lMapping,
    bQuiet = bQuiet
  )

  if (
    is.list(lWorkflow$group) &&
      lWorkflow$group$domain %in% names(lData) &&
      lWorkflow$group$domain %in% names(lMapping) &&
      lMapping[[lWorkflow$group$domain]][[lWorkflow$group$columnParam]] %in% names(lData[[lWorkflow$group$domain]])
  ) {
    # Generate a workflow for each unique value of the stratification variable.
    lStratifiedWorkflow <- gsm::MakeStratifiedAssessment(
      lWorkflow,
      lData,
      lMapping,
      bQuiet
    )

    # Run a workflow for each unique value of the stratification variable.
    lStratifiedOutput <- lStratifiedWorkflow %>%
      purrr::map(~ gsm::RunWorkflow(
        .x,
        lData,
        lMapping,
        bQuiet = bQuiet
      ))

    # Consolidate the stratified output from each workflow into a singular output with stacked data
    # frames and a paneled data visualization.
    lConsolidatedOutput <- gsm::ConsolidateStrata(
      lOutput,
      lStratifiedOutput,
      bQuiet = bQuiet
    )

    return(lConsolidatedOutput)
  } else {
    lOutput$bStatus <- FALSE

    return(lOutput)
  }
}
