## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

kri_workflows <- flatten(MakeWorkflowList(strNames = "kri0001"))

mapped_data <- get_data(kri_workflows, lData)

outputs <- map_vec(kri_workflows$steps, ~ .x$output)

## Test Code
testthat::test_that("Given raw participant-level data, a properly specified Workflow for a KRI creates summarized and flagged data", {
  test <- robust_runworkflow(kri_workflows, mapped_data)
  expected_rows <- length(na.omit(unique(test$dfEnrolled[[kri_workflows$steps[[2]]$params$strGroupCol]])))

  # test output stucture
  expect_true(is.vector(test$vThreshold))
  expect_true(all(map_lgl(test[outputs[outputs != "vThreshold"]], is.data.frame)))
  expect_equal(nrow(test$dfFlagged), expected_rows)
  expect_equal(nrow(test$dfSummary), expected_rows)

  # test output content
  expect_true(all(outputs %in% names(test)))
  flags <- test$dfFlagged %>%
    mutate(hardcode_flag = case_when(
      Score <= test$vThreshold[1] ~ -2,
      Score > test$vThreshold[1] & Score <= test$vThreshold[2] ~ -1,
      Score >= test$vThreshold[3] & Score < test$vThreshold[4] ~ 1,
      Score >= test$vThreshold[4] ~ 2,
      TRUE ~ 0
    )) %>%
    left_join(test$dfSummary %>%
      select("GroupID", "Flag"), by = "GroupID")

  expect_identical(flags$hardcode_flag, flags$Flag.x)
  expect_identical(flags$hardcode_flag, flags$Flag.y)
})
