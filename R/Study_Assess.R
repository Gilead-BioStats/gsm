function (lData = NULL, lMapping = NULL, lAssessments = NULL, 
    bQuiet = TRUE, bLogOutput = FALSE, strLogFileName = NULL) {
    if (bLogOutput) {
        Log(strFileName = strLogFileName)
        on.exit({
            Unlog()
        })
    }
    if (is.null(lData)) {
        lData <- list(dfSUBJ = clindata::rawplus_dm, dfAE = clindata::rawplus_ae, 
            dfPD = clindata::ctms_protdev, dfCONSENT = clindata::rawplus_consent, 
            dfIE = clindata::rawplus_ie, dfLB = clindata::rawplus_lb, 
            dfSTUDCOMP = clindata::rawplus_studcomp, dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% 
                filter(.data$phase == "Blinded Study Drug Completion"), 
            dfDATACHG = clindata::edc_data_points, dfDATAENT = clindata::edc_data_pages, 
            dfQUERY = clindata::edc_queries, dfENROLL = clindata::rawplus_enroll)
    }
    if (is.null(lMapping)) {
        lMapping <- gsm::Read_Mapping()
    }
    if (is.null(lAssessments)) {
        lAssessments <- gsm::MakeWorkflowList()
    }
    if (exists("dfSUBJ", where = lData)) {
        if (nrow(lData$dfSUBJ > 0)) {
            lAssessments <- lAssessments %>% purrr::map(function(lWorkflow) {
                if (hasName(lWorkflow, "group")) {
                  RunStratifiedWorkflow(lWorkflow, lData = lData, 
                    lMapping = lMapping, bQuiet = bQuiet)
                }
                else {
                  RunWorkflow(lWorkflow, lData = lData, lMapping = lMapping, 
                    bQuiet = bQuiet)
                }
            })
        }
        else {
            if (!bQuiet) 
                cli::cli_alert_danger("Subject-level data contains 0 rows. Assessment not run.")
            lAssessments <- NULL
        }
    }
    else {
        if (!bQuiet) 
            cli::cli_alert_danger("Subject-level data not found. Assessment not run.")
        lAssessments <- NULL
    }
    return(lAssessments)
}
