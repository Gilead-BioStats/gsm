# all workflow types
snapshot_all <- Make_Snapshot(lAssessments = MakeWorkflowList(strNames = c("kri0001", "qtl0004", "cou0006")))[[1]]

# qtls only
snapshot_qtl <- Make_Snapshot(lAssessments = MakeWorkflowList(strNames = c("qtl0004", "qtl0006")))[[1]]

# kris only
snapshot_kri <- Make_Snapshot(lAssessments = MakeWorkflowList(strNames = c("kri0005", "kri0006")))[[1]]

# countries only
snapshot_cou <- Make_Snapshot(lAssessments = MakeWorkflowList(strNames = c("cou0002", "cou0003")))[[1]]

test_that("output for all workflow types is created as expected", {
  check_all <- CheckSnapshotInputs(snapshot_all)
  expect_type(check_all, "list")
  expect_true(check_all$status_tables)
  expect_true(check_all$status_columns)
  expect_true(check_all$bStatus)
  expect_snapshot(map(check_all, function(x) names(x)))
})


test_that("output for qtl-only worklow is created as expected", {
  check_qtl <- CheckSnapshotInputs(snapshot_qtl)
  expect_type(check_qtl, "list")
  expect_true(check_qtl$status_tables)
  expect_true(check_qtl$status_columns)
  expect_true(check_qtl$bStatus)
  expect_snapshot(map(check_qtl, function(x) names(x)))
})

test_that("output for country-only worklow is created as expected", {
  check_cou <- CheckSnapshotInputs(snapshot_cou)
  expect_type(check_cou, "list")
  expect_true(check_cou$status_tables)
  expect_true(check_cou$status_columns)
  expect_true(check_cou$bStatus)
  expect_snapshot(map(check_cou, function(x) names(x)))
})

test_that("missing tables are caught", {
  snapshot_missing <- snapshot_all
  snapshot_missing$results_summary <- NULL
  check_missing <- CheckSnapshotInputs(snapshot_missing)

  expect_false(check_missing$bStatus)
  expect_false(check_missing$status_tables)
})

test_that("missing columns are caught", {
  columns_missing <- snapshot_all
  columns_missing$meta_param$index <- NULL

  check_missing_columns <- CheckSnapshotInputs(columns_missing)
  expect_false(check_missing_columns$bStatus)
  expect_false(check_missing_columns$status_columns)
})
