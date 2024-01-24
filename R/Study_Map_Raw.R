function (dfs = list(dfSTUDY = clindata::ctms_study, dfSUBJ = clindata::rawplus_dm), 
    lMapping = gsm::Read_Mapping(c("ctms", "rawplus")), dfConfig = gsm::config_param) {
    status_study <- dfs$dfSTUDY %>% select(studyid = lMapping$dfSTUDY[["strStudyCol"]], 
        title = lMapping$dfSTUDY[["strTitleCol"]], nickname = lMapping$dfSTUDY[["strNicknameCol"]], 
        planned_sites = lMapping$dfSTUDY[["strPlannedSitesCol"]], 
        enrolled_sites_ctms = lMapping$dfSTUDY[["strActualSitesCol"]], 
        planned_participants = lMapping$dfSTUDY[["strPlannedSubjectsCol"]], 
        enrolled_participants_ctms = lMapping$dfSTUDY[["strActualSubjectsCol"]], 
        est_fpfv = lMapping$dfSTUDY[["strEstFirstPatientFirstVisitCol"]], 
        fpfv = lMapping$dfSTUDY[["strActFirstPatientFirstVisitCol"]], 
        est_lpfv = lMapping$dfSTUDY[["strEstLastPatientFirstVisitCol"]], 
        lpfv = lMapping$dfSTUDY[["strActLastPatientFirstVisitCol"]], 
        est_lplv = lMapping$dfSTUDY[["strEstLastPatientLastVisitCol"]], 
        lplv = lMapping$dfSTUDY[["strActLastPatientLastVisitCol"]], 
        ta = lMapping$dfSTUDY[["strTherapeuticAreaCol"]], indication = lMapping$dfSTUDY[["strIndicationCol"]], 
        phase = lMapping$dfSTUDY[["strPhaseCol"]], status = lMapping$dfSTUDY[["strStatusCol"]], 
        rbm_flag = lMapping$dfSTUDY[["strRBMFlagCol"]], product = lMapping$dfSTUDY[["strProductCol"]], 
        protocol_type = lMapping$dfSTUDY[["strTypeCol"]], everything()) %>% 
        rename_with(tolower)
    if (!("enrolled_participants" %in% colnames(status_study))) {
        status_study$enrolled_participants <- gsm::Get_Enrolled(dfSUBJ = dfs$dfSUBJ, 
            dfConfig = dfConfig, lMapping = lMapping, strUnit = "participant", 
            strBy = "study")
    }
    if (!("enrolled_sites" %in% colnames(status_study))) {
        status_study$enrolled_sites <- gsm::Get_Enrolled(dfSUBJ = dfs$dfSUBJ, 
            dfConfig = dfConfig, lMapping = lMapping, strUnit = "site", 
            strBy = "study")
    }
    status_study <- status_study %>% select(all_of(gsm::rbm_data_spec %>% 
        filter(.data$System == "Gismo", .data$Table == "status_study", 
            .data$Column != "gsm_analysis_date") %>% arrange(.data$Order) %>% 
        pull(.data$Column)))
    return(status_study)
}
