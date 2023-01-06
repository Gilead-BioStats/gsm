source(testthat::test_path("testdata/data.R"))

lData <- list(
  dfSUBJ = dfSUBJ,
  dfAE = dfAE,
  dfPD = dfPD,
  dfCONSENT = dfCONSENT,
  dfIE = dfIE,
  dfSDRGCOMP = dfSDRGCOMP,
  dfSTUDCOMP = dfSTUDCOMP,
  dfDATACHG = dfDATACHG,
  dfDATAENT = dfDATAENT,
  dfENROLL = dfENROLL,
  dfQUERY = dfQUERY
)

study <- Study_Assess(lData = lData, bQuiet = TRUE)


test_that("flowchart is created for all assessments", {
  expect_true(all(map_lgl(study, \(kri) "flowchart" %in% names(kri$lChecks))))
  expect_true(all(map_lgl(study, \(kri) class(kri$lChecks$flowchart) == "list")))
})
