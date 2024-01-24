function (strAnalysisDate = NULL, bQuiet = FALSE) {
    if (!is.null(strAnalysisDate)) {
        date_is_valid <- try(as.Date(strAnalysisDate), silent = TRUE)
        if (!"try-error" %in% class(date_is_valid) && !is.na(date_is_valid)) {
            gsm_analysis_date <- as.Date(strAnalysisDate)
        }
        else {
            if (!bQuiet) 
                cli::cli_alert_warning("strAnalysisDate does not seem to be in format YYYY-MM-DD. Defaulting to current date of {Sys.Date()}")
            gsm_analysis_date <- Sys.Date()
        }
    }
    else {
        gsm_analysis_date <- Sys.Date()
    }
    return(gsm_analysis_date)
}
