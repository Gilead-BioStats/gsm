function (dfs = list(dfSITE = clindata::ctms_site, dfSUBJ = clindata::rawplus_dm), 
    lMapping = gsm::Read_Mapping(c("ctms", "rawplus")), dfConfig = gsm::config_param) {
    status_site <- dfs$dfSITE %>% mutate(siteid = as.character(.data[[lMapping$dfSITE[["strSiteCol"]]]]), 
        invname = paste0(.data[[lMapping$dfSITE[["strPILastNameCol"]]]], 
            ", ", .data[[lMapping$dfSITE[["strPIFirstNameCol"]]]])) %>% 
        select(studyid = lMapping$dfSITE[["strStudyCol"]], "siteid", 
            institution = lMapping$dfSITE[["strAccountCol"]], 
            status = lMapping$dfSITE[["strStatusCol"]], start_date = lMapping$dfSITE[["strActivationDateCol"]], 
            city = lMapping$dfSITE[["strCityCol"]], state = lMapping$dfSITE[["strStateCol"]], 
            country = lMapping$dfSITE[["strCountryCol"]], "invname", 
            everything()) %>% rename_with(tolower)
    if (!("enrolled_participants" %in% colnames(status_site))) {
        status_site_count <- gsm::Get_Enrolled(dfSUBJ = dfs$dfSUBJ, 
            dfConfig = dfConfig, lMapping = lMapping, strUnit = "participant", 
            strBy = "site")
        status_site <- left_join(status_site, status_site_count, 
            by = c(siteid = "SiteID"))
    }
    status_site <- status_site %>% select(all_of(gsm::rbm_data_spec %>% 
        filter(.data$System == "Gismo", .data$Table == "status_site", 
            .data$Column != "gsm_analysis_date") %>% arrange(.data$Order) %>% 
        pull(.data$Column)))
    return(status_site)
}
