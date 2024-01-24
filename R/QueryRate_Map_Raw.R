function (dfs = list(dfSUBJ = clindata::rawplus_dm, dfQUERY = clindata::edc_queries, 
    dfDATACHG = clindata::edc_data_points), lMapping = gsm::Read_Mapping(c("edc", 
    "rawplus")), bReturnChecks = FALSE, bQuiet = TRUE) {
    stopifnot(`bReturnChecks must be logical` = is.logical(bReturnChecks), 
        `bQuiet must be logical` = is.logical(bQuiet))
    checks <- CheckInputs(context = "QueryRate_Map_Raw", dfs = dfs, 
        bQuiet = bQuiet, mapping = lMapping)
    if (checks$status) {
        if (!bQuiet) 
            cli::cli_h2("Initializing {.fn QueryRate_Map_Raw}")
        dfQUERY_mapped <- dfs$dfQUERY %>% select(SubjectID = lMapping[["dfQUERY"]][["strIDCol"]], 
            VisitID = lMapping[["dfQUERY"]][["strVisitCol"]], 
            FormID = lMapping[["dfQUERY"]][["strFormCol"]]) %>% 
            group_by(.data$SubjectID, .data$VisitID, .data$FormID) %>% 
            summarize(Count = n()) %>% ungroup()
        dfDATACHG_mapped <- dfs$dfDATACHG %>% select(SubjectID = lMapping[["dfDATACHG"]][["strIDCol"]], 
            VisitID = lMapping[["dfDATACHG"]][["strVisitCol"]], 
            FormID = lMapping[["dfDATACHG"]][["strFormCol"]]) %>% 
            group_by(.data$SubjectID, .data$VisitID, .data$FormID) %>% 
            summarize(DataPoint = n()) %>% ungroup()
        dfSUBJ_mapped <- dfs$dfSUBJ %>% select(SubjectID = lMapping[["dfSUBJ"]][["strEDCIDCol"]], 
            any_of(c(SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]], 
                StudyID = lMapping[["dfSUBJ"]][["strStudyCol"]], 
                CountryID = lMapping[["dfSUBJ"]][["strCountryCol"]], 
                CustomGroupID = lMapping[["dfSUBJ"]][["strCustomGroupCol"]])))
        dfInput <- dfQUERY_mapped %>% full_join(dfDATACHG_mapped, 
            c("SubjectID", "VisitID", "FormID")) %>% group_by(.data$SubjectID) %>% 
            summarize(Count = sum(.data$Count, na.rm = TRUE), 
                DataPoint = sum(.data$DataPoint, na.rm = TRUE)) %>% 
            ungroup() %>% mutate(Count = tidyr::replace_na(.data$Count, 
            0), DataPoint = tidyr::replace_na(.data$DataPoint, 
            0)) %>% gsm::MergeSubjects(dfSUBJ_mapped, vFillZero = "Count", 
            vRemoval = "DataPoint", bQuiet = bQuiet) %>% mutate(Rate = .data$Count/.data$DataPoint) %>% 
            select(any_of(c(names(dfSUBJ_mapped))), "Count", 
                "DataPoint", "Rate") %>% arrange(.data$SubjectID)
        if (!bQuiet) 
            cli::cli_alert_success("{.fn QueryRate_Map_Raw} returned output with {nrow(dfInput)} rows.")
    }
    else {
        if (!bQuiet) 
            cli::cli_alert_warning("{.fn QueryRate_Map_Raw} did not run because of failed check.")
        dfInput <- NULL
    }
    if (bReturnChecks) {
        return(list(df = dfInput, lChecks = checks))
    }
    else {
        return(dfInput)
    }
}
