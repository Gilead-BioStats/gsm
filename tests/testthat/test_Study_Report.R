# Install and load the `testthat` package
source(testthat::test_path("testdata/data.R"))

# Write tests for Study_Report function
test_that("Study_Report function works as expected", {
  snapshot <- Make_Snapshot(lData = lData)
  part_snap <- snapshot[c("lSnapshots", "lCharts", "lInputs")]

  # Create temporary output file path
  # tmp_outpath <- tempfile(fileext = ".html")

  # Test the function with different report types
  expect_error(
    Study_Report(snapshot, strReportType = "person")
  )

  expect_error(
    Study_Report(snapshot, strReportType = c("site", "QTL"))
  )

  expect_error(
    expect_message(
      Study_Report(part_snap)
    )
  )

})

