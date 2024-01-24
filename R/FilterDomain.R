function (df, strDomain, lMapping, strColParam, strValParam, 
    bReturnChecks = FALSE, bQuiet = TRUE, bRemoveVal = FALSE) {
    if (!bQuiet) 
        cli::cli_h2("Checking Input Data for {.fn FilterDomain}")
    lSpec <- list(vRequired = c(strColParam, strValParam), vNACols = strColParam)
    check <- gsm::is_mapping_valid(df = df, mapping = lMapping[[strDomain]], 
        spec = lSpec, bQuiet = bQuiet)
    checks <- list()
    checks[[strDomain]] <- check
    checks$status <- check$status
    if (check$status) {
        if (!bQuiet) 
            cli::cli_alert_success("No issues found for {strDomain} domain")
    }
    else {
        if (!bQuiet) 
            cli::cli_alert_warning("Issues found for {strDomain} domain")
    }
    if (check$status) {
        col <- lMapping[[strDomain]][[strColParam]]
        vals <- lMapping[[strDomain]][[strValParam]]
        if (!bQuiet) {
            if (bRemoveVal) {
                filterMessage <- paste0("Filtering on `{col} %in% c(\"", 
                  paste(vals, collapse = "\", \""), "\")` to remove rows.")
            }
            else {
                filterMessage <- paste0("Filtering on `{col} %in% c(\"", 
                  paste(vals, collapse = "\", \""), "\")` to retain rows.")
            }
            cli::cli_text(filterMessage)
        }
        oldRows <- nrow(df)
        if (!bRemoveVal) {
            df <- df[df[[col]] %in% vals, ]
        }
        else {
            df <- df[!(df[[col]] %in% vals), ]
        }
        if (!bQuiet) {
            newRows <- nrow(df)
            if (bRemoveVal) {
                message <- paste0("Filtered on `{col} %in% c(\"", 
                  paste(vals, sep = "\", \""), "\")` to drop ", 
                  oldRows - newRows, " rows from ", oldRows, 
                  " to ", newRows, " rows.")
            }
            else {
                message <- paste0("Filtered on `{col} %in% c(\"", 
                  paste(vals, sep = "\", \""), "\")` to retain ", 
                  newRows, " rows from ", oldRows, ".")
            }
            cli::cli_alert_success(message)
            if (newRows == 0) 
                cli::cli_alert_warning("WARNING: Filtered data has 0 rows.")
            if (newRows == oldRows) 
                cli::cli_alert_info("NOTE: No rows dropped.")
        }
    }
    if (bReturnChecks) {
        return(list(df = df, lChecks = checks))
    }
    else {
        return(df)
    }
}
