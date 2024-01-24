function (dfs = list(dfSUBJ = clindata::rawplus_dm, dfDATACHG = clindata::edc_data_points), 
    lMapping = gsm::Read_Mapping(c("rawplus", "edc")), bReturnChecks = FALSE, 
    bQuiet = TRUE) {
    stopifnot(`bReturnChecks must be logical` = is.logical(bReturnChecks), 
        `bQuiet must be logical` = is.logical(bQuiet))
    checks <- CheckInputs(context = "DataChg_Map_Raw", dfs = dfs, 
        bQuiet = bQuiet, mapping = lMapping)
    if (checks$status) {
        if (!bQuiet) 
            cli::cli_h2("Initializing {.fn DataChg_Map_Raw}")
        dfDATACHG_mapped <- dfs$dfDATACHG %>% select(SubjectID = lMapping[["dfDATACHG"]][["strIDCol"]], 
            DataChg = lMapping[["dfDATACHG"]][["strNChangesCol"]]) %>% 
            mutate(DataChg = as.numeric(.data$DataChg))
        dfSUBJ_mapped <- dfs$dfSUBJ %>% select(SubjectID = lMapping[["dfSUBJ"]][["strEDCIDCol"]], 
            any_of(c(SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]], 
                StudyID = lMapping[["dfSUBJ"]][["strStudyCol"]], 
                CountryID = lMapping[["dfSUBJ"]][["strCountryCol"]], 
                CustomGroupID = lMapping[["dfSUBJ"]][["strCustomGroupCol"]])))
        dfInput <- dfDATACHG_mapped %>% group_by(.data$SubjectID) %>% 
            summarize(Count = sum(.data$DataChg, na.rm = TRUE), 
                Total = n()) %>% ungroup() %>% gsm::MergeSubjects(dfSUBJ_mapped, 
            vFillZero = "Count", vRemoval = "Total", bQuiet = bQuiet) %>% 
            select(any_of(c(names(dfSUBJ_mapped))), "Count", 
                "Total") %>% arrange(.data$SubjectID)
        if (!bQuiet) 
            cli::cli_alert_success("{.fn DataChg_Map_Raw} returned output with {nrow(dfInput)} rows.")
    }
    else {
        if (!bQuiet) 
            cli::cli_alert_warning("{.fn DataChg_Map_Raw} did not run because of failed check.")
        dfInput <- NULL
    }
    if (bReturnChecks) {
        return(list(df = dfInput, lChecks = checks))
    }
    else {
        return(dfInput)
    }
}
