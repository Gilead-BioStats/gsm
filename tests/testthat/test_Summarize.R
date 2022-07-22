source(testthat::test_path("testdata/data.R"))

ae_input <- AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE))

dfTransformed <- Transform_EventCount(
  ae_input,
  strCountCol = "Count",
  strExposureCol = "Exposure",
  strGroupCol = "SiteID",
  strKRILabel = "AEs/Week"
  )
dfAnalyzed <- gsm::Analyze_Poisson(dfTransformed)
dfFlagged <- gsm::Flag(dfAnalyzed, vThreshold = c(-5, 5))

test_that("output created as expected and has correct structure", {
  ae_default <- Summarize(dfFlagged, strScoreCol = "Score")
  expect_true(is.data.frame(ae_default))
  expect_equal(names(ae_default), c("GroupID", "GroupLabel", "N", "KRI", "KRILabel", "Score", "ScoreLabel", "Flag"))
  expect_equal(sort(unique(ae_input$SiteID)), sort(ae_default$GroupID))

  ae_finding <- Summarize(dfFlagged, strScoreCol = "Score", lTags = list(Assessment = "Safety", Label = "Test Assessment"))
  expect_true(is.data.frame(ae_finding))
  expect_equal(names(ae_finding), c("GroupID", "GroupLabel", "N", "KRI", "KRILabel", "Score", "ScoreLabel",
                                    "Flag", "Assessment", "Label"))
  expect_equal(sort(unique(ae_input$SiteID)), sort(ae_finding$GroupID))
})

test_that("incorrect inputs throw errors", {
  expect_error(Summarize(list()))
  expect_error(Summarize("Hi"))
  expect_error(Summarize(ae_flag, 12312))
  expect_error(Summarize(dfFlagged, strScoreCol = "wombat"))
})

test_that("invalid lTags throw error", {
  expect_error(Summarize(dfFlagged, lTags = "hi mom"))
  expect_error(Summarize(dfFlagged, lTags = list("hi", "mom")))
  expect_error(Summarize(dfFlagged, lTags = list(greeting = "hi", "mom")))
  expect_silent(Summarize(dfFlagged, lTags = list(greeting = "hi", person = "mom")))
})

test_that("output is correctly sorted by Flag and Score", {
  sim1 <- data.frame(
    GroupID = seq(1:100),
    GroupLabel = "Test",
    N = seq(1:100),
    KRI = rep(NA, 100),
    KRILabel = "cats",
    Score = c(rep(0, 20), rep(1, 80)),
    ScoreLabel = "dogs",
    Flag = c(rep(-1, 9), rep(0, 91))
  )

  expect_equal(Summarize(sim1)$Flag, c(rep(-1, 9), rep(0, 91)))

  sim1 <- data.frame(
    GroupID = seq(1, 100),
    GroupLabel = "Test",
    N = seq(1, 100),
    KRI = c(seq(1, 5), seq(6, 1), rep(11, 89)),
    KRILabel = "fictitious things by general relativity",
    Score = c(seq(1, 5), seq(6, 1), rep(11, 89)),
    ScoreLabel = "homerun",
    Flag = c(rep(-1, 9), rep(0, 91))
  )

  expect_equal(Summarize(sim1)$Score, c(6, 5, 5, 4, 4, 3, 3, 2, 1, rep(11, 89), 2, 1))
})
