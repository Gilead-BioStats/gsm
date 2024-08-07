# Test Setup -------------------------------------------------------
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

ae_workflow_custom <- flatten(MakeWorkflowList("kri0001_custom", yaml_path_custom))
ae_workflow_default <- flatten(MakeWorkflowList("kri0001"))

mapped_data <- get_data(ae_workflow_default, lData)

# define Data ------------------------------------------------------
test_custom <- robust_runworkflow(ae_workflow_custom, mapped_data)
test_default <- robust_runworkflow(ae_workflow_default, mapped_data)

hardcode_flag_custom <- test_custom$dfFlagged %>%
  mutate("hardcode_flag" = case_when(
    Score <= test_custom$vThreshold[1] |
      Score >= test_custom$vThreshold[4] ~ 2,
    Score > test_custom$vThreshold[1] & Score <= test_custom$vThreshold[2] |
      Score < test_custom$vThreshold[4] & Score >= test_custom$vThreshold[3] ~ 1,
    TRUE ~ 0
  ))

hardcode_flag_default <- test_default$dfFlagged %>%
  mutate("hardcode_flag" = case_when(
    Score <= test_default$vThreshold[1] |
      Score >= test_default$vThreshold[4] ~ 2,
    Score > test_default$vThreshold[1] & Score <= test_default$vThreshold[2] |
      Score < test_default$vThreshold[4] & Score >= test_default$vThreshold[3] ~ 1,
    TRUE ~ 0
  ))

## define outputs --------------------------------------------------
outputs <- map_vec(ae_workflow_custom$steps, ~ .x$output)

## Test Code -------------------------------------------------------
testthat::test_that("Given appropriate raw participant-level data, flag values can be correctly assigned to records that meet flagging criteria, including custom thresholding.", {
  # Custom vThreshold
  expect_true(all(outputs %in% names(test_custom)))
  expect_true(is.vector(test_custom[["vThreshold"]]))
  expect_true(all(map_lgl(test_custom[outputs[outputs != "vThreshold"]], is.data.frame)))
  expect_equal(nrow(test_custom$dfFlagged), nrow(test_custom$dfSummary))
  expect_identical(sort(test_custom$dfFlagged$GroupID), sort(test_custom$dfSummary$GroupID))
  expect_identical(test_custom$dfFlagged$Flag, test_custom$dfSummary$Flag)
  expect_identical(abs(hardcode_flag_custom$Flag), hardcode_flag_custom$hardcode_flag)

  # default vThreshold
  expect_true(all(outputs %in% names(test_default)))
  expect_true(is.vector(test_default[["vThreshold"]]))
  expect_true(all(map_lgl(test_default[outputs[outputs != "vThreshold"]], is.data.frame)))
  expect_equal(nrow(test_default$dfFlagged), nrow(test_default$dfSummary))
  expect_identical(sort(test_default$dfFlagged$GroupID), sort(test_default$dfSummary$GroupID))
  expect_identical(test_default$dfFlagged$Flag, test_default$dfSummary$Flag)
  expect_identical(abs(hardcode_flag_default$Flag), hardcode_flag_default$hardcode_flag)
})
