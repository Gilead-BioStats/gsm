dfAnalyzed <- tibble::tribble(
  ~GroupID,         ~Numerator, ~Denominator,  ~Metric, ~Method,                ~ConfLevel, ~Estimate, ~LowCI, ~UpCI,  ~Score,
  "AA-AA-000-0000",  122,         1301,        0.0937,  "Exact binomial test",  0.95,       0.0937,    0.0784, 0.1109, 0.0784
)

dfAnalyzed %>%
  mutate(Score = NA) %>%
  Flag_QTL(vThreshold = 1)


test_that("output is created as expected", {
  dfFlagged <- Flag_QTL(dfAnalyzed, vThreshold = 0.2)
  expect_true(is.data.frame(dfFlagged))
  expect_true(all(names(dfAnalyzed) %in% names(dfFlagged)))
  expect_snapshot(names(dfFlagged))
})

test_that("incorrect inputs throw errors", {
  expect_error(Flag_QTL(list(), vThreshold = 1))
  expect_error(Flag_QTL(dfAnalyzed %>% select(-Score), vThreshold = 1))
  expect_error(Flag_QTL(dfAnalyzed %>% select(-LowCI), vThreshold = 1))
  expect_error(Flag_QTL(dfAnalyzed, vThreshold = "1"))
  expect_error(Flag_QTL(dfAnalyzed, vThreshold = c(1, 2)))
  expect_error(Flag_QTL(dfAnalyzed))
})
