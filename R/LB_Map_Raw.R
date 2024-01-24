function (dfs = list(dfSUBJ = clindata::rawplus_dm, dfLB = clindata::rawplus_lb), 
    lMapping = gsm::Read_Mapping("rawplus"), bReturnChecks = FALSE, 
    bQuiet = TRUE) {
    stopifnot(`bReturnChecks must be logical` = is.logical(bReturnChecks), 
        `bQuiet must be logical` = is.logical(bQuiet))
    checks <- gsm::CheckInputs(context = "LB_Map_Raw", dfs = dfs, 
        bQuiet = bQuiet, mapping = lMapping)
    if (checks$status) {
        if (!bQuiet) 
            cli::cli_h2("Initializing {.fn LB_Map_Raw}")
        dfSUBJ_mapped <- dfs$dfSUBJ %>% select(SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]], 
            any_of(c(SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]], 
                StudyID = lMapping[["dfSUBJ"]][["strStudyCol"]], 
                CountryID = lMapping[["dfSUBJ"]][["strCountryCol"]], 
                CustomGroupID = lMapping[["dfSUBJ"]][["strCustomGroupCol"]])))
        dfLB_mapped <- dfs$dfLB %>% select(SubjectID = lMapping[["dfLB"]][["strIDCol"]], 
            Grade = lMapping[["dfLB"]][["strGradeCol"]])
        dfInput <- dfLB_mapped %>% mutate(Count = if_else(.data$Grade %in% 
            lMapping[["dfLB"]][["strGradeHighVal"]], 1, 0), Total = 1) %>% 
            group_by(.data$SubjectID) %>% summarize(Count = sum(.data$Count, 
            na.rm = TRUE), Total = sum(.data$Total, na.rm = TRUE)) %>% 
            ungroup() %>% gsm::MergeSubjects(dfSUBJ_mapped, vFillZero = "Count", 
            vRemoval = "Total", bQuiet = bQuiet) %>% select(any_of(c(names(dfSUBJ_mapped))), 
            "Count", "Total") %>% arrange(.data$SubjectID)
        if (!bQuiet) 
            cli::cli_alert_success("{.fn LB_Map_Raw} returned output with {nrow(dfInput)} rows.")
    }
    else {
        if (!bQuiet) 
            cli::cli_alert_warning("{.fn LB_Map_Raw} did not run because of failed check.")
        dfInput <- NULL
    }
    if (bReturnChecks) {
        return(list(df = dfInput, lChecks = checks))
    }
    else {
        return(dfInput)
    }
}
