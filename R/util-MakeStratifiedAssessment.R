#' Create multiple workflows from a single stratified workflow
#'
#' @param lData `list` A named list of domain-level data frames.
#' @param lMapping `list` A named list identifying the columns needed in each data domain.
#' @param lWorkflow `list` A named list of metadata defining how an workflow should be run.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @examples
#' \dontrun{
#' lMapping <- yaml::read_yaml(
#'   system.file("mappings", "mapping_rawplus.yaml", package = "gsm")
#' )
#' lAssessmentList <- MakeAssessmentList()
#'
#' # Adverse events by grade
#' StratifiedAE <- MakeStratifiedAssessment(
#'   lData = list(
#'     dfSUBJ = clindata::rawplus_subj,
#'     dfAE = clindata::rawplus_ae
#'   ),
#'   lMapping = lMapping,
#'   lWorkflow = lAssessmentList$aeGrade
#' )
#'
#' StratifiedAEResult <- StratifiedAE %>%
#'   purrr::map(~ .x %>%
#'     RunAssessment(
#'       lData = list(
#'         dfSUBJ = clindata::rawplus_subj,
#'         dfAE = clindata::rawplus_ae
#'       ),
#'       lMapping = lMapping
#'     ))
#'
#' # Protocol deviations by PD category
#' StratifiedPD <- MakeStratifiedAssessment(
#'   lData = list(
#'     dfSUBJ = clindata::rawplus_subj,
#'     dfPD = clindata::rawplus_pd
#'   ),
#'   lMapping = lMapping,
#'   lWorkflow = MakeAssessmentList()$pdCategory
#' )
#'
#' StratifiedPDResult <- StratifiedPD %>%
#'   purrr::map(~ .x %>%
#'     RunAssessment(
#'       lData = list(
#'         dfSUBJ = clindata::rawplus_subj,
#'         dfPD = clindata::rawplus_pd
#'       ),
#'       lMapping = lMapping
#'     ))
#'
#' # Labs by lab category
#' StratifiedLB <- MakeStratifiedAssessment(
#'   lData = list(
#'     dfSUBJ = clindata::rawplus_subj,
#'     dfLB = clindata::rawplus_lb
#'   ),
#'   lMapping = lMapping,
#'   lWorkflow = lAssessmentList$lbCategory
#' )
#'
#' StratifiedLBResult <- StratifiedLB %>%
#'   purrr::map(~ .x %>%
#'     RunAssessment(
#'       lData = list(
#'         dfSUBJ = clindata::rawplus_subj,
#'         dfLB = clindata::rawplus_lb
#'       ),
#'       lMapping = lMapping
#'     ))
#' }
#'
#' @return `list` A list of workflows for each specified strata
#'
#' @importFrom cli cli_alert_info cli_alert_success cli_alert_warning cli_text
#' @importFrom purrr imap map_chr
#' @importFrom glue glue
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
      workflow$tags$Group <- glue::glue('{domainName}[["{columnName}"]]=={stratum}')
      workflow$tags$Label <- glue::glue("{workflow$tags$Label}: {stratum}")
      workflow$label <- glue::glue("{workflow$tags$Label} ({workflow$tags$Group})")


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

      workflow$workflow <- c(lStrata, lWorkflow$workflow)

      workflow
    })

  names(stratifiedWorkflows) <- map_chr(stratifiedWorkflows, ~ .x$name)

  if (!bQuiet) {
    cli::cli_alert_info(
      "Stratified workflow created for each level of {domainName}${columnName} (n={length(strata)})."
    )
  }

  stratifiedWorkflows
}
