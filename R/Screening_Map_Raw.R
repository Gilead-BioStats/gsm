function (dfs = list(dfENROLL = clindata::rawplus_enroll), lMapping = gsm::Read_Mapping("rawplus"), 
    bReturnChecks = FALSE, bQuiet = TRUE) {
    stopifnot(`bReturnChecks must be logical` = is.logical(bReturnChecks), 
        `bQuiet must be logical` = is.logical(bQuiet))
    checks <- gsm::CheckInputs(context = "Screening_Map_Raw", 
        dfs = dfs, bQuiet = bQuiet, mapping = lMapping)
    if (checks$status) {
        if (!bQuiet) 
            cli::cli_h2("Initializing {.fn Screening_Map_Raw}")
        dfENROLL <- dfs$dfENROLL
        dfInput <- dfENROLL %>% select(any_of(c(StudyID = lMapping[["dfENROLL"]][["strStudyCol"]], 
            SiteID = lMapping[["dfENROLL"]][["strSiteCol"]], 
            CountryID = lMapping[["dfENROLL"]][["strCountryCol"]], 
            CustomGroupID = lMapping[["dfENROLL"]][["strCustomGroupCol"]])), 
            SubjectID = lMapping[["dfENROLL"]][["strIDCol"]], 
            ScreenFail = lMapping[["dfENROLL"]][["strScreenFailCol"]], 
            ScreenFailReason = lMapping[["dfENROLL"]][["strScreenFailReasonCol"]]) %>% 
            mutate(Count = as.numeric(.data$ScreenFail %in% lMapping[["dfENROLL"]][["strScreenFailVal"]]), 
                Total = 1) %>% select(ends_with("ID"), "Count", 
            "Total") %>% arrange(.data$SubjectID)
        if (!bQuiet) 
            cli::cli_alert_success("{.fn Screening_Map_Raw} returned output with {nrow(dfInput)} rows.")
    }
    else {
        if (!bQuiet) 
            cli::cli_alert_warning("{.fn Screening_Map_Raw} did not run because of failed check.")
        dfInput <- NULL
    }
    if (bReturnChecks) {
        return(list(df = dfInput, lChecks = checks))
    }
    else {
        return(dfInput)
    }
}
