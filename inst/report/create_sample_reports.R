snapshot <- gsm::Make_Snapshot()

Study_Report(
  lAssessments = snapshot$lStudyAssessResults,
  dfStudy = snapshot$lSnapshot$status_study,
  dfSite = snapshot$lSnapshot$status_site,
  strReportType = "country",
  strOutpath = "StandardReportCountry.html"
)

fs::file_move("inst/report/StandardReportCountry.html", new_path = here::here())
