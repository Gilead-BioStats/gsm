test_that("Uses default study labels when lStudyLabels is NULL", {
  lStudy <- make_test_lStudy()
  output <- Report_StudyInfo(lStudy, NULL)
  expect_s3_class(output, "shiny.tag.list")
  expect_true(any(grepl("Study Status", output)))
  expect_true(any(grepl("Show Details", output)))
  expect_true(any(grepl("Unique Study ID", output)))
})

test_that("Uses custom study labels when lStudyLabels is provided", {
  lStudy <- make_test_lStudy()
  lStudyLabels <- list(
    StudyID = "Custom Study ID",
    protocol_title = "Custom Protocol Title"
  )
  output <- Report_StudyInfo(lStudy, lStudyLabels)
  expect_s3_class(output, "shiny.tag.list")
  expect_true(any(grepl("Study Status", output)))
  expect_true(any(grepl("Show Details", output)))
  expect_true(any(grepl("Custom Study ID", output)))
  expect_true(any(grepl("Custom Protocol Title", output)))
})

test_that("Generated table has correct structure and content", {
  lStudy <- make_test_lStudy()
  output <- Report_StudyInfo(lStudy, NULL)
  expect_s3_class(output, "shiny.tag.list")
  expect_true(any(grepl("study_table", output)))
  expect_true(any(grepl("study_table_hide", output)))
  expect_true(any(grepl("<label class=\"toggle\">", output)))
  expect_true(any(grepl("<div class=\"toggle-switch\">", output)))
  expect_true(any(grepl("Show Details", output)))
  expect_snapshot({
    output
  })
})

test_that("Works with dfGroups", {
  output <- Report_StudyInfo(gsm::reportingGroups, NULL)
  expect_s3_class(output, "shiny.tag.list")
  expect_true(any(grepl("Study Status", output)))
  expect_true(any(grepl("Show Details", output)))
  expect_true(any(grepl("Therapeutic Area", output)))
})

test_that("Uses custom study labels when lStudyLabels is provided w/ dfGroups", {
  lStudyLabels <- list(
    protocol_title = "Custom Protocol Title"
  )
  output <- Report_StudyInfo(gsm::reportingGroups, lStudyLabels)
  expect_s3_class(output, "shiny.tag.list")
  expect_true(any(grepl("Study Status", output)))
  expect_true(any(grepl("Show Details", output)))
  expect_true(any(grepl("Custom Protocol Title", output)))
})

test_that("Generated table has correct structure and content w/dfGroups", {
  output <- Report_StudyInfo(gsm::reportingGroups, NULL)
  expect_s3_class(output, "shiny.tag.list")
  expect_true(any(grepl("study_table", output)))
  expect_true(any(grepl("study_table_hide", output)))
  expect_true(any(grepl("<label class=\"toggle\">", output)))
  expect_true(any(grepl("<div class=\"toggle-switch\">", output)))
  expect_true(any(grepl("Show Details", output)))
  expect_snapshot({
    output
  })
})
