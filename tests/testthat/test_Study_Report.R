# Install and load the `testthat` package
source(testthat::test_path("testdata/data.R"))

# Write tests for Study_Report function
test_that("Study_Report function works as expected", {
  install_version("pandoc", version = "2.9.1")

  snapshot <- Make_Snapshot(lData = lData)

  # Create temporary output file path
  tmp_outpath <- tempfile(fileext = ".html")

  # Test the function with different report types
  expect_error(
    Study_Report(snapshot, strOutpath = tmp_outpath, strReportType = "person")
  )

  Study_Report(snapshot, strOutpath = tmp_outpath, strReportType = "site")
  expect_true(
    file.exists(tmp_outpath), "Site report file should be created"
  )

  Study_Report(snapshot, strOutpath = tmp_outpath, strReportType = "country")
  expect_true(
    file.exists(tmp_outpath), "Country report file should be created"
  )

  Study_Report(snapshot, strOutpath = tmp_outpath, strReportType = "QTL")
  expect_true(
    file.exists(tmp_outpath), "QTL report file should be created"
  )

  # Clean up - remove the temporary output file
  unlink(tmp_outpath)
})
