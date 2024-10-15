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

## Function to simulate LBs
AddLBs <- function(df, n = 5000, dfParticipants) {
  newLBs <- data.frame(
    subjid = sample(dfParticipants$subjid, n, replace = TRUE),
    toxgrg_nsv = sample(c("", "0", "1", "2", "3", "4"),
                        n,
                        prob = c(0.49,0.4875,0.01, 0.005, 0.005, 0.0025),
                        replace = TRUE)
  )
  df <- bind_rows(df, newLBs)
  return(df)
}

## Function to simulate PDs
AddPDs <- function(df, n = 500, dfParticipants) {
  newPDs <- data.frame(
    subjectenrollmentnumber = sample(dfParticipants$subjid, n, replace = TRUE),
    deemedimportant = sample(c("Yes", "No"), n, replace = TRUE)
  )
  df <- bind_rows(df, newPDs)
  return(df)
}

AddSTUDCOMP <- function(df, n = 20, dfParticipants) {
  newSTUDCOMP <- data.frame(
    subjid = sample(dfParticipants$subjid, n, replace = TRUE),
    compyn = sample(c("", "N"),
                    prob = c(0.1, 0.9),
                    n,
                    replace = TRUE)
  )
  df <- bind_rows(df, newSTUDCOMP)
  return(df)
}

AddQUERY <- function(df, n = 1000, dfParticipants) {
  newQUERY <- data.frame(
    subjectname = sample(dfParticipants$subject_nsv, n, replace = TRUE),
    querystatus = sample(c("Answered", "Closed", "Open"),
                    prob = c(0.02, 0.96, 0.02),
                    n,
                    replace = TRUE),
    queryage = sample(clindata::edc_queries$queryage,
                      n,
                      replace = T)
  )
  df <- bind_rows(df, newQUERY)
  return(df)
}

AddSDRGCOMP <- function(df, n = 50, dfParticipants) {
  newSDRGCOMP <- data.frame(
    subjid = sample(dfParticipants$subjid, n, replace = TRUE),
    sdrgyn = sample(c("Y", "N"),
                    prob = c(0.75, 0.25),
                    n,
                    replace = TRUE),
    phase = "Blinded Study Drug Completion"
  )
  df <- bind_rows(df, newSDRGCOMP)
  return(df)
}

AddDATACHG <- function(df, n = 10000, dfParticipants) {
  newDATACHG <- data.frame(
    subject_nsv = sample(dfParticipants$subject_nsv, n, replace = TRUE),
    n_changes = sample(0:6,
                    prob = c(0.74, 0.22, 0.03, 0.005, 0.003, 0.0019, 0.0001),
                    n,
                    replace = TRUE)
  )
  df <- bind_rows(df, newDATACHG) %>%
    select(-subjid)
  return(df)
}

AddDATAENT <- function(df, n = 1000000, dfParticipants) {
  newDATAENT <- data.frame(
    subjectname = sample(dfParticipants$subject_nsv, n, replace = TRUE),
    data_entry_lag = sample(0:20,
                       prob = c(0.25, 0.18, 0.14, 0.10, 0.07, 0.05, 0.05, 0.04, 0.03, 0.02, 0.02,
                                rep(0.005, 10)),
                       n,
                       replace = TRUE)
  )
  df <- bind_rows(df, newDATAENT)
  return(df)
}

AddENROLL <- function(df, dfParticipants,  start_date, end_date) {
  screened <- sample(25:75, size = 1)
  newENROLL <- data.frame(
    subjid = paste0(LETTERS[i], 1:screened),
    subjectid = paste0(LETTERS[i], 1:screened),
    subject_nsv = paste0(LETTERS[i], 1:screened, "-XXXX"),
    siteid = sample(dfParticipants$siteid, screened, replace = TRUE),
    country = sample(dfParticipants$country, screened, replace = TRUE),
    invid = sample(dfParticipants$invid, screened, replace = TRUE),
    studyid = dfParticipants$studyid[1],
    enrolldt = sample(seq(
      as.Date(start_date), as.Date(end_date), by = "day"
    ), screened, replace = TRUE),
    enrollyn = "N"
  )
  df <- bind_rows(df, dfParticipants, newENROLL)
  return(df)
}

