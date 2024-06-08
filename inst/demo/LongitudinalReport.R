devtools::load_all()

# Simulate several snapshots of AE and participant data

## Function to simulate participant enrollment
AddParticipants <- function(df, n=100, sites=1:10, startDate, endDate){
  newParticipants <- data.frame(
    subjid = paste0("S", 1:n),
    subjectid = paste0("S", 1:n),
    siteid = sample(sites, n, replace = TRUE),
    enrolldt = sample(seq(as.Date(startDate), as.Date(endDate), by="day"), n, replace = TRUE),
    enrollyn= "Y"
  )
  df <- bind_rows(df, newParticipants)
  return(df)
}

## Function to simulate AEs
AddAEs <- function(df, n=100, startDate, endDate, dfParticipants){
  newAEs <- data.frame(
    subjid = sample(dfParticipants$subjid, n, replace = TRUE),
    aeser = sample(c("Y", "N"), n, replace = TRUE),
    aedtc = sample(seq(as.Date(startDate), as.Date(endDate), by="day"), n, replace = TRUE)
  )
  df <- bind_rows(df, newAEs)
  return(df)
}

dfSite <- clindata::ctms_site %>% rename(SiteID = site_num)
dfStudy <- clindata::ctms_study %>% rename(StudyID = protocol_number)

wf_mapping <- MakeWorkflowList(strNames="mapping")[[1]]
wf_mapping$steps <- wf_mapping$steps[1:2]
wf_metrics <- MakeWorkflowList(strNames=paste0("kri",sprintf("%04d", 1:2)))


## Simulate data for 12 months
startDate <- seq(as.Date("2012-01-01"),length=12, by="months")
endDate <- seq(as.Date("2012-02-01"),length=12, by="months")-1

dfParticipants <- data.frame()
dfAEs <- data.frame()
dfSummary <- data.frame()

set.seed(1)

for(i in 1:12){
  # Add between 10 and 50 participants per month
  dfParticipants <- AddParticipants(dfParticipants, n=sample(10:50, 1), sites=unique(dfSite$SiteID), startDate[i], endDate[i])
  # Recalcuate time on study for all participants each month
  dfParticipants <- dfParticipants %>% 
      mutate(today = as.Date(endDate[i])) %>%
      mutate(timeonstudy = as.numeric(today - enrolldt))

  # add 1-2 AEs per enrolled particpants (randomly distributed across participants)
  nparticipants <- nrow(dfParticipants)   
  dfAEs <- AddAEs(dfAEs, n=sample(seq(from=nparticipants, to=nparticipants*2), 1), startDate[i], endDate[i], dfParticipants)

  # Calculate AE/SAE metrics using simulated data
  lData <- list(
      dfAE = dfAEs,
      dfSUBJ = dfParticipants
  )

  lMapped <- RunWorkflow(lWorkflow = wf_mapping, lData = lData)$lData
  lResults <- wf_metrics %>% map(~RunWorkflow(lWorkflow=.x, lData=lMapped))

  dfSummary_new <- lResults %>%
      imap_dfr(~.x$lData$dfSummary %>% mutate(MetricID = .y)) %>%
      mutate(StudyID = "ABC-123") %>%
      mutate(snapshot_date = endDate[i])

  dfSummary <- bind_rows(dfSummary, dfSummary_new)
}

# prep needed metadata for charts/report
dfMetrics <- wf_metrics %>% map_df(function(wf){
    wf$meta$vThreshold <- paste(wf$meta$vThreshold, collapse = ",")
    return(wf$meta)
})

dfBounds <- lResults %>% 
    imap_dfr(~.x$lData$dfBounds %>% mutate(MetricID = .y)) %>%
    mutate(StudyID = "ABC-123") %>%
    mutate(snapshot_date = endDate[i])

dfParams1 <- structure(
  list(
    metricid = c("kri0001", "kri0001", "kri0001", "kri0001"), 
    param = c("vThreshold", "vThreshold", "vThreshold", "vThreshold"), 
    index = 1:4, 
    snapshot_date = rep(as.Date('2012-12-31'),4), 
    studyid = rep("ABC-123",4), 
    value = c("-2", "-1", "2", "3")
  ), 
  row.names = c(NA, -4L), 
  class = "data.frame"
)

dfParams2 <- structure(
  list(
    metricid = c("kri0001", "kri0001", "kri0001", "kri0001"), 
    param = c("vThreshold", "vThreshold", "vThreshold", "vThreshold"), 
    index = 1:4, 
    snapshot_date = rep(as.Date('2012-05-31'),4), 
    studyid = rep("ABC-123",4), 
    value = c("-3", "-2", "2", "3")
  ), 
  row.names = c(NA, -4L), 
  class = "data.frame"
)
dfParams <- bind_rows(dfParams1, dfParams2)

lCharts <- unique(dfSummary$MetricID) %>% map(
  ~Visualize_Metric(
    dfSummary = dfSummary, 
    dfBounds = dfBounds, 
    dfSite = dfSite,
    dfParams = dfParams,
    dfMetrics = dfMetrics, 
    strMetricID = .x, 
    strSnapshotDate = as.Date('2012-12-31')
)
) %>% setNames(unique(dfSummary$MetricID))


strOutpath <- "gsm_site_report_overTime.html"
Report_KRI( lCharts = lCharts, dfSummary = dfSummary,  dfSite = dfSite, dfStudy = dfStudy, dfMetrics = dfMetrics, strOutpath = strOutpath )


