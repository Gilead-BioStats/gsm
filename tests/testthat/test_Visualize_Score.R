source(testthat::test_path("testdata/data.R"))

ae <- AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ)) %>%
  AE_Assess()

ae$dfFlagged$Flag <- c(0, 1, -1) # add dummy flags

test_that("default output is produced ", {
  expect_silent(Visualize_Score(ae$dfFlagged))
})

test_that("incorrect inputs throw errors", {
  expect_error(Visualize_Score(list()))
  expect_error(Visualize_Score("Hi"))
  expect_error(Visualize_Score(ae$dfFlagged, bFlagFilter = "TRUE"))
  expect_error(Visualize_Score(ae$dfFlagged, strTitle = list()))
  expect_error(Visualize_Score(ae$dfFlagged, strType = "penguin"))
  expect_error(Visualize_Score(ae$dfFlagged, strType = c("KRI", "score")))
})

test_that("filtered plot is produced", {
  expect_silent(Visualize_Score(ae$dfFlagged, bFlagFilter = TRUE))
})

test_that("score plot is produced", {
  expect_silent(Visualize_Score(ae$dfFlagged, strType = "score"))
})
