# Install and load the `testthat` package --------------------------------------
source(testthat::test_path("testdata/data.R"))
# Setup Testing Data -----------------------------------------------------------
snap <- Make_Snapshot(lData = lData)
setup <- MakeReportSetup(assessment = snap$lStudyAssessResults, dfSite = snap$lSnapshot$rpt_site_details, strType = "kri")

# AssessStatus -----------------------------------------------------------------
test_that("Testing util-ReporHelpers - AssessStatus():", {
  # subset data
  AssessStatus_data <- snap$lStudyAssessResults[c("kri0001", "kri0002", "cou0001", "cou0002", "qtl0004", "qtl0006")]

  # make some status false
  for (i in names(AssessStatus_data[c(1, 3, 5)])) {
    AssessStatus_data[[i]]$bActive <- FALSE
  }

  # KRI test
  kri_test <- AssessStatus(AssessStatus_data, strType = "kri")

  expect_true(all(names(kri_test) == c("active", "dropped")))
  expect_true(names(kri_test$active) == "kri0002")
  expect_true(names(kri_test$dropped) == "kri0001")
  expect_false(any(!grepl("kri", names(kri_test$active))) & any(!grepl("kri", names(kri_test$dropped))))

  # COU test
  cou_test <- AssessStatus(AssessStatus_data, strType = "cou")

  expect_true(all(names(cou_test) == c("active", "dropped")))
  expect_true(names(cou_test$active) == "cou0002")
  expect_true(names(cou_test$dropped) == "cou0001")
  expect_false(any(!grepl("cou", names(cou_test$active))) & any(!grepl("cou", names(cou_test$dropped))))

  # QTL test
  qtl_test <- AssessStatus(AssessStatus_data, strType = "qtl")

  expect_true(all(names(qtl_test) == c("active", "dropped")))
  expect_true(names(qtl_test$active) == "qtl0006")
  expect_true(names(qtl_test$dropped) == "qtl0004")
  expect_false(any(!grepl("qtl", names(qtl_test$active))) & any(!grepl("qtl", names(qtl_test$dropped))))
})

# MakeReportSetup --------------------------------------------------------------
test_that("Testing util-ReporHelpers - MakeReportSetup():", {
  expect_true(all(names(setup) %in% c(
    "active", "dropped", "overview_table", "overview_raw_table", "red_kris",
    "amber_kris", "summary_table", "dropped_summary_table", "study_id"
  )))
  expect_true(all(map_lgl(setup[c("active", "dropped", "overview_table", "summary_table", "dropped_summary_table")], is.list)))
  expect_true(is.data.frame(setup$overview_raw_table))
  expect_true(all(map_lgl(setup[c("red_kris", "amber_kris")], is.integer)))
  expect_true(is.character(setup$study_id))
})

# MakeStudyStatusTable ---------------------------------------------------------
test_that("Testing util-ReporHelpers - MakeStudyStatusTable():", {
  expect_no_error(capture.output(status_table <- MakeStudyStatusTable(snap$lSnapshot$rpt_study_details, setup$overview_raw_table), file = nullfile()))
  expect_true(is.list(status_table))
})

# MakeSummaryTable -------------------------------------------------------------
test_that("Testing util-ReporHelpers - MakeSummaryTable:", {
  test <- MakeSummaryTable(snap$lStudyAssessResults, snap$lSnapshot$rpt_site_details)
  expect_equal(names(test), names(snap$lStudyAssessResults))
})

# MakeKRIGlossary --------------------------------------------------------------
test_that("Testing util-ReporHelpers - MakeKRIGlossary():", {
  kri_glossary <- MakeKRIGlossary(strWorkflowIDs = names(snap$lStudyAssessResults))
  expect_true(is.list(kri_glossary))
  expect_true(
    all(names(kri_glossary) %in% c(
      "x", "width", "height", "sizingPolicy", "dependencies",
      "elementId", "preRenderHook", "jsHooks"
    ))
  )
})

# GetSnapshotDate --------------------------------------------------------------
test_that("Testing util-ReporHelpers - GetSnapshotDate():", {
  expect_equal(snap$lSnapshotDate, GetSnapshotDate(snap$lSnapshot$rpt_study_details)$snapshot_date)
})

# MakeErrorLog -----------------------------------------------------------------
test_that("Testing util-ReporHelpers - MakeErrorLog():", {
  error_log <- MakeErrorLog(snap$lStudyAssessResults)
  expect_true(is.list(error_log))
  expect_true(
    all(names(error_log) %in% c(
      "x", "width", "height", "sizingPolicy", "dependencies",
      "elementId", "preRenderHook", "jsHooks"
    ))
  )
})

# qtl_summary ------------------------------------------------------------------
test_that("Testing util-ReporHelpers - qtl_summary():", {
  qtl_sum <- qtl_summary(snap$lStudyAssessResults)
  expect_equal(
    names(qtl_sum), c("workflowid", "GroupID", "Numerator", "Denominator", "Metric", "Score", "Flag")
  )
})

# qtl_analysis -----------------------------------------------------------------
test_that("Testing util-ReporHelpers - qtl_analysis():", {
  qtl_an <- qtl_analysis(snap$lStudyAssessResults, qtl_summary(snap$lStudyAssessResults))
  expect_true(is.data.frame(qtl_an))
  expect_equal(
    names(qtl_an),
    c(
      "Workflowid", "GroupID", "Numerator", "Denominator", "Metric",
      "OverallMetric", "Factor", "Score", "Method", "ConfLevel",
      "Estimate", "LowCI", "UpCI", "Flag"
    )
  )
})
