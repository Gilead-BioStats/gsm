# Prepare Workflows
wf_mapping <- MakeWorkflowList(strNames = "mapping")[[1]]
wf_metrics <- MakeWorkflowList(strNames = "kri0001")
dfMetrics <- wf_metrics$kri0001$meta


# Import Site+Study Metadata
dfStudy<-clindata::ctms_study %>% rename(StudyID = protocol_number)
dfSite<- clindata::ctms_site %>% rename(SiteID = site_num)

# Pull Raw Data - this will overwrite the previous data pull
lRaw <- gsm::UseClindata(
  list(
    "dfSUBJ" = "clindata::rawplus_dm",
    "dfAE" = "clindata::rawplus_ae",
    "dfPD" = "clindata::ctms_protdev",
    "dfLB" = "clindata::rawplus_lb",
    "dfSTUDCOMP" = "clindata::rawplus_studcomp",
    "dfSDRGCOMP" = "clindata::rawplus_sdrgcomp %>%
      dplyr::filter(.data$phase == 'Blinded Study Drug Completion')",
    "dfDATACHG" = "clindata::edc_data_points",
    "dfDATAENT" = "clindata::edc_data_pages",
    "dfQUERY" = "clindata::edc_queries",
    "dfENROLL" = "clindata::rawplus_enroll"
  )
)

# Create Mapped Data
lMapped <- RunWorkflow(lWorkflow = wf_mapping, lData = lRaw)$lData
# Run Metrics
lResults <-wf_metrics %>% map(~RunWorkflow(lWorkflow=.x, lData=lMapped))

table(lResults$kri0001$lData$dfSummary$Flag)
