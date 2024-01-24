function (lOutput, lStratifiedOutput, bQuiet = TRUE) {
    if (lOutput$bStatus == TRUE && all(purrr::map_lgl(lStratifiedOutput, 
        ~.x$bStatus))) {
        consoliDataPipeline <- lStratifiedOutput %>% purrr::map(function(stratum) {
            stratum$lResults$lData[grepl("^df", names(stratum$lResults$lData))] %>% 
                purrr::imap(~.x %>% mutate(stratum = stratum$name))
        }) %>% purrr::reduce(function(acc, curr) {
            df <- purrr::imap(acc, function(value, key) {
                bind_rows(value, curr[[key]])
            })
        })
        consoliDataPipeline$chart <- Visualize_Scatter(consoliDataPipeline$dfFlagged, 
            strGroupCol = "stratum", dfBounds = consoliDataPipeline$dfBounds, 
            strUnit = "days")
        for (key in c(names(consoliDataPipeline))) {
            lOutput$lResults[[key]] <- consoliDataPipeline[[key]]
        }
        if (!bQuiet) {
            cli::cli_alert_success("All stratified outputs were successfully consolidated.")
        }
    }
    else {
        if (!bQuiet) {
            cli::cli_alert_warning("One or more stratified workflows did not run successfully.")
        }
        lOutput$bStatus <- FALSE
    }
    lOutput
}
