test_that("Report_FormatFlag formats all expected values", {
  local_mocked_bindings(
    fa_titled = function(name, fill, title) {
      name
    }
  )
  flag_value <- c(NA, -2, -1, 0, 1, 2)
  expect_identical(
    Report_FormatFlag(flag_value),
    c("minus", "angles-down", "angle-down", "check", "angle-up", "angles-up")
  )
})
