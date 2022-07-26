source(testthat::test_path("testdata/data.R"))

ae_input <- AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE))

test_that("output created as expected and has correct structure", {
  ae_prep <- Transform_EventCount(
    ae_input,
    strCountCol = "Count",
    strGroupCol = "SiteID",
    strExposureCol = "Exposure"
    )
  ae_anly <- Analyze_Poisson(ae_prep)
  expect_true(is.data.frame(ae_anly))
  expect_equal(sort(unique(ae_input$SiteID)), sort(ae_anly$GroupID))
  expect_equal(names(ae_anly), c("GroupID", "GroupLabel", "N", "TotalCount", "TotalExposure",
                                 "KRI", "KRILabel", "Score", "ScoreLabel", "PredictedCount"))
})

test_that("incorrect inputs throw errors", {
  expect_error(Analyze_Poisson(list()))
  expect_error(Analyze_Poisson("Hi"))
})


test_that("error given if required column not found", {
  ae_prep <- Transform_EventCount(
    ae_input,
    strCountCol = "Count",
    strGroupCol = "SiteID",
    strExposureCol = "Exposure"
    )
  expect_error(Analyze_Poisson(ae_prep %>% select(-GroupID)))
  expect_error(Analyze_Poisson(ae_prep %>% select(-N)))
  expect_error(Analyze_Poisson(ae_prep %>% select(-TotalCount)))
  expect_error(Analyze_Poisson(ae_prep %>% select(-TotalExposure)))
  expect_error(Analyze_Poisson(ae_prep %>% select(-Rate)))
})

test_that("NA values are caught", {
  createNA <- function(x) {
    df <- AE_Map_Adam(safetyData::adam_adsl, safetyData::adam_adae) %>%
      Transform_EventCount(strCountCol = "Count", strExposureCol = "Exposure")

    df[[x]][1] <- NA

    Analyze_Poisson(df)
  }

  expect_error(createNA("GroupID"))

})

test_that("bQuiet works as intended", {
  dfTransformed <- Transform_EventCount(
    ae_input,
    strCountCol = "Count",
    strGroupCol = "SiteID",
    strExposureCol = "Exposure"
    )
  expect_snapshot(
    dfAnalyzed <- Analyze_Poisson(dfTransformed, bQuiet = FALSE)
  )
})
