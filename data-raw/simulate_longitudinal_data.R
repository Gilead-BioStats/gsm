devtools::load_all()

# Simulate several snapshots of AE and participant data

## Function to simulate participant enrollment
AddParticipants <-
  function(df,
           n = 100,
           sites = 1:10,
           countries = c("US", "China", "Japan"),
           invid = c("0X132", "0X107", "0X041", "0X152", "0X113", "0X103", "0X116", "0X139"),
           startDate,
           endDate) {
    newParticipants <- data.frame(
      subjid = paste0("S", 1:n),
      subjectid = paste0("S", 1:n),
      subject_nsv = paste0("S", 1:n, "-XXXX"),
      siteid = sample(sites, n, replace = TRUE),
      country = sample(countries, n, replace = TRUE),
      invid = sample(invid, n, replace = TRUE),
      enrolldt = sample(seq(
        as.Date(startDate), as.Date(endDate), by = "day"
      ), n, replace = TRUE),
      enrollyn = "Y"
    )
    df <- bind_rows(df, newParticipants)
    return(df)
  }

## Function to simulate AEs
AddAEs <- function(df, n = 100, startDate, endDate, dfParticipants) {
  newAEs <- data.frame(
    subjid = sample(dfParticipants$subjid, n, replace = TRUE),
    aeser = sample(c("Y", "N"), n, replace = TRUE),
    aedtc = sample(seq(
      as.Date(startDate), as.Date(endDate), by = "day"
    ), n, replace = TRUE)
  )
  df <- bind_rows(df, newAEs)
  return(df)
}

dfSite <- clindata::ctms_site %>% rename(GroupID = site_num)
dfStudy <-
  clindata::ctms_study %>% rename(StudyID = protocol_number)

wf_mapping <- MakeWorkflowList(strNames = "data_mapping")
#wf_mapping$steps <- wf_mapping$steps[1:2]
wf_metrics_site <-
  MakeWorkflowList(strNames = "kri")
wf_metrics_country <-
  MakeWorkflowList(strNames = "cou")

## Simulate data for 12 months
startDate <- seq(as.Date("2012-01-01"), length = 12, by = "months")
endDate <- seq(as.Date("2012-02-01"), length = 12, by = "months") - 1

dfParticipants <- data.frame()
dfAEs <- data.frame()
dfSummary_site <- data.frame()
dfSummary_country <- data.frame()

set.seed(1)

for (i in 1:12) {
  # Add between 10 and 50 participants per month
  dfParticipants <-
    AddParticipants(
      dfParticipants,
      n = sample(10:50, 1),
      sites = unique(dfSite$GroupID),
      invid = unique(dfSite$pi_number),
      countries = unique(dfSite$country),
      startDate[i],
      endDate[i]
    )
  # Recalculate time on study for all participants each month
  dfParticipants <- dfParticipants %>%
    mutate(today = as.Date(endDate[i])) %>%
    mutate(timeonstudy = as.numeric(today - enrolldt))

  # add 1-2 AEs per enrolled particpants (randomly distributed across participants)
  nparticipants <- nrow(dfParticipants)
  dfAEs <-
    AddAEs(dfAEs, n = sample(seq(from = nparticipants, to = nparticipants *
                                   2), 1), startDate[i], endDate[i], dfParticipants)

  # Calculate AE/SAE metrics using simulated data
  lData <- list(Raw_AE = dfAEs,
                Raw_SUBJ = dfParticipants,
                Raw_PD = clindata::ctms_protdev,
                Raw_LB = clindata::rawplus_lb,
                Raw_STUDCOMP = clindata::rawplus_studcomp,
                Raw_SDRGCOMP = clindata::rawplus_sdrgcomp %>% dplyr::filter(.data$phase == 'Blinded Study Drug Completion'),
                Raw_DATACHG = clindata::edc_data_points,
                Raw_DATAENT = clindata::edc_data_pages,
                Raw_QUERY = clindata::edc_queries,
                Raw_ENROLL = clindata::rawplus_enroll)

  lMapped <-
    RunWorkflow(lWorkflow = wf_mapping[[1]], lData = lData)
  lResults_site <-
    wf_metrics_site %>% map( ~ RunWorkflow(lWorkflow = .x, lData = lMapped))
  lResults_country <-
    wf_metrics_country %>% map( ~ RunWorkflow(lWorkflow = .x, lData = lMapped))


  logger::log_info("workflows complete! moving on to add needed columns")

  dfSummary_site_new <- lResults_site %>%
    imap_dfr( ~ .x$Analysis_Summary %>% mutate(MetricID = .y)) %>%
    mutate(StudyID = "ABC-123") %>%
    mutate(snapshot_date = endDate[i])

  dfSummary_country_new <- lResults_country %>%
    imap_dfr( ~ .x$Analysis_Summary %>% mutate(MetricID = .y)) %>%
    mutate(StudyID = "ABC-123") %>%
    mutate(snapshot_date = endDate[i])

  logger::log_info("binding new data to dfSummary")

  dfSummary_site <- bind_rows(dfSummary_site, dfSummary_site_new)
  dfSummary_country <- bind_rows(dfSummary_country, dfSummary_country_new)
}

# prep needed metadata for charts/report
dfMetrics_site <- wf_metrics_site %>% map_df(function(wf) {
  wf$meta$vThreshold <- paste(wf$meta$vThreshold, collapse = ",")
  return(wf$meta)
})

dfMetrics_country <- wf_metrics_country %>% map_df(function(wf) {
  wf$meta$vThreshold <- paste(wf$meta$vThreshold, collapse = ",")
  return(wf$meta)
})

dfBounds_site <- lResults_site %>%
  imap_dfr( ~ .x$lData$dfBounds %>% mutate(MetricID = .y)) %>%
  mutate(StudyID = "ABC-123") %>%
  mutate(snapshot_date = endDate[i])

dfBounds_country <- lResults_country %>%
  imap_dfr( ~ .x$lData$dfBounds %>% mutate(MetricID = .y)) %>%
  mutate(StudyID = "ABC-123") %>%
  mutate(snapshot_date = endDate[i])


##make dfGroups(?)
