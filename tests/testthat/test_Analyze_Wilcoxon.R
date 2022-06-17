source(testthat::test_path("testdata/data.R"))

ae_input <- AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE))
ae_prep <- Transform_EventCount(ae_input, strCountCol = "Count", strExposureCol = "Exposure")

test_that("output created as expected and has correct structure", {
  aew_anly <- Analyze_Wilcoxon(ae_prep)
  expect_true(is.data.frame(aew_anly))
  expect_true(all(c(
    "SiteID", "N", "TotalCount", "TotalExposure", "KRI", "KRILabel",
    "Estimate", "Score", "ScoreLabel"
  ) %in% names(aew_anly)))
  expect_equal(sort(unique(ae_input$SiteID)), sort(aew_anly$SiteID))
})

test_that("incorrect inputs throw errors", {
  expect_error(Analyze_Wilcoxon(list()))
  expect_error(Analyze_Wilcoxon("Hi"))
  expect_error(
    Analyze_Wilcoxon(ae_prep %>% mutate(SiteID = ifelse(SiteID == first(SiteID), NA, SiteID)))
  )
  expect_error(Analyze_Wilcoxon(ae_prep, strOutcomeCol = 1))
  expect_error(Analyze_Wilcoxon(ae_prep, strOutcomeCol = "coffee"))
  expect_error(Analyze_Wilcoxon(ae_prep, strOutcomeCol = c("Rate", "something else")))
  expect_error(Analyze_Wilcoxon(ae_prep, strPredictorCol = 1))
  expect_error(Analyze_Wilcoxon(ae_prep, strPredictorCol = "coffee"))
  expect_error(Analyze_Wilcoxon(ae_prep, strPredictorCol = c("Rate", "something else")))
})

test_that("error given if required column not found", {
  expect_error(Analyze_Wilcoxon(ae_prep %>% rename(total = TotalCount)))
  expect_error(Analyze_Wilcoxon(ae_prep %>% select(-Rate)))
  expect_error(Analyze_Wilcoxon(ae_prep %>% select(-SiteID)))
})

test_that("model isn't run with fewer than three records", {
  aew_anly <- Analyze_Wilcoxon(
    ae_prep %>% filter(row_number() < 3)
  )

  expect_true(is.data.frame(aew_anly))
  expect_true(all(c("SiteID", "N", "TotalCount", "TotalExposure", "KRI", "KRILabel", "Estimate", "Score", "ScoreLabel") %in% names(aew_anly)))
  expect_true(all(is.na(aew_anly$Estimate)))
  expect_true(all(is.na(aew_anly$Score)))
})

test_that("model isn't run with a single outcome value", {
  aew_anly <- Analyze_Wilcoxon(
    ae_prep %>% mutate(KRI = .5)
  )

  expect_true(is.data.frame(aew_anly))
  expect_true(all(c("SiteID", "N", "TotalCount", "TotalExposure", "KRI", "KRILabel", "Estimate", "Score", "ScoreLabel") %in% names(aew_anly)))
  expect_true(all(is.na(aew_anly$Score)))
  expect_true(all(is.na(aew_anly$Estimate)))
})

test_that("bQuiet works as intended", {
  dfTransformed <- Transform_EventCount(ae_input, strCountCol = "Count", strExposureCol = "Exposure")
  expect_snapshot(
    dfAnalyzed <- Analyze_Poisson(dfTransformed, bQuiet = FALSE)
  )
})
