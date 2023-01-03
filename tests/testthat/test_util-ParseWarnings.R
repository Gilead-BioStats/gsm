source(testthat::test_path("testdata/data.R"))
load(testthat::test_path("testdata/StudyStandard.RData"))

dfAE <- dfAE %>%
  mutate(subjid = NA)
dfSUBJ <- dfSUBJ

lData <- list(
  dfAE = dfAE,
  dfSUBJ = dfSUBJ
)

lResults <- StudyStandard
warnings <- ParseWarnings(lResults)

test_that("output is generated as expected", {
  expect_true("data.frame" %in% class(warnings))
  expect_equal(names(warnings), c("notes", "workflowid"))
})

test_that("invalid data throw errors", {
  expect_true(is.list(lResults))
  expect_null(warnings("Hi")[["lData"]])
  expect_error(ParseWarnings(dfSUBJ))
})
