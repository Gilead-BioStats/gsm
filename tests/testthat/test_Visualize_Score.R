skip()
source(testthat::test_path("testdata/data.R"))

ae <- AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ)) %>%
  AE_Assess()

ae$lData$dfFlagged$Flag <- c(0, 1, -1) # add dummy flags

test_that("default output is produced ", {
  expect_silent(Visualize_Score(ae$lData$dfFlagged))
})

test_that("incorrect inputs throw errors", {
  expect_error(Visualize_Score(list()))
  expect_error(Visualize_Score("Hi"))
  expect_error(Visualize_Score(ae$lData$dfFlagged, bFlagFilter = "TRUE"))
  expect_error(Visualize_Score(ae$lData$dfFlagged, strTitle = list()))
  expect_error(Visualize_Score(ae$lData$dfFlagged, strType = "penguin"))
  expect_error(Visualize_Score(ae$lData$dfFlagged, strType = c("KRI", "score")))
})

test_that("filtered plot is produced", {
  expect_silent(Visualize_Score(ae$lData$dfFlagged, bFlagFilter = TRUE))
})

test_that("score plot is produced", {
  expect_silent(Visualize_Score(ae$lData$dfFlagged, strType = "score"))
})
