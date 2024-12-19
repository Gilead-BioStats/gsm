test_that("output created as expected and has correct structure", {
  dfFlagged <- tibble::tibble(
    GroupID = c("702", "703", "701"),
    GroupLevel = rep("site", 3),
    Numerator = c(1, 3, 5),
    Denominator = c(180, 14, 210),
    Metric = c(0.0055, 0.2142, 0.0238),
    Score = c(-1.37, 0.0684, 1.01),
    PredictedCount = c(3.05, 2.88, 3.06),
    Flag = c(0, 0, 0)
  )
  ae_default <- Summarize(dfFlagged)
  expect_true(is.data.frame(ae_default))
  expect_equal(
    names(ae_default),
    c("GroupID", "GroupLevel", "Numerator", "Denominator", "Metric", "Score", "Flag")
  )
  expect_equal(sort(unique(dfFlagged$GroupID)), sort(ae_default$GroupID))

  ae_finding <- Summarize(dfFlagged)
  expect_true(is.data.frame(ae_finding))
  expect_equal(
    names(ae_finding),
    c("GroupID", "GroupLevel", "Numerator", "Denominator", "Metric", "Score", "Flag")
  )
  expect_equal(sort(unique(dfFlagged$GroupID)), sort(ae_finding$GroupID))
})

test_that("incorrect inputs throw errors", {
  dfFlagged <- tibble::tibble(
    GroupID = c("702", "703", "701"),
    GroupLevel = rep("site", 3),
    Numerator = c(1, 3, 5),
    Denominator = c(180, 14, 210),
    Metric = c(0.0055, 0.2142, 0.0238),
    Score = c(-1.37, 0.0684, 1.01),
    PredictedCount = c(3.05, 2.88, 3.06),
    Flag = c(0, 0, 0)
  )
  expect_error(Summarize(list()), "dfFlagged is not a data frame")
  expect_error(Summarize("Hi"), "dfFlagged is not a data frame")
  expect_message(
    Summarize(dfFlagged, 12312), "have insufficient sample size"
  )
})

test_that("output is correctly sorted by Flag and Score", {
  sim1 <- data.frame(
    GroupID = seq(1:100),
    GroupLevel = rep("site", 100),
    N = seq(1:100),
    Metric = rep(NA, 100),
    Score = c(rep(0, 20), rep(1, 80)),
    Flag = c(rep(-1, 9), rep(0, 91))
  )

  expect_equal(Summarize(sim1)$Flag, c(rep(-1, 9), rep(0, 91)))

  sim2 <- data.frame(
    GroupID = seq(1, 100),
    GroupLevel = rep("site", 100),
    N = seq(1, 100),
    Metric = c(seq(1, 5), seq(6, 1), rep(11, 89)),
    Score = c(seq(1, 5), seq(6, 1), rep(11, 89)),
    Flag = c(rep(-1, 9), rep(0, 91))
  )

  expect_equal(Summarize(sim2)$Score, c(6, 5, 5, 4, 4, 3, 3, 2, 1, rep(11, 89), 2, 1))
})

# test_that("yaml workflow produces same table as R function", {
#   source(test_path("testdata", "create_double_data.R"), local = TRUE)
#   expect_equal(dfSummarized$Flag, lResults$Analysis_kri0001$Analysis_Summary$Flag)
#   expect_equal(dim(dfSummarized), dim(lResults$Analysis_kri0001$Analysis_Summary))
# })
