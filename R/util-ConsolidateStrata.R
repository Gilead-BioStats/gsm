#' Consolidate stratified assessment outputs
#'
#' Consolidates multiple stratified assessment outputs by stacking the data frames returned by an
#' `*_Assess` function and generating a paneled data visualization.
#'
#' @param lOutput `list` The output from [gsm::RunAssessment()]
#' @param lStratifiedOutput `list` Multiple outputs from  [gsm::RunAssessment()]
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` containing `lAssessment` with `tags`, `workflow`, `path`, `name`, `lData`,
#' `lChecks`, `bStatus`, `checks`, and `lResults` added based on the results of the execution of
#' `assessment$workflow`.
#'
#' @examples
#' lData <- list(
#'   dfSUBJ = clindata::rawplus_subj,
#'   dfAE = clindata::rawplus_ae
#' )
#' lTags <- list(
#'   Study = "myStudy"
#' )
#' lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
#'
#' lWorkflow <- MakeAssessmentList()$aeGrade
#' lOutput <- RunAssessment(lWorkflow, lData = lData, lMapping = lMapping, lTags = lTags)
#'
#' lStratifiedWorkflow <- MakeStratifiedAssessment(
#'     lWorkflow,
#'     lData,
#'     lMapping
#' )
#' lStratifiedOutput <- lStratifiedWorkflow %>%
#'     map(~RunAssessment(
#'         .x,
#'         lData,
#'         lMapping,
#'         lTags
#'     ))
#'
#' lConsolidatedOutput <- ConsolidateStrata(
#'     lOutput,
#'     lStratifiedOutput
#' )
#'
#' @importFrom cli cli_alert_success cli_alert_warning
#' @importFrom dplyr bind_rows mutate
#' @importFrom purrr imap map map_lgl reduce
#'
#' @export

ConsolidateStrata <- function(
    lOutput,
    lStratifiedOutput,
    bQuiet = TRUE
) {
    if (lOutput$bStatus == TRUE && all(map_lgl(lStratifiedOutput, ~.x$bStatus))) {
        # Stack data pipeline from stratified output.
        consoliDataPipeline <- lStratifiedOutput %>%
            map(function(stratum) {
                lResults <- stratum$lResults
                lResults[ grepl('^df', names(lResults)) ] %>% # get data frames from results
                    map(~.x %>% mutate(stratum = stratum$tags$Label))
            }) %>%
            reduce(function(acc, curr) {
                df <- imap(acc, function(value, key) {
                    bind_rows(value, curr[[ key ]]) # stack data frames
                })
            })

        # Generate paneled data visualization.
        # TODO: retrieve appropriate visualization function from... the workflow?
        # TODO: consider handling faceting here or there?
        consoliDataPipeline$chart <- Visualize_Scatter(
            consoliDataPipeline$dfFlagged,
            strGroupCol = 'stratum',
            dfBounds = consoliDataPipeline$dfBounds,
            strUnit = "days"
        )

        # Attach results to overall output.
        for (key in c(names(consoliDataPipeline))) {
            lOutput$lResults[[ key ]] <- consoliDataPipeline[[ key ]]
        }

        if (!bQuiet)
            cli::cli_alert_success(
                "All stratified outputs were successfully consolidated."
            )
    } else {
        if (!bQuiet)
            cli::cli_alert_warning(
                "One or more stratified workflows did not run successfully."
            )

        lOutput$bStatus <- FALSE
    }

    lOutput
}
