lStudy <- list(
  # Are these variable names standardized?
  StudyID = "Unique Study ID",
  protocol_title = "Study Title",
  nickname = "Nickname",
  enrolled_sites = 10,
  planned_sites = 15,
  enrolled_participants = 100,
  planned_participants = 200,
  status = "Ongoing",
  product = "Product Name",
  phase = "Phase 1",
  therapeutic_area = "Therapeutic Area",
  protocol_indication = "Indication",
  protocol_type = "Type",
  protocol_row_id = 123,
  protocol_product_number = 456,
  est_fpfv = "2023-01-01",
  est_lpfv = "2023-12-01",
  est_lplv = "2024-01-01"
)

# Custom study labels
lStudyLabels <- list(
  StudyID = "Custom Study ID",
  protocol_title = "Custom Protocol Title"
)

test_that("Uses default study labels when lStudyLabels is NULL", {
  output <- capture.output(Report_StudyInfo(lStudy, NULL))
  expect_true(any(grepl("Study Status", output)))
  expect_true(any(grepl("Show Details", output)))
  expect_true(any(grepl("Unique Study ID", output)))
})

test_that("Uses custom study labels when lStudyLabels is provided", {
  output <- capture.output(Report_StudyInfo(lStudy, lStudyLabels))
  expect_true(any(grepl("Study Status", output)))
  expect_true(any(grepl("Show Details", output)))
  expect_true(any(grepl("Custom Study ID", output)))
  expect_true(any(grepl("Custom Protocol Title", output)))
})

test_that("Generated table has correct structure and content", {
  output <- capture.output(Report_StudyInfo(lStudy, NULL))
  expect_true(any(grepl("study_table", output)))
  expect_true(any(grepl("study_table_hide", output)))
  expect_true(any(grepl("<label class=\"toggle\">", output)))
  expect_true(any(grepl("<div class=\"toggle-switch\">", output)))
  expect_true(any(grepl("Show Details", output)))
})
