#' Run a stratified workflow
#'
#' Attempts to run a stratified workflow (`lWorkflow`) using shared data (`lData`) and metadata (`lMapping`).
#' Calls `RunStep` for each item in `lWorkflow$workflow` and saves the results to `lWorkflow`
#'
#' @param lWorkflow `list` A named list of metadata defining how the workflow should be run.
#' Properties should include: `label`, `tags` and `workflow`
#' @param lData `list` A named list of domain-level data frames. Names should match the values
#' specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from
#' `X_Map_Raw`.
#' @param lMapping `list` A named list identifying the columns needed in each data domain.
#' @param lTags `list` A named list of tags describing the assessment. `lTags` is returned as part
#' of the assessment (`lAssess$lTags`) and each tag is added as columns in `lassess$dfSummary`.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` `lWorkflow` along with `tags`, `workflow`, `path`, `name`, `lData`, `lChecks`,
#' `bStatus`, `checks`, and `lResults` added based on the results of the execution of
#' `lWorkflow$workflow`.
#'
#' @examples
#' lWorkflows <- MakeAssessmentList()
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
#' lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
#'
#' aeOutput <- RunStratifiedWorkflow(lWorkflows$aeGrade, lData = lData, lMapping = lMapping, lTags = lTags)
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h1 cli_h2 cli_text
#' @importFrom purrr map
#'
#' @export

RunStratifiedWorkflow <- function(
    lWorkflow,
    lData,
    lMapping,
    lTags = NULL,
    bQuiet = TRUE
) {
    if (!bQuiet) cli::cli_h1(paste0("Initializing `", lWorkflow$name, "` workflow"))

    lOutput <- RunAssessment(
        lWorkflow,
        lData,
        lMapping,
        lTags = list(
            type = 'stratified'
        ),
        bQuiet = bQuiet
    )

    if (
        is.list(lWorkflow$group) &&
        lWorkflow$group$domain %in% names(lData) &&
        lWorkflow$group$domain %in% names(lMapping) &&
        lMapping[[ lWorkflow$group$domain ]][[ lWorkflow$group$columnParam ]] %in% names(lData[[ lWorkflow$group$domain ]])
    ) {
        # Generate a workflow for each unique value of the stratification variable.
        lStratifiedWorkflow <- MakeStratifiedAssessment(
            lWorkflow,
            lData,
            lMapping,
            bQuiet
        )

        # Run a workflow for each unique value of the stratification variable.
        lStratifiedOutput <- lStratifiedWorkflow %>%
            map(~RunAssessment(
                .x,
                lData,
                lMapping,
                list(lTags, .x$tags),
                bQuiet = bQuiet
            ))

        # Consolidate the stratified output from each workflow into a singular output with stacked data
        # frames and a paneled data visualization.
        lConsolidatedOutput <- ConsolidateStrata(
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
