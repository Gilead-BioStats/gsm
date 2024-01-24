function (lMeta = list(config_param = gsm::config_param, config_workflow = gsm::config_workflow, 
    meta_params = gsm::meta_param, meta_site = clindata::ctms_site, 
    meta_study = clindata::ctms_study, meta_workflow = gsm::meta_workflow), 
    lData = list(dfSUBJ = clindata::rawplus_dm, dfAE = clindata::rawplus_ae, 
        dfPD = clindata::ctms_protdev, dfCONSENT = clindata::rawplus_consent, 
        dfIE = clindata::rawplus_ie, dfLB = clindata::rawplus_lb, 
        dfSTUDCOMP = clindata::rawplus_studcomp, dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% 
            filter(.data$phase == "Blinded Study Drug Completion"), 
        dfDATACHG = clindata::edc_data_points, dfDATAENT = clindata::edc_data_pages, 
        dfQUERY = clindata::edc_queries, dfENROLL = clindata::rawplus_enroll), 
    lMapping = Read_Mapping(), lAssessments = MakeWorkflowList(lMeta = lMeta), 
    strAnalysisDate = NULL, bQuiet = TRUE) {
    lResults <- gsm::Study_Assess(lData = lData, lMapping = lMapping, 
        lAssessments = lAssessments, bQuiet = bQuiet) %>% UpdateLabels(lMeta$meta_workflow)
    if (length(grep("qtl", names(lResults))) > 0) {
        results_analysis <- MakeResultsAnalysis(lResults)
    }
    else {
        results_analysis <- data.frame(studyid = NA, workflowid = NA, 
            param = NA, value = NA, gsm_analysis_date = NA)
    }
    status_study <- Study_Map_Raw(dfs = list(dfSTUDY = lMeta$meta_study, 
        dfSUBJ = lData$dfSUBJ), lMapping = lMapping, dfConfig = lMeta$config_param)
    status_site <- Site_Map_Raw(dfs = list(dfSITE = lMeta$meta_site, 
        dfSUBJ = lData$dfSUBJ), lMapping = lMapping, dfConfig = lMeta$config_param)
    gsm_analysis_date <- MakeAnalysisDate(strAnalysisDate = strAnalysisDate, 
        bQuiet = bQuiet)
    lSnapshot <- list(status_study = status_study, status_site = status_site, 
        status_workflow = MakeStatusWorkflow(lResults = lResults, 
            dfConfigWorkflow = lMeta$config_workflow), status_param = lMeta$config_param, 
        results_summary = MakeResultsSummary(lResults = lResults, 
            dfConfigWorkflow = lMeta$config_workflow), results_analysis = results_analysis, 
        results_bounds = MakeResultsBounds(lResults = lResults, 
            dfConfigWorkflow = lMeta$config_workflow), meta_workflow = lMeta$meta_workflow, 
        meta_param = lMeta$meta_params) %>% purrr::keep(~!is.null(.x)) %>% 
        purrr::map(~.x %>% mutate(gsm_analysis_date = gsm_analysis_date))
    snapshot <- list(lSnapshotDate = gsm_analysis_date, lSnapshot = lSnapshot, 
        lStudyAssessResults = lResults, lInputs = list(lMeta = lMeta, 
            lData = lData, lMapping = lMapping, lAssessments = lAssessments))
    return(snapshot)
}
