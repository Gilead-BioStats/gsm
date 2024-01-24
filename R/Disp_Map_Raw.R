function (dfs = list(dfSUBJ = clindata::rawplus_dm, dfSTUDCOMP = clindata::rawplus_studcomp, 
    dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(.data$phase == 
        "Blinded Study Drug Completion")), lMapping = gsm::Read_Mapping("rawplus"), 
    strContext = "Study", bReturnChecks = FALSE, bQuiet = TRUE) {
    stopifnot(`bReturnChecks must be logical` = is.logical(bReturnChecks), 
        `bQuiet must be logical` = is.logical(bQuiet))
    strDomain <- ifelse(strContext == "Study", "dfSTUDCOMP", 
        "dfSDRGCOMP")
    dfs$dfDISP <- dfs[[strDomain]]
    checks <- gsm::CheckInputs(context = paste0("Disp_Map_Raw", 
        "_", strContext), dfs = dfs, bQuiet = bQuiet, mapping = lMapping)
    if (checks$status) {
        if (!bQuiet) 
            cli::cli_h2("Initializing {.fn Disp_Map_Raw}")
        dfDISP <- dfs$dfDISP
        dfDISP_mapped <- dfDISP %>% select(SubjectID = lMapping[[strDomain]][["strIDCol"]], 
            DCReason = lMapping[[strDomain]][[glue::glue("str{strContext}DiscontinuationReasonCol")]], 
            Discontinuation = lMapping[[strDomain]][[glue::glue("str{strContext}DiscontinuationFlagCol")]]) %>% 
            filter(.data$Discontinuation %in% lMapping[[strDomain]][[glue::glue("str{strContext}DiscontinuationFlagVal")]]) %>% 
            mutate(Count = 1)
        dfSUBJ_mapped <- dfs$dfSUBJ %>% select(SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]], 
            any_of(c(SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]], 
                StudyID = lMapping[["dfSUBJ"]][["strStudyCol"]], 
                CountryID = lMapping[["dfSUBJ"]][["strCountryCol"]], 
                CustomGroupID = lMapping[["dfSUBJ"]][["strCustomGroupCol"]])))
        dfInput <- gsm::MergeSubjects(dfDomain = dfDISP_mapped, 
            dfSUBJ = dfSUBJ_mapped, bQuiet = bQuiet) %>% mutate(Count = ifelse(is.na(.data$Count), 
            0, .data$Count), Total = 1) %>% select(any_of(names(dfSUBJ_mapped)), 
            "Count", "Total") %>% arrange(.data$SubjectID)
        if (!bQuiet) 
            cli::cli_alert_success("{.fn Disp_Map_Raw} returned output with {nrow(dfInput)} rows.")
    }
    else {
        if (!bQuiet) 
            cli::cli_alert_warning("{.fn Disp_Map_Raw} did not run because of failed check.")
        dfInput <- NULL
    }
    if (bReturnChecks) {
        return(list(df = dfInput, lChecks = checks))
    }
    else {
        return(dfInput)
    }
}
