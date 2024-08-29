devtools::load_all()

# Simulate several snapshots of AE and participant data

## Function to simulate participant enrollment
AddParticipants <-
  function(df,
           studyid,
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
      studyid = studyid,
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

set.seed(1)

for (i in 1:12) {
  # Add between 10 and 50 participants per month
  dfParticipants <-
    AddParticipants(
      dfParticipants,
      studyid = "ABC-123",
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

  mapping_wf <- MakeWorkflowList(strNames = "data_mapping")
  mapped <- RunWorkflows(mapping_wf, lData, bKeepInputData=TRUE)

  # Step 2 - Create Analysis Data - Generate 12 KRIs
  kri_wf <- MakeWorkflowList(strPath = "workflow/metrics", strNames = "kri0005")
  kris <- RunWorkflows(kri_wf, mapped)

  cou_wf <- MakeWorkflowList(strPath = "workflow/metrics", strNames = "cou")
  cous <- RunWorkflows(cou_wf, mapped)

  # Step 3 - Create Reporting Data - Import Metadata and stack KRI Results
  lReporting_Input_site <- list(
    Raw_ctms_site = clindata::ctms_site,
    Raw_ctms_study = clindata::ctms_study,
    Mapped_ENROLL = mapped$Mapped_ENROLL,
    lWorkflows = kri_wf,
    lAnalysis = kris,
    dSnapshotDate = endDate[i],
    strStudyID = "ABC-123"
  )
  reporting_wf_site <- MakeWorkflowList(strNames = "reporting")
  reporting_site <- RunWorkflows(reporting_wf_site, lReporting_Input_site)

  lReporting_Input_country <- list(
    Raw_ctms_site = clindata::ctms_site,
    Raw_ctms_study = clindata::ctms_study,
    Mapped_ENROLL = mapped$Mapped_ENROLL,
    lWorkflows = kri_wf,
    lAnalysis = kris,
    dSnapshotDate = endDate[i],
    strStudyID = "ABC-123"
  )
  reporting_wf_country <- MakeWorkflowList(strNames = "reporting")
  reporting_country <- RunWorkflows(reporting_wf_country, lReporting_Input_country)

  if (i == 1) {
    lAnalysis_site <- kris
    lAnalysis_country <- cous
    lReporting_site <- reporting_site
    lReporting_country <- reporting_country
  }
  else {
  lAnalysis_site <- imap(lAnalysis_site, \(this, metric)
                         imap(this[grep("Analysis", names(this))], \(x, idx)
                              bind_rows(x, kris[[metric]][[idx]])))
  lAnalysis_country <-  imap(lAnalysis_site, \(this, metric)
                             imap(this[grep("Analysis", names(this))],\(x, idx)
                                  bind_rows(x, cous[[metric]][[idx]])))

  lReporting_site <- imap(lReporting_site[grep("Reporting", names(lReporting_site))], \(x, idx)
                               bind_rows(x, reporting_site[[idx]]))
  lReporting_country <-  imap(lReporting_country[grep("Reporting", names(lReporting_country))], \(x, idx)
                              bind_rows(x, reporting_country[[idx]]))
  }
}
