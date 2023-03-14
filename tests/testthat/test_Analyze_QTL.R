

# binary outcome ----------------------------------------------------------
dfInput <- Disp_Map_Raw()
dfTransformed <- Transform_Rate(
  dfInput,
  strNumeratorCol = "Count",
  strDenominatorCol = "Total",
  strGroupCol = "StudyID"
)
dfAnalyzed <- Analyze_QTL(dfTransformed, strOutcome = "binary")


# rate outcome ------------------------------------------------------------
dfInputRate <- PD_Map_Raw_Binary()
dfTransformedRate <- Transform_Rate(
  dfInputRate,
  strGroupCol = "StudyID",
  strNumeratorCol = "Count",
  strDenominatorCol = "Total"
)
dfAnalyzedRate <- Analyze_QTL(dfTransformedRate, strOutcome = "rate")


# start tests -------------------------------------------------------------
test_that("binary outcome returns expected results", {
  expect_equal(1, nrow(dfAnalyzed))
  expect_snapshot(names(dfAnalyzed))
  expect_equal(dfAnalyzed$Method, "Exact binomial test")
})

test_that("rate outcome returns expected results", {


  expect_equal(1, nrow(dfAnalyzedRate))
  expect_snapshot(names(dfAnalyzedRate))
  expect_equal(dfAnalyzedRate$Method, "Exact Poisson test")
})

test_that("bad inputs are caught", {
  expect_error(
    Analyze_QTL('not a dataframe')
  )

  expect_error(
    Analyze_QTL(dfAnalyzed %>% select(-GroupID))
  )

  expect_error(
    Analyze_QTL(dfAnalyzed %>% select(-Numerator))
  )

  expect_error(
    Analyze_QTL(dfAnalyzed %>% select(-Denominator))
  )

  expect_error(
    Analyze_QTL(dfAnalyzed %>% mutate(GroupID = NA))
  )


})
