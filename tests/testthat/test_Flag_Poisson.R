dfAnalyzed <- tibble::tribble(
  ~GroupID, ~Numerator, ~Denominator, ~Metric, ~Score, ~PredictedCount,
  "109", 0, 848, 0, -3.39, 5.74,
  "144", 0, 761, 0, -3.31, 5.48,
  "177", 0, 676, 0, -3.23, 5.22,
  "176", 0, 673, 0, -3.23, 5.21,
  "127", 0, 569, 0, -3.12, 4.86,
  "15", 1, 842, 0.00119, -2.44, 5.72,
  "34", 1, 841, 0.00119, -2.44, 5.72,
  "146", 1, 836, 0.00120, -2.43, 5.70
)

test_that("output is created as expected", {
  dfFlagged <- Flag_Poisson(dfAnalyzed, vThreshold = c(-.05, -.005, .005, .05))
  expect_true(is.data.frame(dfFlagged))
  expect_equal(sort(unique(dfAnalyzed$GroupID)), sort(dfFlagged$GroupID))
  expect_true(all(names(dfAnalyzed) %in% names(dfFlagged)))
  expect_equal(names(dfFlagged), c("GroupID", "Numerator", "Denominator", "Metric", "Score", "PredictedCount", "Flag"))
  expect_equal(length(unique(dfAnalyzed$GroupID)), length(unique(dfFlagged$GroupID)))
  expect_equal(length(unique(dfAnalyzed$GroupID)), nrow(dfFlagged))
})

test_that("incorrect inputs throw errors", {
  expect_error(Flag_Poisson(list(), vThreshold = c(-2, -1, 1, 2)), "dfAnalyzed is not a data frame")
  expect_error(Flag_Poisson(dfAnalyzed, "1", "2"))
  expect_error(Flag_Poisson(dfAnalyzed, vThreshold = c("-2", "-1", "1", "2")), "vThreshold is not numeric")
  expect_error(Flag_Poisson(dfAnalyzed, vThreshold = c(-1, 1)), "vThreshold must be length of 4")
  expect_error(Flag_Poisson(dfAnalyzed, vThreshold = NULL))
  expect_error(Flag_Poisson(dfAnalyzed, vThreshold = c(4, 3, 2, 1)))
})

test_that("flagging works correctly", {
  dfAnalyzedCustom <- tibble::tribble(
    ~GroupID, ~Numerator, ~Denominator, ~Metric, ~Score, ~PredictedCount,
    "166", 5L, 857L, 0.0058343057176196, -11, 5.12722560489132,
    "76", 2L, 13L, 0.153846153846154, -6, 2.00753825876477,
    "86", 5L, 678L, 0.00737463126843658, 6, 4.86523613634436,
    "80", 5L, 678L, 0.00737463126843658, 11, 4.86523613634436
  )

  expect_silent(dfFlagged <- Flag_Poisson(dfAnalyzedCustom, vThreshold = c(-10, -5, 5, 10)))
  expect_equal(dfFlagged$Flag, c(2, -2, 1, -1))
})
