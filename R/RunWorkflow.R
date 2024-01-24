function (lWorkflow, lData, lMapping, bQuiet = TRUE) {
    if (!bQuiet) 
        cli::cli_h1(paste0("Initializing `", lWorkflow$name, 
            "` assessment"))
    vDataDomains <- purrr::map(lWorkflow$steps, function(x) {
        data <- c(x$inputs[x$inputs != "dfInput"])
    }) %>% unlist() %>% unique()
    lWorkflow$lData <- lData[vDataDomains]
    lWorkflow$lChecks <- list()
    lWorkflow$bStatus <- TRUE
    lWorkflow$lWorkflowChecks <- is_workflow_valid(lWorkflow)
    if (lWorkflow$lWorkflowChecks$bStatus) {
        stepCount <- 1
        for (step in lWorkflow$steps) {
            if (!bQuiet) 
                cli::cli_h2(paste0("Workflow Step ", stepCount, 
                  " of ", length(lWorkflow$steps), ": `", step$name, 
                  "`"))
            if (lWorkflow$bStatus) {
                result <- gsm::RunStep(lStep = step, lMapping = lMapping, 
                  lData = lWorkflow$lData, bQuiet = bQuiet)
                lWorkflow$lChecks[[stepCount]] <- result$lChecks
                names(lWorkflow$lChecks)[[stepCount]] <- step$name
                lWorkflow$bStatus <- result$lChecks$status
                if (result$lChecks$status) {
                  if (!bQuiet) 
                    cli::cli_alert_success("{.fn {step$name}} Successful")
                }
                else {
                  if (!bQuiet) 
                    cli::cli_alert_warning("{.fn {step$name}} Failed - Skipping remaining steps")
                }
                if (stringr::str_detect(step$output, "^df")) {
                  if (!bQuiet) 
                    cli::cli_text("Saving {step$output} to `lWorkflow$lData`")
                  lWorkflow$lData[[step$output]] <- result$df
                }
                else {
                  if (!bQuiet) 
                    cli::cli_text("Saving {step$output} to `lWorkflow`")
                  lWorkflow[[step$output]] <- result
                }
            }
            else {
                if (!bQuiet) 
                  cli::cli_text("Skipping {.fn {step$name}} ...")
            }
            stepCount <- stepCount + 1
        }
    }
    else {
        if (!bQuiet) 
            cli::cli_alert_warning("Workflow not found for {lWorkflow$name} assessment - Skipping remaining steps")
        lWorkflow$bStatus <- FALSE
    }
    return(lWorkflow)
}
