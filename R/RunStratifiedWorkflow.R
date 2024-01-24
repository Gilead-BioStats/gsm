function(lWorkflow, lData, lMapping, bQuiet = TRUE) {
  if (!bQuiet) {
    cli::cli_h1(paste0(
      "Initializing `", lWorkflow$name,
      "` workflow"
    ))
  }
  lOutput <- RunWorkflow(lWorkflow, lData, lMapping, bQuiet = bQuiet)
  if (is.list(lWorkflow$group) && lWorkflow$group$domain %in%
    names(lData) && lWorkflow$group$domain %in% names(lMapping) &&
    lMapping[[lWorkflow$group$domain]][[lWorkflow$group$columnParam]] %in%
      names(lData[[lWorkflow$group$domain]])) {
    lStratifiedWorkflow <- gsm::MakeStratifiedAssessment(
      lWorkflow,
      lData, lMapping, bQuiet
    )
    lStratifiedOutput <- lStratifiedWorkflow %>% purrr::map(~ gsm::RunWorkflow(.x,
      lData, lMapping,
      bQuiet = bQuiet
    ))
    lConsolidatedOutput <- gsm::ConsolidateStrata(lOutput,
      lStratifiedOutput,
      bQuiet = bQuiet
    )
    return(lConsolidatedOutput)
  } else {
    lOutput$bStatus <- FALSE
    return(lOutput)
  }
}
