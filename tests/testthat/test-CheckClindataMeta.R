check <- CheckClindataMeta(ci_check = TRUE)

testthat::test_that("versions are in sync", {
  status <- all(check$status)

  expect_true(status)
})
