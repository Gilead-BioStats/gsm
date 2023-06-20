check <- CheckClindataMeta(ci_check = TRUE) %>% suppressMessages()

testthat::test_that("versions are in sync", {
  status <- all(check$status)

  expect_true(status)
})

test_that("FALSE ci_check returns null", {
  expect_message(
    output <- CheckClindataMeta(ci_check = FALSE)
  )

  expect_null(output)
})

test_that("mismatch returns warning", {
  config <- list(
    config_param = gsm::config_param %>% mutate(gsm_version = "1.2.3"),
    config_workflow = gsm::config_workflow
  )

  expect_message(
    CheckClindataMeta(config = config)
  )
})
