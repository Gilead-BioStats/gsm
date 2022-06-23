source(testthat::test_path("testdata/data.R"))

study <- Study_Assess(bQuiet = TRUE)

test_that("flowchart is created for all assessments", {
  expect_true("flowchart" %in% names(study$ae$lResults))
  expect_true("flowchart" %in% names(study$consent$lResults))
  expect_true("flowchart" %in% names(study$ie$lResults))
  expect_true("flowchart" %in% names(study$importantpd$lResults))
  expect_true("flowchart" %in% names(study$pd$lResults))
  expect_true("flowchart" %in% names(study$sae$lResults))

  expect_true(all(c("grViz", "htmlwidget") %in% class(study$ae$lResults$flowchart)))
  expect_true(all(c("grViz", "htmlwidget") %in% class(study$consent$lResults$flowchart)))
  expect_true(all(c("grViz", "htmlwidget") %in% class(study$ie$lResults$flowchart)))
  expect_true(all(c("grViz", "htmlwidget") %in% class(study$importantpd$lResults$flowchart)))
  expect_true(all(c("grViz", "htmlwidget") %in% class(study$pd$lResults$flowchart)))
  expect_true(all(c("grViz", "htmlwidget") %in% class(study$sae$lResults$flowchart)))
})

test_that("flowchart is only created when valid data is provided", {
  # only ae and sae will run
  lData <- list(
    dfAE = dfAE,
    dfSUBJ = dfSUBJ
  )

  study <- Study_Assess(
    lData = lData,
    bQuiet = TRUE
  )

  expect_true("flowchart" %in% names(study$ae$lResults))
  expect_true("flowchart" %in% names(study$sae$lResults))
  expect_false("flowchart" %in% names(study$consent$lResults))
  expect_false("flowchart" %in% names(study$ie$lResults))
  expect_false("flowchart" %in% names(study$importantpd$lResults))
  expect_false("flowchart" %in% names(study$pd$lResults))
})


