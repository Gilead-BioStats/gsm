#' Create multiple workflows from a single stratified workflow.
#'
#' `r lifecycle::badge("experimental")`
#'
#' @description
#' `MakeStratifiedAssessment` is a utility function that creates a stratified workflow list using a pre-defined workflow (from `inst/workflows`), or
#' by using a custom named list. For example, a user can run the Adverse Event assessment workflow and stratify by event severity (i.e., `aetoxgr`).
#' This will give a list of compiled workflows, each of which represents the assessment results for each unique value of the stratifying variable.
#' For this example using default data, [gsm::MakeWorkflowList()] will create four lists under the main output object
#' - one with assessment results for mild AEs, one for moderate, one for severe, and one for life-threatening events.
#'
#' @param lData `list` A named list of domain-level data frames.
#' @param lMapping `list` A named list identifying the columns needed in each data domain.
#' @param lWorkflow `list` A named list of metadata defining how the workflow should be run.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @examples
#' \dontrun{
#' lMapping <- yaml::read_yaml(
#'   system.file("mappings", "mapping_rawplus.yaml", package = "gsm")
#' )
#' lWorkflowList <- MakeWorkflowList(strNames = "aeGrade", bRecursive = TRUE)
#'
#' # Adverse events by grade
#' StratifiedAE <- MakeStratifiedAssessment(
#'   lData = list(
#'     dfSUBJ = clindata::rawplus_dm,
#'     dfAE = clindata::rawplus_ae
#'   ),
#'   lMapping = lMapping,
#'   lWorkflow = lWorkflowList$aeGrade
#' )
#'
#' StratifiedAEResult <- StratifiedAE %>%
#'   purrr::map(~ .x %>%
#'     RunWorkflow(
#'       lData = list(
#'         dfSUBJ = clindata::rawplus_dm,
#'         dfAE = clindata::rawplus_ae
#'       ),
#'       lMapping = lMapping
#'     ))
#'
#' # Protocol deviations by PD category
#' StratifiedPD <- MakeStratifiedAssessment(
#'   lData = list(
#'     dfSUBJ = clindata::rawplus_dm,
#'     dfPD = clindata::ctms_protdev
#'   ),
#'   lMapping = lMapping,
#'   lWorkflow = MakeWorkflowList()$pdCategory
#' )
#'
#' StratifiedPDResult <- StratifiedPD %>%
#'   purrr::map(~ .x %>%
#'     RunWorkflow(
#'       lData = list(
#'         dfSUBJ = clindata::rawplus_dm,
#'         dfPD = clindata::ctms_protdev
#'       ),
#'       lMapping = lMapping
#'     ))
#'
#' # Labs by lab category
#' StratifiedLB <- MakeStratifiedAssessment(
#'   lData = list(
#'     dfSUBJ = clindata::rawplus_dm,
#'     dfLB = clindata::rawplus_lb
#'   ),
#'   lMapping = lMapping,
#'   lWorkflow = lAssessmentList$lbCategory
#' )
#'
#' StratifiedLBResult <- StratifiedLB %>%
#'   purrr::map(~ .x %>%
#'     RunWorkflow(
#'       lData = list(
#'         dfSUBJ = clindata::rawplus_dm,
#'         dfLB = clindata::rawplus_lb
#'       ),
#'       lMapping = lMapping
#'     ))
#' }
#'
#' @return `list` A list of workflows for each specified strata.
#'
#' @export
MakeStratifiedAssessment <- function(
  lWorkflow,
  lData,
  lMapping,
  bQuiet = TRUE
) {
  stopifnot(
    "[ lWorkflow ] must be a list." = is.list(lWorkflow),
    "[ lWorkflow ] requires a [ group ] property." = "group" %in% names(lWorkflow),
    "[ lWorkflow$group ] must be a list." = is.list(lWorkflow$group),
    "[ lWorkflow$group ] requires properties of [ domain ] and [ columnParam ]." = all(c("domain", "columnParam") %in% names(lWorkflow$group)),
    "[ lMapping ] must be a list." = is.list(lMapping),
    "[ lMapping ] requires a [ lWorkflow$group$domain ] property." = lWorkflow$group$domain %in% names(lMapping),
    "[ lMapping[[ lWorkflow$group$domain ]] ] requires a [ lWorkflow$group$columnParam ] property." = lWorkflow$group$columnParam %in% names(lMapping[[lWorkflow$group$domain]]),
    "[ lData ] must be a list." = is.list(lData),
    "[ lData ] requires a [ lWorkflow$group$domain ] property." = lWorkflow$group$domain %in% names(lData),
    "[ lData[[ lWorkflow$group$domain ]] ] must be a data frame." = is.data.frame(lData[[lWorkflow$group$domain]]),
    "[ lData[[ lWorkflow$group$domain ]] ] requires a [ lMapping[[ lWorkflow$group$columnParam ]] ] column." = lMapping[[lWorkflow$group$columnParam]] %in% names(lData[[lWorkflow$group$domain]]),
    "[ bQuiet ] must be a logical." = is.logical(bQuiet)
  )

  domainName <- lWorkflow$group$domain
  data <- lData[[domainName]]
  columnName <- lMapping[[domainName]][[lWorkflow$group$columnParam]]
  strata <- data[[columnName]] %>%
    unique() %>%
    sort()

  stratifiedWorkflows <- strata %>%
    purrr::imap(function(stratum, i) {
      workflow <- lWorkflow

      # Tailor workflow to stratum.
      workflow$name <- glue::glue("{workflow$name}_{i}")


      # Add an additional workflow step that subsets on the current stratum.
      lStrata <- list(list(
        name = "FilterData",
        inputs = domainName,
        output = domainName,
        params = list(
          strCol = columnName,
          anyVal = stratum
        )
      ))

      workflow$steps <- c(lStrata, lWorkflow$steps)

      workflow
    })

  names(stratifiedWorkflows) <- purrr::map_chr(stratifiedWorkflows, ~ .x$name)

  if (!bQuiet) {
    cli::cli_alert_info(
      "Stratified workflow created for each level of {domainName}${columnName} (n={length(strata)})."
    )
  }

  stratifiedWorkflows
}
