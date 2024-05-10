dfFlagged <- tibble::tibble(
  GroupID = c("702", "703", "701"),
  Numerator = c(1, 3, 5),
  Denominator = c(180, 14, 210),
  Metric = c(0.0055, 0.2142, 0.0238),
  Score = c(-1.37, 0.0684, 1.01),
  PredictedCount = c(3.05, 2.88, 3.06),
  Flag = c(0, 0, 0)
)

test_that("output created as expected and has correct structure", {
  ae_default <- Summarize(dfFlagged, strScoreCol = "Score")
  expect_true(is.data.frame(ae_default))
  expect_equal(
    names(ae_default),
    c("GroupID", "Numerator", "Denominator", "Metric", "Score", "Flag")
  )
  expect_equal(sort(unique(dfFlagged$GroupID)), sort(ae_default$GroupID))

  ae_finding <- Summarize(dfFlagged, strScoreCol = "Score")
  expect_true(is.data.frame(ae_finding))
  expect_equal(
    names(ae_finding),
    c("GroupID", "Numerator", "Denominator", "Metric", "Score", "Flag")
  )
  expect_equal(sort(unique(dfFlagged$GroupID)), sort(ae_finding$GroupID))
})

test_that("incorrect inputs throw errors", {
  expect_error(Summarize(list()))
  expect_error(Summarize("Hi"))
  expect_error(Summarize(ae_flag, 12312))
  expect_error(Summarize(dfFlagged, strScoreCol = "wombat"))
})

test_that("output is correctly sorted by Flag and Score", {
  sim1 <- data.frame(
    GroupID = seq(1:100),
    N = seq(1:100),
    Metric = rep(NA, 100),
    Score = c(rep(0, 20), rep(1, 80)),
    Flag = c(rep(-1, 9), rep(0, 91))
  )

  expect_equal(Summarize(sim1)$Flag, c(rep(-1, 9), rep(0, 91)))

  sim1 <- data.frame(
    GroupID = seq(1, 100),
    N = seq(1, 100),
    Metric = c(seq(1, 5), seq(6, 1), rep(11, 89)),
    Score = c(seq(1, 5), seq(6, 1), rep(11, 89)),
    Flag = c(rep(-1, 9), rep(0, 91))
  )

  expect_equal(Summarize(sim1)$Score, c(6, 5, 5, 4, 4, 3, 3, 2, 1, rep(11, 89), 2, 1))
})

