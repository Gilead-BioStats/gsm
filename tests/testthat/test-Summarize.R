test_that("output created as expected and has correct structure", {
  dfFlagged <- tibble::tibble(
    GroupID = c("702", "703", "701"),
    GroupLevel = rep("site", 3),
    Numerator = c(1, 3, 5),
    Denominator = c(180, 14, 210),
    Metric = c(0.0055, 0.2142, 0.0238),
    Score = c(-1.37, 0.0684, 1.01),
    PredictedCount = c(3.05, 2.88, 3.06),
    Flag = c(0, 0, 0)
  )
  ae_default <- Summarize(dfFlagged)
  expect_true(is.data.frame(ae_default))
  expect_equal(
    names(ae_default),
    c("GroupID", "GroupLevel", "Numerator", "Denominator", "Metric", "Score", "Flag")
  )
  expect_equal(sort(unique(dfFlagged$GroupID)), sort(ae_default$GroupID))

  ae_finding <- Summarize(dfFlagged)
  expect_true(is.data.frame(ae_finding))
  expect_equal(
    names(ae_finding),
    c("GroupID", "GroupLevel", "Numerator", "Denominator", "Metric", "Score", "Flag")
  )
  expect_equal(sort(unique(dfFlagged$GroupID)), sort(ae_finding$GroupID))
})

test_that("incorrect inputs throw errors", {
  dfFlagged <- tibble::tibble(
    GroupID = c("702", "703", "701"),
    GroupLevel = rep("site", 3),
    Numerator = c(1, 3, 5),
    Denominator = c(180, 14, 210),
    Metric = c(0.0055, 0.2142, 0.0238),
    Score = c(-1.37, 0.0684, 1.01),
    PredictedCount = c(3.05, 2.88, 3.06),
    Flag = c(0, 0, 0)
  )
  expect_error(Summarize(list()))
  expect_error(Summarize("Hi"))
  expect_error(Summarize(ae_flag, 12312))
  expect_error(Summarize(dfFlagged, strScoreCol = "wombat"))
})

test_that("output is correctly sorted by Flag and Score", {
  sim1 <- data.frame(
    GroupID = seq(1:100),
    GroupLevel = rep("site", 100),
    N = seq(1:100),
    Metric = rep(NA, 100),
    Score = c(rep(0, 20), rep(1, 80)),
    Flag = c(rep(-1, 9), rep(0, 91))
  )

  expect_equal(Summarize(sim1)$Flag, c(rep(-1, 9), rep(0, 91)))

  sim1 <- data.frame(
    GroupID = seq(1, 100),
    GroupLevel = rep("site", 100),
    N = seq(1, 100),
    Metric = c(seq(1, 5), seq(6, 1), rep(11, 89)),
    Score = c(seq(1, 5), seq(6, 1), rep(11, 89)),
    Flag = c(rep(-1, 9), rep(0, 91))
  )

  expect_equal(Summarize(sim1)$Score, c(6, 5, 5, 4, 4, 3, 3, 2, 1, rep(11, 89), 2, 1))
})

test_that("yaml workflow produces same table as R function", {
  # yaml workflow
  test_wf <- MakeWorkflowList(strPath = test_path("testdata"), strNames = "test_workflow")
  test_mapping <- MakeWorkflowList(strPath = test_path("testdata"), strNames = "mapping")
  lRaw <- gsm::UseClindata(
    list(
      "dfSUBJ" = "clindata::rawplus_dm",
      "dfAE" = "clindata::rawplus_ae"
      )
    )
  lMapped <- quiet_RunWorkflow(lWorkflow = test_mapping[[1]], lData = lRaw)
  lResults <- quiet_RunWorkflow(lWorkflow = test_wf[[1]], lData = lMapped)

  # functional workflow
  dfSeriousAE <- clindata::rawplus_ae %>%
    dplyr::filter(aeser == "Y")
  dfInput <- Input_Rate(
    dfSubjects = clindata::rawplus_dm,
    dfNumerator = dfSeriousAE,
    dfDenominator = clindata::rawplus_dm,
    strSubjectCol = "subjid",
    strGroupCol = "siteid",
    strNumeratorMethod = "Count",
    strDenominatorMethod = "Sum",
    strDenominatorCol = "timeonstudy"
  )
  dfTransformed <- Transform_Rate(dfInput)
  dfAnalyzed <- quiet_Analyze_NormalApprox(dfTransformed, strType = "rate")
  dfFlagged <- Flag_NormalApprox(dfAnalyzed, vThreshold = c(-2,-1,2,3))
  dfSummarized <- Summarize(dfFlagged)

  expect_equal(dfSummarized$Flag, lResults$dfSummary$Flag)
  expect_equal(dim(dfSummarized), dim(lResults$dfSummary))
})

