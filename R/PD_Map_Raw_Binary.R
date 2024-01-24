function (dfs = list(dfSUBJ = clindata::rawplus_dm, dfPD = clindata::ctms_protdev), 
    lMapping = gsm::Read_Mapping(c("ctms", "rawplus")), bReturnChecks = FALSE, 
    bQuiet = TRUE) {
    stopifnot(`bReturnChecks must be logical` = is.logical(bReturnChecks), 
        `bQuiet must be logical` = is.logical(bQuiet))
    checks <- gsm::CheckInputs(context = "PD_Map_Raw_Binary", 
        dfs = dfs, bQuiet = bQuiet, mapping = lMapping)
    if (checks$status) {
        if (!bQuiet) 
            cli::cli_h2("Initializing {.fn PD_Map_Raw}")
        dfPD_mapped <- dfs$dfPD %>% select(SubjectID = lMapping[["dfPD"]][["strIDCol"]])
        dfSUBJ_mapped <- dfs$dfSUBJ %>% select(SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]], 
            any_of(c(SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]], 
                StudyID = lMapping[["dfSUBJ"]][["strStudyCol"]], 
                CountryID = lMapping[["dfSUBJ"]][["strCountryCol"]], 
                CustomGroupID = lMapping[["dfSUBJ"]][["strCustomGroupCol"]])))
        dfInput <- dfPD_mapped %>% group_by(.data$SubjectID) %>% 
            summarize(Count = 1) %>% ungroup() %>% gsm::MergeSubjects(dfSUBJ_mapped, 
            vFillZero = "Count", bQuiet = bQuiet) %>% mutate(Total = 1) %>% 
            select(any_of(names(dfSUBJ_mapped)), "Count", "Total") %>% 
            arrange(.data$SubjectID)
        if (!bQuiet) 
            cli::cli_alert_success("{.fn PD_Map_Raw_Binary} returned output with {nrow(dfInput)} rows.")
    }
    else {
        if (!bQuiet) 
            cli::cli_alert_warning("{.fn PD_Map_Raw_Binary} did not run because of failed check.")
        dfInput <- NULL
    }
    if (bReturnChecks) {
        return(list(df = dfInput, lChecks = checks))
    }
    else {
        return(dfInput)
    }
}
