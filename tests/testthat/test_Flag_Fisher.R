source(testthat::test_path("testdata/data.R"))

dfTransformed <- Transform_Rate(
  dfInput = dfInputLB,
  strGroupCol = "SiteID",
  strNumeratorCol = "Count",
  strDenominatorCol = "Total"
)

dfAnalyzed <- Analyze_Fisher(dfTransformed)

test_that("output is created as expected", {
  dfFlagged <- Flag_Fisher(dfAnalyzed, vThreshold = c(-.05, .05))
  expect_true(is.data.frame(dfFlagged))
  expect_equal(sort(unique(dfInputLB$SiteID)), sort(dfFlagged$GroupID))
  expect_true(all(names(dfAnalyzed) %in% names(dfFlagged)))
  expect_equal(names(dfFlagged), c("GroupID", "Numerator", "Numerator_Other", "Denominator", "Denominator_Other", "Prop", "Prop_Other", "Metric", "Estimate", "Score", "Flag"))
  expect_equal(length(unique(dfAnalyzed$GroupID)), length(unique(dfFlagged$GroupID)))
  expect_equal(length(unique(dfAnalyzed$GroupID)), nrow(dfFlagged))
})

test_that("incorrect inputs throw errors", {
  expect_error(Flag_Fisher(list(), vThreshold = c(-2, 2)), "dfAnalyzed is not a data frame")
  expect_error(Flag_Fisher(dfAnalyzed, "1", "2"))
  expect_error(Flag_Fisher(dfAnalyzed, vThreshold = c("-2", "2")), "vThreshold is not numeric")
  expect_error(Flag_Fisher(dfAnalyzed, vThreshold = c(-1, 0, 1)), "vThreshold must be length of 2")
  expect_error(Flag_Fisher(dfAnalyzed, vThreshold = NULL))
  expect_error(Flag_Fisher(dfAnalyzed %>% select(-c(GroupID))))
  expect_error(Flag_Fisher(dfAnalyzed, vThreshold = c(4, 3)))
})

test_that("flagging works correctly", {
  dfAnalyzedCustom <- tibble::tribble(
    ~GroupID, ~Numerator, ~Numerator_Other, ~Denominator, ~Denominator_Other, ~Prop, ~Prop_Other, ~Metric, ~Estimate, ~Score,
    "100", 77, 31697, 1667, 1130403, 0.04619076, 0.02804044, 0.04619076, 1.6786274, 3.938196e-05,
    "101", 52, 31722, 2622, 1129448, 0.01983219, 0.02808629, 0.01983219, 0.7001692, 9.084693e-03,
    "102", 62, 31712, 2685, 1129385, 0.02309125, 0.02807900, 0.02309125, 0.8181680, 1.279212e-01
  )

  expect_silent(dfFlagged <- Flag_Fisher(dfAnalyzedCustom, vThreshold = c(-.05, .05)))
  expect_equal(dfFlagged$Flag, c(1, -1, 0))
})
