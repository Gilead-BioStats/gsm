dfAE <- clindata::rawplus_ae[1:50,] %>%
  mutate(subjid = NA)
dfSUBJ <- clindata::rawplus_dm[1:50,]

lData <- list(
  dfAE = dfAE,
  dfSUBJ = dfSUBJ
)

lResults <- Study_Assess(lData = lData)
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
