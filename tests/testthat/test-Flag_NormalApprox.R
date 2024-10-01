test_that("output is created as expected", {
  dfAnalyzed <- Transform_Rate(analyticsInput) %>% quiet_Analyze_NormalApprox()
  dfFlagged <- Flag_NormalApprox(dfAnalyzed, vThreshold = c(-3, -2, 2, 3))
  expect_true(is.data.frame(dfFlagged))
  expect_equal(sort(unique(dfAnalyzed$GroupID)), sort(dfFlagged$GroupID))
  expect_true(all(names(dfAnalyzed) %in% names(dfFlagged)))
  expect_equal(names(dfFlagged), c("GroupID", "GroupLevel", "Numerator", "Denominator", "Metric", "OverallMetric", "Factor", "Score", "Flag"))
  expect_equal(length(unique(dfAnalyzed$GroupID)), length(unique(dfFlagged$GroupID)))
  expect_equal(length(unique(dfAnalyzed$GroupID)), nrow(dfFlagged))
})

test_that("incorrect inputs throw errors", {
  dfAnalyzed <- Transform_Rate(analyticsInput) %>% quiet_Analyze_NormalApprox()
  expect_error(Flag_NormalApprox(list(), vThreshold = c(-3, -2, 2, 3)), "dfAnalyzed is not a data frame")
  expect_error(Flag_NormalApprox(dfAnalyzed, "1", "2"))
  expect_error(Flag_NormalApprox(dfAnalyzed, vThreshold = c("-3", "-2", "2", "3")), "vThreshold is not numeric")
  expect_error(Flag_NormalApprox(dfAnalyzed, vThreshold = c(-1, 0, 1)), "vThreshold must be length of 4")
  expect_error(Flag_NormalApprox(dfAnalyzed, vThreshold = NULL))
  expect_error(Flag_NormalApprox(dfAnalyzed %>% select(-c(GroupID))))
  expect_error(Flag_NormalApprox(dfAnalyzed, vThreshold = c(4, 3, 2, 1)))
})

test_that("flagging works correctly", {
  dfAnalyzedCustom <- tibble::tribble(
    ~GroupID, ~Numerator, ~Denominator, ~Metric, ~OverallMetric, ~Factor, ~Score,
    "139", 0, 2, 0, 0.08, 0.910, -0.437,
    "109", 0, 1, 0, 0.08, 0.910, -0.309,
    "43", 1, 2, 0.5, 0.08, 0.910, 2.295,
    "127", 1, 1, 1, 0.08, 0.910, 3.554
  )

  expect_silent({
    dfFlagged <- Flag_NormalApprox(dfAnalyzedCustom, vThreshold = c(-3, -2, 2, 3))
  })
  expect_equal(dfFlagged$Flag, c(2, 1, 0, 0))
})

test_that("yaml workflow produces same table as R function", {
  source(test_path("testdata", "create_double_data.R"), local = TRUE)
  expect_equal(dfFlagged$Flag, lResults$Analysis_kri0001$Analysis_Flagged$Flag)
  expect_equal(dim(dfFlagged), dim(lResults$Analysis_kri0001$Analysis_Flagged))
})
