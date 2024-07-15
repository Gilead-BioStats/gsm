devtools::load_all()
lData <- list(
    # Raw Data
    dfSUBJ = clindata::rawplus_dm,
    dfAE = clindata::rawplus_ae,
    dfPD = clindata::ctms_protdev,
    dfLB = clindata::rawplus_lb,
    dfSTUDCOMP = clindata::rawplus_studcomp,
    dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% dplyr::filter(.data$phase == 'Blinded Study Drug Completion'),
    dfDATACHG = clindata::edc_data_points,
    dfDATAENT = clindata::edc_data_pages,
    dfQUERY = clindata::edc_queries,
    dfENROLL = clindata::rawplus_enroll,
    # CTMS data
    ctms_site = clindata::ctms_site, 
    ctms_study = clindata::ctms_study,
    # SnapshotDate and StudyID
    dSnapshotDate = Sys.Date(),
    strStudyID = "ABC-123"
)

devtools::load_all()

ss_wf <- MakeWorkflowList(strNames = "snapshot")
snapshot <- RunWorkflows(ss_wf, lData, bKeepInputData = TRUE)

# TODO: Remove report debug code below
lCharts= snapshot$lReports$lCharts
dfResults= snapshot$lReporting$dfResults
dfGroups= snapshot$lReporting$dfGroups
dfMetrics= snapshot$lReporting$dfMetrics
dfBounds<- snapshot$lReporting$dfBounds

params <- list(
    lCharts = lCharts,
    dfResults = dfResults,
    dfGroups = dfGroups,
    dfMetrics = dfMetrics
)

Report_KRI(lCharts = lCharts, dfResults=dfResults, dfGroups=dfGroups, dfMetrics=dfMetrics, strOutpath="StandardSiteReport.html")
    
