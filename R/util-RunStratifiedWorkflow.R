RunStratifiedWorkflow <- function(
    lWorkflow,
    lData,
    lMapping,
    lTags = NULL,
    bQuiet = TRUE
) {
    lStratifiedWorkflow <- MakeStratifiedAssessment(
        lWorkflow,
        lData,
        lMapping,
        bQuiet
    )

    lStratifiedOutput <- lStratifiedWorkflow %>%
        map(~RunAssessment(
            .x,
            lData,
            lMapping,
            lTags,
            bQuiet = bQuiet
        ))

    lConsolidatedOutput <- ConsolidateStrata(
        lWorkflow,
        lData,
        lMapping,
        lStratifiedOutput,
        bQuiet
    )

    lConsolidatedOutput
}
