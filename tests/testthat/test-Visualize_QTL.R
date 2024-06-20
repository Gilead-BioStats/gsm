skip()
test_that("Visualize_QTL returns correct structure", {
  dfSummary <- data.frame(
    workflowid = rep("QTL1", 3),
    studyid = c("AA-AA-000-0000", "BB-BB-111-1111", "CC-CC-222-2222"),
    siteid = c("Site A", "Site B", "Site C"),
    numerator_value = c(10, 20, 30),
    denominator_value = c(100, 200, 300),
    metric_value = c(0.1, 0.2, 0.3),
    score = c(5, 10, 15),
    flag_value = c(0, 1, -1),
    gsm_analysis_date = rep("2023-12-19", 3),
    snapshot_date = rep("2023-12-19", 3)
  )

  lLabels <- list(
    title = "Time Series QTL Widget",
    group = "GroupID"
  )

  dfParams <- data.frame(
    workflowid = rep("QTL1", 3),
    studyid = rep("AA-AA-000-0000", 3),
    param = "strGroup",
    default_s = c("Group A", "Group B", "Group C"),
    index = rep("test", 3),
    gsm_analysis_date = rep("2023-12-19", 3),
    snapshot_date = rep("2023-12-19", 3)
  )

  dfAnalysis <- data.frame(
    workflowid = rep("QTL1", 3),
    studyid = rep("AA-AA-000-0000", 3),
    param = c("LowCI", "HighCI", "MeanCI"),
    value = c(0, 10, 5),
    index = rep("test", 3),
    gsm_analysis_date = rep("2023-12-19", 3),
    snapshot_date = rep("2023-12-19", 3)
  )
  strQtlName <- "QTL1"

  result <- Visualize_QTL(strQtlName, dfSummary, dfParams, dfAnalysis, lLabels)

  expect_type(result, "list")
  expect_named(result, "timeseriesQtl")
  expect_type(result$timeseriesQtl, "list")
})
