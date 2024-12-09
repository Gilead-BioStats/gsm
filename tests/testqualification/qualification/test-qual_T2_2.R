## Test Setup
kri_workflows <- flatten(MakeWorkflowList(strNames = "kri0001"))
mapped_data_missing_values <- get_data(kri_workflows, lData_missing_values)

outputs <- map_vec(kri_workflows$steps, ~ .x$output)


## Test Code
testthat::test_that("Given raw participant-level data with missingness,
                    a properly specified Workflow for a KRI creates summarized and flagged data", {
  test <- suppressWarnings(robust_runworkflow(kri_workflows, mapped_data_missing_values))
  a <- capture_warning(robust_runworkflow(kri_workflows, mapped_data_missing_values))[1]
  removed <- 3
  expected_rows <- length(na.omit(unique(test$Mapped_SUBJ[[kri_workflows$steps[[2]]$params$strGroupCol]]))) - removed

  # test output stucture
  expect_true(is.vector(test$vThreshold))
  expect_true(all(map_lgl(test[outputs[!(outputs %in% c("vThreshold", "lAnalysis"))]], is.data.frame)))
  expect_equal(nrow(test$Analysis_Flagged), expected_rows)
  expect_equal(nrow(test$Analysis_Summary), expected_rows)

  ## test
  expect_true(all(outputs %in% names(test)))
  expect_true(is.vector(test$vThreshold))
  expect_true(all(map_lgl(test[outputs[!(outputs %in% c("vThreshold", "lAnalysis"))]], is.data.frame)))
  expect_equal(nrow(test$Analysis_Flagged), nrow(test$Analysis_Summary))
  expect_identical(sort(test$Analysis_Flagged$GroupID), sort(test$Analysis_Summary$GroupID))
})
