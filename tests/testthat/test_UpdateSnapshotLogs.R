# Install and load the `testthat` package
source(testthat::test_path("testdata/data.R"))

test_that("UpdateSnapshotLogs outputs tables as intended", {
  prev_snap <- readRDS(system.file("data-longitudinal", "v1_8_snapshot.rds", package = "clindata"))
  updated_logs <- UpdateSnapshotLogs(prev_snap)

  new_tables <- c( "rpt_site_details",
                   "rpt_study_details",
                   "rpt_qtl_details",
                   "rpt_kri_details",
                   "rpt_site_kri_details",
                   "rpt_kri_bounds_details",
                   "rpt_qtl_threshold_param",
                   "rpt_kri_threshold_param",
                   "rpt_qtl_analysis" )

  expect_true(all(new_tables %in% names(updated_logs$lSnapshot)))
})


