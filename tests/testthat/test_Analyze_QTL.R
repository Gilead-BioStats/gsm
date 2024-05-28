# binary outcome ----------------------------------------------------------
dfTransformed <- tibble::tibble(
  GroupID      = c("AA-AA-000-0000"),
  Numerator    = c(122),
  Denominator  = c(1301),
  Metric       = c(0.0938)
)
dfAnalyzed <- Analyze_QTL(dfTransformed, strOutcome = "binary")


# rate outcome ------------------------------------------------------------
dfTransformedRate <- tibble::tibble(
  GroupID      = c("AA-AA-000-0000"),
  Numerator    = c(4473),
  Denominator  = c(6.19),
  Metric       = c(723)
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
    Analyze_QTL("not a dataframe")
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
