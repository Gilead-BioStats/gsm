#### 3.1 - Map data and run 12 standard metrics using workflows

#### 3.2 - Generate Charts and reports using workflows

#### 3.3 - Run site-level metrics and create report with a single workflow
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

ss_wf <- MakeWorkflowList(strNames = "snapshot")
snapshot <- RunWorkflows(ss_wf, lData, bKeepInputData = TRUE)


#### 3.4 - Run all metrics and create country-level report with a single workflow