dfAE <- tibble::tribble(
  ~SubjectID, ~AE_SERIOUS, ~AE_TE_FLAG, ~AE_GRADE,
  "1234", "No", TRUE, 1,
  "1234", "No", TRUE, 3,
  "5678", "Yes", FALSE, 1,
  "5678", "No", FALSE, 4
)

dfSUBJ <- data.frame(
  stringsAsFactors = FALSE,
  SubjectID = c("1234", "5678", "9876"),
  SiteID = c("X010X", "X102X", "X999X"),
  StudyID = c("AA-AA-000-0000", "BB-BB-111-1111", "CC-CC-333-3333"),
  RegionID = c("United States", "China", "India"),
  TimeOnTreatment = c(3455, 1745, 1233),
  TimeOnStudy = c(1234, 2345, 4567),
  RandDate = as.Date(c("2012-09-02", "2017-05-08", "2018-05-20"))
)


dfPD <- tibble::tribble(
  ~SubjectID, ~PD_CATEGORY, ~PD_IMPORTANT_FLAG,
  "1234", "Study Medication", "N",
  "1234", "Subject Not Managed According to Protocol", "N",
  "5678", "Nonadherence of study drug", "Y",
  "5678", "Subject Not Managed According to Protocol", "Y",
  "5678", "Nonadherence of study drug", "Y",
  "9876", "Study Medication", "N",
  "9876", "Nonadherence of study drug", "N",
  "9876", "Subject Not Managed According to Protocol", "N"
) %>% mutate(DVDECOD = toupper(PD_CATEGORY))

dfCONSENT <- data.frame(
  stringsAsFactors = FALSE,
  SubjectID = c("1234", "5678"),
  CONSENT_DATE = c("2013-11-26", "2017-10-02"),
  CONSENT_TYPE = c("MAINCONSENT", "MAINCONSENT"),
  CONSENT_VALUE = c("Y", "Y")
)


# created from clindata::rawplus_subj
# used code below + manually edited tribble (datapasta::tribble_paste())
# clindata::rawplus_subj %>%
# select(SubjectID, starts_with("Trt"), starts_with("Stud")) %>%
#   slice(1:3)
dfDISP <- tibble::tribble(
  ~SubjectID, ~TrtCompletion, ~TrtDCReason, ~StudCompletion, ~StudDCReason,
  "1234",            "N",           "Adverse Event",             "N",            "Withdrew Consent",
  "5678",            "Y",           NA,                          "Y",            NA,
  "9876",            "O",           NA,                          "O",            NA
)


# dfIE <- clindata::raw_ie_all %>%
#   dplyr::filter(SUBJID != "" ) %>%
#   select(SUBJID, IECAT_STD, IEORRES) %>%
#   head(40) %>%
#   mutate(SUBJID = ifelse(SUBJID == "0496", "1234", "5678"))
dfIE <- tibble::tribble(
  ~SubjectID, ~IE_CATEGORY, ~IE_VALUE,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "EXCL", 0,
  "1234", "INCL", 1,
  "1234", "INCL", 1,
  "1234", "INCL", 1,
  "1234", "INCL", 1,
  "1234", "INCL", 1,
  "1234", "INCL", 1,
  "1234", "INCL", 1,
  "1234", "INCL", 1,
  "1234", "INCL", 1,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "EXCL", 0,
  "5678", "INCL", 1
)


# dfADSL <- safetyData::adam_adsl %>%
#   select(USUBJID, SITEID, TRTSDT, TRTEDT) %>%
#   head(4)

dfADSL <- data.frame(
  stringsAsFactors = FALSE,
  USUBJID = c(
    "01-701-1015", "01-701-1023",
    "01-701-1028", "01-701-1033"
  ),
  SITEID = c("701", "701", "702", "703"),
  TRTSDT = as.Date(c("2014-01-02", "2012-08-05", "2013-07-19", "2014-03-18")),
  TRTEDT = as.Date(c("2014-07-02", "2012-09-01", "2014-01-14", "2014-03-31"))
)

dfADAE <- data.frame(
  USUBJID = c(
    "01-701-1015", "01-701-1015", "01-701-1023", "01-701-1023",
    "01-701-1023", "01-701-1028", "01-701-1033", "01-701-1033",
    "01-701-1033"
  )
)
