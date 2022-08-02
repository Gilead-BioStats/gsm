ConsolidateStrata <- function(
    lWorkflow,
    lData,
    lMapping,
    lStratifiedOutput,
    bQuiet
) {
    # Run assessment to generate expected output data structure.
    lConsolidatedOutput <- RunAssessment(
        lWorkflow,
        lData,
        lMapping,
        lTags = list(assessment = 'consolidated'),
        bQuiet = bQuiet
    )

    if (lConsolidatedOutput$bStatus == TRUE && all(map_lgl(lStratifiedOutput, ~.x$bStatus))) {
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
        consoliDataPipeline$chart <- Visualize_Scatter(
            consoliDataPipeline$dfFlagged,
            strGroupCol = 'stratum',
            dfBounds = consoliDataPipeline$dfBounds,
            strUnit = "days"
        )

        # Attach results to overall output.
        for (key in c(names(consoliDataPipeline))) {
            lConsolidatedOutput$lResults[[ key ]] <- consoliDataPipeline[[ key ]]
        }
    } else {
        if (!bQuiet)
            cli::cli_alert_warning(
                "Workflow not found for {lConsolidatedOutput$name} assessment; skipping remaining steps."
            )
        lConsolidatedOutput$bStatus <- FALSE
    }

    lConsolidatedOutput
}
