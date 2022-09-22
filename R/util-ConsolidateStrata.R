#' Consolidate stratified assessment outputs
#'
#' Consolidates multiple stratified assessment outputs by stacking the data frames returned by an
#' `*_Assess` function and generating a paneled data visualization.
#'
#' @param lOutput `list` The output from [gsm::RunWorkflow()]
#' @param lStratifiedOutput `list` Multiple outputs from  [gsm::RunWorkflow()]
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` containing `lWorkflow` with `tags`, `workflow`, `path`, `name`, `lData`,
#' `lChecks`, `bStatus`, `checks`, and `lResults` added based on the results of the execution of
#' `assessment$workflow`.
#'
#' @examples
#' lData <- list(
#'   dfSUBJ = clindata::rawplus_dm,
#'   dfAE = clindata::rawplus_ae
#' )
#' lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
#'
#' lWorkflow <- MakeWorkflowList(bRecursive = TRUE, strNames = "aeGrade")$aeGrade
#' lOutput <- RunWorkflow(lWorkflow, lData = lData, lMapping = lMapping)
#'
#' lStratifiedWorkflow <- MakeStratifiedAssessment(
#'   lWorkflow,
#'   lData,
#'   lMapping
#' )
#' lStratifiedOutput <- lStratifiedWorkflow %>%
#'   purrr::map(~ RunWorkflow(
#'     .x,
#'     lData,
#'     lMapping
#'   ))
#'
#' lConsolidatedOutput <- ConsolidateStrata(
#'   lOutput,
#'   lStratifiedOutput
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

  if (lOutput$bStatus == TRUE && all(purrr::map_lgl(lStratifiedOutput, ~ .x$bStatus))) {
    # Stack data pipeline from stratified output.
    consoliDataPipeline <- lStratifiedOutput %>%
      purrr::map(function(stratum) {



        lResults <- stratum$lResults
        lResults$lData[grepl("^df", names(lResults$lData))] %>% # get data frames from results
          purrr::imap(~ .x %>% mutate(stratum = stratum$name))
      }) %>%
      purrr::reduce(function(acc, curr) {



        df <- purrr::imap(acc, function(value, key) {



          bind_rows(value, curr[[key]]) # stack data frames
        })
      })

    # Generate paneled data visualization.
    # TODO: retrieve appropriate visualization function from... the workflow?
    # TODO: consider handling faceting here or there?
    consoliDataPipeline$chart <- Visualize_Scatter(
      consoliDataPipeline$dfFlagged,
      strGroupCol = "stratum",
      dfBounds = consoliDataPipeline$dfBounds,
      strUnit = "days"
    )

    # Attach results to overall output.
    for (key in c(names(consoliDataPipeline))) {
      lOutput$lResults[[key]] <- consoliDataPipeline[[key]]
    }

    if (!bQuiet) {
      cli::cli_alert_success(
        "All stratified outputs were successfully consolidated."
      )
    }
  } else {
    if (!bQuiet) {
      cli::cli_alert_warning(
        "One or more stratified workflows did not run successfully."
      )
    }

    lOutput$bStatus <- FALSE
  }

  lOutput
}
