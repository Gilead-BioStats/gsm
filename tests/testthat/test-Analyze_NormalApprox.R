test_that("binary output created as expected and has correct structure", {
  dfTransformed <- test_dfTransformed
  expect_message(
    {binary <- Analyze_NormalApprox(dfTransformed, strType = "binary")},
    "`OverallMetric`,"
  )

  expect_true(is.data.frame(binary))
  expect_equal(names(binary), c("GroupID", "GroupLevel", "Numerator", "Denominator", "Metric", "OverallMetric", "Factor", "Score"))
  expect_type(binary$GroupID, "character")
  expect_type(c(binary$Numerator, binary$Denominator, binary$Metric, binary$OverallMetric, binary$Factor, binary$Score), "double")
  expect_equal(unique(binary$GroupID), c("166", "86", "76"))
})

test_that("rate output created as expected and has correct structure", {
  dfTransformed <- Transform_Rate(sampleInput)

  rate <- quiet_Analyze_NormalApprox(dfTransformed, strType = "rate")

  expect_true(is.data.frame(rate))
  expect_equal(names(rate), c("GroupID", "GroupLevel", "Numerator", "Denominator", "Metric", "OverallMetric", "Factor", "Score"))
  expect_type(rate$GroupID, "character")
  expect_type(c(rate$Numerator, rate$Denominator, rate$Metric, rate$OverallMetric, rate$Factor, rate$Score), "double")
  expect_equal(unique(rate$GroupID)[1:5], c("G1", "G4" ,"G7", "G3", "G2"))
})

test_that("incorrect inputs throw errors", {
  dfTransformed <- test_dfTransformed
  expect_error(Analyze_NormalApprox(list()))
  expect_error(Analyze_NormalApprox("Hi"))
  expect_error(Analyze_NormalApprox(dfTransformed, strOutcome = ":("))
  expect_error(Analyze_NormalApprox(dfTransformed, strType = "sadie"))
})

test_that("error given if required column not found", {
  dfTransformed <- test_dfTransformed
  expect_error(Analyze_NormalApprox(dfTransformed %>% select(-GroupID)))
  expect_error(Analyze_NormalApprox(dfTransformed %>% select(-Numerator)))
  expect_error(Analyze_NormalApprox(dfTransformed %>% select(-Denominator)))
  expect_error(Analyze_NormalApprox(dfTransformed %>% select(-Metric)))
})

test_that("NAs are handled correctly", {
  dfTransformed <- test_dfTransformed
  createNA <- function(data, variable) {
    data[[variable]][[1]] <- NA
    return(quiet_Analyze_NormalApprox(data))
  }
  expect_error(createNA(data = dfTransformed, variable = "GroupID"))
})

test_that("Score (z_i) is 0 when vMu is 1 or 0", {
  dfTransformed <- test_dfTransformed
  # z_i == 1
  result_one <- quiet_Analyze_NormalApprox(
    dfTransformed %>%
      mutate(Numerator = 1, Denominator = 1, Metric = 1),
    strType = "rate"
  )

  # z_i == 0
  result_zero <- quiet_Analyze_NormalApprox(
    dfTransformed %>%
      mutate(Numerator = 0, Denominator = 1, Metric = 0),
    strType = "rate"
  )

  expect_true(all(result_one$Score == 0))
  expect_true(all(result_zero$Score == 0))
})

test_that("yaml workflow produces same table as R function", {
  # yaml workflow
  test_wf <- MakeWorkflowList(strPath = test_path("testdata"), strNames = "test_workflow")
  test_mapping <- MakeWorkflowList(strPath = test_path("testdata"), strNames = "mapping")
  lRaw <- UseClindata(
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
  expect_message(
    {
      dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "rate")
    },
    "`OverallMetric`"
  )

  expect_equal(dfAnalyzed$Metric, lResults$dfAnalyzed$Metric)
  expect_equal(dim(dfAnalyzed), dim(lResults$dfAnalyzed))
})
