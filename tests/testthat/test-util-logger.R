# test-util-cli_logger_wrappers.R
test_that("Use cli style messages via logger", {
  expect_snapshot(LogMessage(level = "info", message = "cli style info", cli_detail = "h1"))
  expect_snapshot(LogMessage(level = "info", message = "cli style info",  cli_detail = "h2"))
  expect_snapshot(LogMessage(level = "info", message = "cli style info",  cli_detail = "h3"))
  expect_snapshot(LogMessage(level = "info", message = "cli style info",  cli_detail = "alert_success"))
  expect_snapshot(tryCatch(LogMessage(level = "warn", message = "cli style warn")))
  expect_snapshot(tryCatch(LogMessage(level = "error", message = "cli style error")))
})
