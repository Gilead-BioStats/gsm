dfAE <- tibble::tribble(
  ~SUBJID,
  "1234",
  "1234",
  "5678",
  "5678"
)

dfRDSL <- data.frame(
  stringsAsFactors = FALSE,
  SubjectID = c("1234", "5678"),
  SiteID = c("X010X", "X102X"),
  TimeOnTreatment = c(3455, 1745),
  TimeOnStudy = c(1234, 2345),
  RandDate = as.Date(c("2012-09-02", "2017-05-08"))
)


dfPD <- tibble::tribble(
  ~SUBJID,
  "1234",
  "1234",
  "5678",
  "5678",
  "5678",
  "6789"
)


dfConsent <- data.frame(
  stringsAsFactors = FALSE,
  SUBJID = c("1234", "5678"),
  CONSDAT = c("2013-11-26", "2017-10-02"),
  CONSCAT_STD = c("mainconsent", "mainconsent"),
  CONSYN = c("Y", "Y")
)


# dfDisp = safetyData::adam_adsl %>%
#   select("SUBJID", "SITEID", "DCREASCD") %>%
#   head(2)
dfDisp <- tibble::tribble(
  ~SUBJID, ~SITEID,       ~DCREASCD,
  "1234",   "701",     "Completed",
  "5678",   "701", "Adverse Event"
)


# dfIE <- clindata::raw_ie_all %>%
#   dplyr::filter(SUBJID != "" ) %>%
#   select(SUBJID, IECAT_STD, IEORRES) %>%
#   head(40) %>%
#   mutate(SUBJID = ifelse(SUBJID == "0496", "1234", "5678"))
dfIE <- tibble::tribble(
  ~SUBJID, ~IECAT_STD, ~IEORRES,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "EXCL",        0,
  "1234",     "INCL",        1,
  "1234",     "INCL",        1,
  "1234",     "INCL",        1,
  "1234",     "INCL",        1,
  "1234",     "INCL",        1,
  "1234",     "INCL",        1,
  "1234",     "INCL",        1,
  "1234",     "INCL",        1,
  "1234",     "INCL",        1,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "EXCL",        0,
  "5678",     "INCL",        1
)
