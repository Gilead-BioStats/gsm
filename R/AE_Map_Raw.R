function (dfs = list(dfSUBJ = clindata::rawplus_dm, dfAE = clindata::rawplus_ae), 
    lMapping = gsm::Read_Mapping("rawplus"), bReturnChecks = FALSE, 
    bQuiet = TRUE) {
    stopifnot(`bReturnChecks must be logical` = is.logical(bReturnChecks), 
        `bQuiet must be logical` = is.logical(bQuiet))
    checks <- CheckInputs(context = "AE_Map_Raw", dfs = dfs, 
        bQuiet = bQuiet, mapping = lMapping)
    if (checks$status) {
        if (!bQuiet) 
            cli::cli_h2("Initializing {.fn AE_Map_Raw}")
        dfAE_mapped <- dfs$dfAE %>% select(SubjectID = lMapping[["dfAE"]][["strIDCol"]])
        dfSUBJ_mapped <- dfs$dfSUBJ %>% select(SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]], 
            any_of(c(SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]], 
                StudyID = lMapping[["dfSUBJ"]][["strStudyCol"]], 
                CountryID = lMapping[["dfSUBJ"]][["strCountryCol"]], 
                CustomGroupID = lMapping[["dfSUBJ"]][["strCustomGroupCol"]])), 
            Exposure = lMapping[["dfSUBJ"]][["strTimeOnStudyCol"]])
        dfInput <- dfAE_mapped %>% group_by(.data$SubjectID) %>% 
            summarize(Count = n()) %>% ungroup() %>% gsm::MergeSubjects(dfSUBJ_mapped, 
            vFillZero = "Count", vRemoval = "Exposure", bQuiet = bQuiet) %>% 
            mutate(Rate = .data$Count/.data$Exposure) %>% select(any_of(c(names(dfSUBJ_mapped))), 
            "Count", "Rate") %>% arrange(.data$SubjectID)
        if (!bQuiet) 
            cli::cli_alert_success("{.fn AE_Map_Raw} returned output with {nrow(dfInput)} rows.")
    }
    else {
        if (!bQuiet) 
            cli::cli_alert_warning("{.fn AE_Map_Raw} did not run because of failed check.")
        dfInput <- NULL
    }
    if (bReturnChecks) {
        return(list(df = dfInput, lChecks = checks))
    }
    else {
        return(dfInput)
    }
}
