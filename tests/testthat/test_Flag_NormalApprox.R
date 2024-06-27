dfAnalyzed <- Transform_Rate(sampleInput) %>% Analyze_NormalApprox()

################################################################################

test_that("output is created as expected", {
  dfFlagged <- Flag_NormalApprox(dfAnalyzed, vThreshold = c(-3, -2, 2, 3))
  expect_true(is.data.frame(dfFlagged))
  expect_equal(sort(unique(dfAnalyzed$GroupID)), sort(dfFlagged$GroupID))
  expect_true(all(names(dfAnalyzed) %in% names(dfFlagged)))
  expect_equal(names(dfFlagged), c("GroupID", "GroupLevel", "Numerator", "Denominator", "Metric", "OverallMetric", "Factor", "Score", "Flag"))
  expect_equal(length(unique(dfAnalyzed$GroupID)), length(unique(dfFlagged$GroupID)))
  expect_equal(length(unique(dfAnalyzed$GroupID)), nrow(dfFlagged))
})

################################################################################

test_that("incorrect inputs throw errors", {
  expect_error(Flag_NormalApprox(list(), vThreshold = c(-3, -2, 2, 3)), "dfAnalyzed is not a data frame")
  expect_error(Flag_NormalApprox(dfAnalyzed, "1", "2"))
  expect_error(Flag_NormalApprox(dfAnalyzed, vThreshold = c("-3", "-2", "2", "3")), "vThreshold is not numeric")
  expect_error(Flag_NormalApprox(dfAnalyzed, vThreshold = c(-1, 0, 1)), "vThreshold must be length of 4")
  expect_error(Flag_NormalApprox(dfAnalyzed, vThreshold = NULL))
  expect_error(Flag_NormalApprox(dfAnalyzed %>% select(-c(GroupID))))
  expect_error(Flag_NormalApprox(dfAnalyzed, vThreshold = c(4, 3, 2, 1)))
})

################################################################################

test_that("flagging works correctly", {
  dfAnalyzedCustom <- tibble::tribble(
    ~GroupID, ~Numerator, ~Denominator, ~Metric, ~OverallMetric, ~Factor, ~Score,
    "139", 0, 2, 0, 0.08, 0.910, -0.437,
    "109", 0, 1, 0, 0.08, 0.910, -0.309,
    "43", 1, 2, 0.5, 0.08, 0.910, 2.295,
    "127", 1, 1, 1, 0.08, 0.910, 3.554
  )

  expect_silent(dfFlagged <- Flag_NormalApprox(dfAnalyzedCustom, vThreshold = c(-3, -2, 2, 3)))
  expect_equal(dfFlagged$Flag, c(2, 1, 0, 0))
})

################################################################################

test_that("yaml workflow produces same table as R function", {
  #yaml workflow
  test_wf <- MakeWorkflowList(strPath = test_path("testdata"), strNames = "test_workflow")
  test_mapping <- MakeWorkflowList(strPath = test_path("testdata"), strNames = "mapping")
  lRaw <- gsm::UseClindata(
    list(
      "dfSUBJ" = "clindata::rawplus_dm",
      "dfAE" = "clindata::rawplus_ae"
    )
  )
  lMapped <- RunWorkflow(lWorkflow = test_mapping[[1]], lData = lRaw)$lData
  lResults <- RunWorkflow(lWorkflow=test_wf[[1]], lData=lMapped)

  #functional workflow
  dfInput <- Input_Rate(
    dfSubjects= clindata::rawplus_dm,
    dfNumerator= clindata::rawplus_ae,
    dfDenominator = clindata::rawplus_dm,
    strSubjectCol = "subjid",
    strGroupCol = "siteid",
    strNumeratorMethod= "Count",
    strDenominatorMethod= "Sum",
    strDenominatorCol= "timeonstudy"
  )
  dfTransformed <- Transform_Rate(dfInput)
  dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "rate")
  dfFlagged <- Flag_NormalApprox(dfAnalyzed, vThreshold = c(-2,-1,2,3))

  expect_equal(dfFlagged$Flag, lResults$lData$dfFlagged$Flag)
  expect_equal(dim(lResults$lData$dfFlagged), dim(dfFlagged))

})
