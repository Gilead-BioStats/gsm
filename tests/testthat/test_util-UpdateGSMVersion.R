# Install and load the `testthat` package
# Write your test cases using test_that() function
test_that("Test Case 1: make sure version information is consistent in relevant files", {
  # setup current version information
  files <- list.files(system.file("data-raw", package = "gsm"), full.names = TRUE)
  csvs <- files[(grepl(".csv", files) & !grepl("rbm_data_spec", files))]

  current_ver <- desc::desc_get_version()
  expect_true(all(current_ver == map_vec(csvs, ~read.csv(., nrows = 1)$gsm_version)))

# this modifies files so I commented it out, but it works as intended as of 1/18/2024
#   # test functionality
#   new_ver <- "1.8.0"
#   UpdateGSMVersion(new_ver)
#
#   expect_true(new_ver == desc::desc_get_version())
#   expect_true(all(new_ver == map_vec(csvs, ~read.csv(., nrows = 1)$gsm_version)))
#
#   # revert to previous version
#   UpdateGSMVersion(current_ver)
})


