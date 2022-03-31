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
  RandDate = as.Date(c("2012-09-02", "2017-05-08"))
)
