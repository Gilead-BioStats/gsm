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

lAssessments <- MakeWorkflowList(strNames = c("cou0002", "kri0007", "kri0009"))

study <- Study_Assess(lData = lData, bQuiet = TRUE, bFlowchart = TRUE)


test_that("flowchart is created for all assessments", {
  expect_true(all(study %>% map_lgl(function(x) {"flowchart" %in% names(x$lChecks)})))
  expect_true(all(study %>% map_lgl(function(x) class(x$lChecks$flowchart) == "list")))
})




