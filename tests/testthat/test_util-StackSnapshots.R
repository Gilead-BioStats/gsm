# TODO: possibly move snapshot data from `../data-raw/AA-AA-000-0000` to `../inst`
#       where it's accessible from the package structure + testing env.

# cPath <- system.file('data-raw', 'AA-AA-000-0000', package = "gsm")
#
# test_that("all expected datasets are present in stacked data", {
#
#   expected_data <- c("meta_param", "meta_workflow", "results_analysis", "results_summary",
#                      "status_param", "status_site", "status_study", "status_workflow",
#                      "parameters")
#
#   stacked_data <- StackSnapshots(cPath = cPath)
#
#   expect_true(all(expected_data %in% names(stacked_data)))
#   expect_type(stacked_data, "list")
#
# })


test_that("error is thrown when cPath does not exist", {
  cPath <- "path/to/nonexistent/folder"
  expect_error(StackSnapshots(cPath))
})