dfSite <- clindata::ctms_site
dfStudy <- clindata::ctms_study %>% rename(StudyID = protocol_number)

## Simulate data for 12 months
startDate <- seq(as.Date("2012-01-01"), length = 12, by = "months")
endDate <- seq(as.Date("2012-02-01"), length = 12, by = "months") - 1

dfParticipants <- data.frame()
dfAEs <- data.frame()
dfPD <- data.frame()
dfLB <- data.frame()
dfSTUDCOMP <- data.frame()
dfSDRGCOMP <- data.frame()
dfQUERY <- data.frame()
dfDATACHG <- data.frame()
dfDATAENT <- data.frame()
dfENROLL <- data.frame()

set.seed(1)

for (i in 1:12) {
  # Add between 10 and 50 participants per month
  dfParticipants <-
    AddParticipants(
      dfParticipants,
      studyid = "AA-AA-000-0000",
      n = sample(10:50, 1),
      sites = unique(dfSite$site_num),
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
  dfPD <- AddPDs(df = dfPD,
                 dfParticipants = dfParticipants)
  dfLB <- AddLBs(df = dfLB,
                 dfParticipants = dfParticipants)
  dfSTUDCOMP <- AddSTUDCOMP(df = dfSTUDCOMP,
                            dfParticipants = dfParticipants)
  dfSDRGCOMP <- AddSDRGCOMP(df = dfSDRGCOMP,
                            dfParticipants = dfParticipants)
  dfQUERY <- AddQUERY(df = dfQUERY,
                      dfParticipants = dfParticipants)
  dfDATACHG <- AddDATACHG(df = dfSTUDCOMP,
                          dfParticipants = dfParticipants)
  dfDATAENT <- AddDATAENT(df = dfDATAENT,
                          dfParticipants = dfParticipants)
  dfENROLL <- AddENROLL(df = dfENROLL,
                        dfParticipants = dfParticipants,
                        startDate[i],
                        endDate[i])

  # Calculate AE/SAE metrics using simulated data
  lData <- list(
    Raw_SUBJ = dfParticipants,
    Raw_AE = dfAEs,
    Raw_PD = dfPD %>%
      rename(subjid = subjectenrollmentnumber),
    Raw_LB = dfLB,
    Raw_STUDCOMP = dfSTUDCOMP,
    Raw_SDRGCOMP = dfSDRGCOMP,
    Raw_DATACHG = dfDATACHG,
    Raw_DATAENT = dfDATAENT %>%
      rename(subject_nsv = subjectname),
    Raw_QUERY = dfQUERY %>%
      rename(subject_nsv = subjectname),
    Raw_ENROLL = dfENROLL,
    Raw_SITE = dfSite %>%
      rename(studyid = protocol) %>%
      rename(invid = pi_number) %>%
      rename(InvestigatorFirstName = pi_first_name) %>%
      rename(InvestigatorLastName = pi_last_name) %>%
      rename(City = city) %>%
      rename(State = state) %>%
      rename(Country = country),
    Raw_STUDY = dfStudy %>%
      rename(studyid = StudyID) %>%
      rename(Status = status)
  )

  mapping_wf <- MakeWorkflowList(strPath = "workflow/1_mappings")
  mapped <- RunWorkflows(mapping_wf, lData, bKeepInputData=TRUE)

  # Step 2 - Create Analysis Data - Generate 12 KRIs
  kri_wf <- MakeWorkflowList(strPath = "workflow/2_metrics", strNames = "kri")
  kris <- RunWorkflows(kri_wf, mapped)

  cou_wf <- MakeWorkflowList(strPath = "workflow/2_metrics", strNames = "cou")
  cous <- RunWorkflows(cou_wf, mapped)

  # Step 3 - Create Reporting Data - Import Metadata and stack KRI Results
  lReporting_Input_site <- list(
    Raw_ctms_site = clindata::ctms_site,
    Raw_ctms_study = clindata::ctms_study,
    Mapped_ENROLL = mapped$Mapped_ENROLL,
    Mapped_STUDY = mapped$Mapped_STUDY,
    Mapped_SITE = mapped$Mapped_SITE,
    Mapped_COUNTRY = mapped$Mapped_COUNTRY,
    lWorkflows = kri_wf,
    lAnalyzed = kris,
    dSnapshotDate = endDate[i],
    strStudyID = "AA-AA-000-0000"
  )
  reporting_wf_site <- MakeWorkflowList(strPath = "workflow/3_reporting")
  reporting_site <- RunWorkflows(reporting_wf_site, lReporting_Input_site)

  lReporting_Input_country <- list(
    Raw_ctms_site = clindata::ctms_site,
    Raw_ctms_study = clindata::ctms_study,
    Mapped_ENROLL = mapped$Mapped_ENROLL,
    Mapped_STUDY = mapped$Mapped_STUDY,
    Mapped_SITE = mapped$Mapped_SITE,
    Mapped_COUNTRY = mapped$Mapped_COUNTRY,
    lWorkflows = cou_wf,
    lAnalyzed = cous,
    dSnapshotDate = endDate[i],
    strStudyID = "AA-AA-000-0000"
  )
  reporting_wf_country <- MakeWorkflowList(strPath = "workflow/3_reporting")
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

#only save the most recent groups, bounds and metrics entry for use in reporting
lReporting_site$Reporting_Groups <- reporting_site$Reporting_Groups
lReporting_site$Reporting_Bounds <- reporting_site$Reporting_Bounds
lReporting_site$Reporting_Metrics <- reporting_site$Reporting_Metrics %>%
  filter(str_detect(MetricID, "Analysis_kri"))

lReporting_country$Reporting_Groups <- reporting_country$Reporting_Groups
lReporting_country$Reporting_Bounds <- reporting_country$Reporting_Bounds
lReporting_country$Reporting_Metrics <- reporting_country$Reporting_Metrics %>%
  filter(str_detect(MetricID, "Analysis_cou"))

## test out the data on a report
wf_report_site <- MakeWorkflowList(strNames = "report_kri_site")
lReports_site <- RunWorkflows(wf_report_site, lReporting_site)
# wf_report_country <- MakeWorkflowList(strNames = "report_kri_country")
# lReports_country <- RunWorkflows(wf_report_country, lReporting_country)

# write CSVs

# analysis data
## site
write.csv(file = "data-raw/analyticsSummary.csv",
          x = kris$Analysis_kri0001$Analysis_Summary,
          row.names = F)
write.csv(file = "data-raw/analyticsInput.csv",
          x = kris$Analysis_kri0001$Analysis_Input,
          row.names = F)

## country
write.csv(file = "data-raw/analyticsSummary_country.csv",
          x = cous$Analysis_cou0001$Analysis_Summary,
          row.names = F)
write.csv(file = "data-raw/analyticsInput_country.csv",
          x = cous$Analysis_cou0001$Analysis_Input,
          row.names = F)


# reporting data
## site
write.csv(file = "data-raw/reportingGroups.csv",
          x = lReporting_site$Reporting_Groups,
          row.names = F)
write.csv(file = "data-raw/reportingBounds.csv",
          x = lReporting_site$Reporting_Bounds,
          row.names = F)
write.csv(file = "data-raw/reportingMetrics.csv",
          x = lReporting_site$Reporting_Metrics,
          row.names = F)
write.csv(file = "data-raw/reportingResults.csv",
          x = lReporting_site$Reporting_Results,
          row.names = F)

##country
write.csv(file = "data-raw/reportingGroups_country.csv",
          x = lReporting_country$Reporting_Groups,
          row.names = F)
write.csv(file = "data-raw/reportingBounds_country.csv",
          x = lReporting_country$Reporting_Bounds,
          row.names = F)
write.csv(file = "data-raw/reportingMetrics_country.csv",
          x = lReporting_country$Reporting_Metrics,
          row.names = F)
write.csv(file = "data-raw/reportingResults_country.csv",
          x = lReporting_country$Reporting_Results,
          row.names = F)
