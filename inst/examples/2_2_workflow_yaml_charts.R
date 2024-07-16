# Generate Charts with yaml workflow for multiple KRIs

## Prepare Workflows
wf_mapping <- MakeWorkflowList(strNames="mapping")[[1]]
wf_metrics <- MakeWorkflowList(strNames=paste0("kri",sprintf("%04d", 1:12)))
dfMetrics <- wf_metrics %>% map_df(function(wf){
  wf$meta$vThreshold <- paste(wf$meta$vThreshold, collapse = ",")
  return(wf$meta)
})

## Import Site+Study Metadata
dfStudy<-clindata::ctms_study %>% rename(StudyID = protocol_number)
dfSite<- clindata::ctms_site %>% rename(SiteID = site_num)

## Pull Raw Data - this will overwrite the previous data pull
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

## Create Mapped Data
lMapped <- RunWorkflow(lWorkflow = wf_mapping, lData = lRaw)$lData
## Run Metrics
lResults <-wf_metrics %>% map(~RunWorkflow(lWorkflow=.x, lData=lMapped))

dfBounds <- lResults %>%
  imap_dfr(~.x$lData$dfBounds %>% mutate(MetricID = .y)) %>%
  mutate(StudyID = "ABC-123") %>%
  mutate(SnapshotDate = Sys.Date())

dfSummary <- lResults %>%
  imap_dfr(~.x$lData$dfSummary %>% mutate(MetricID = .y)) %>%
  mutate(StudyID = "ABC-123") %>%
  mutate(SnapshotDate = Sys.Date())

# create Visualizations
lCharts <- unique(dfSummary$MetricID) %>% map(~Visualize_Metric(
  dfSummary = dfSummary,
  dfBounds = dfBounds,
  dfSite = dfSite,
  dfMetrics = dfMetrics,
  strMetricID = .x
)
) %>% setNames(unique(dfSummary$MetricID))

#view charts
lCharts$kri0001$scatter
lCharts$kri0001$barMetricJS
