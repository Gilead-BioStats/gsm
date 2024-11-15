# test-util-logger.R
test_print <- function(x){
  LogMessage(type = "warning", message = x)
}

test_that("Use cli mode", {
  expect_snapshot(test_print("test1"))
})

test_that("Use log4r mode", {
  test_logger <- log4r::logger()
  SetLogger(test_logger)
  expect_snapshot(test_print("test2"))
})
