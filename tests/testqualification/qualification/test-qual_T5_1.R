# Test Setup -------------------------------------------------------
ae_workflow_custom <- flatten(MakeWorkflowList("kri0001_custom", yaml_path_custom_metrics))
ae_workflow_default <- flatten(MakeWorkflowList("kri0001"))

# define Data ------------------------------------------------------
test_custom <- robust_runworkflow(ae_workflow_custom, mapped_data)
test_default <- robust_runworkflow(ae_workflow_default, mapped_data)

hardcode_flag_custom <- test_custom$Analysis_Flagged %>%
  mutate("hardcode_flag" = case_when(
    Score <= test_custom$vThreshold[1] |
      Score >= test_custom$vThreshold[4] ~ 2,
    Score > test_custom$vThreshold[1] & Score <= test_custom$vThreshold[2] |
      Score < test_custom$vThreshold[4] & Score >= test_custom$vThreshold[3] ~ 1,
    TRUE ~ 0
  ))

hardcode_flag_default <- test_default$Analysis_Flagged %>%
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
  expect_true(all(map_lgl(test_custom[outputs[!(outputs %in% c("vThreshold", "lAnalysis"))]], is.data.frame)))
  expect_equal(nrow(test_custom$Analysis_Flagged), nrow(test_custom$Analysis_Summary))
  expect_identical(sort(test_custom$Analysis_Flagged$GroupID), sort(test_custom$Analysis_Summary$GroupID))
  expect_identical(test_custom$Analysis_Flagged$Flag, test_custom$Analysis_Summary$Flag)
  expect_identical(abs(hardcode_flag_custom$Flag), hardcode_flag_custom$hardcode_flag)

  # default vThreshold
  expect_true(all(outputs %in% names(test_default)))
  expect_true(is.vector(test_default[["vThreshold"]]))
  expect_true(all(map_lgl(test_default[outputs[!(outputs %in% c("vThreshold", "lAnalysis"))]], is.data.frame)))
  expect_equal(nrow(test_default$Analysis_Flagged), nrow(test_default$Analysis_Summary))
  expect_identical(sort(test_default$Analysis_Flagged$GroupID), sort(test_default$Analysis_Summary$GroupID))
  expect_identical(test_default$Analysis_Flagged$Flag, test_default$Analysis_Summary$Flag)
  expect_identical(abs(hardcode_flag_default$Flag), hardcode_flag_default$hardcode_flag)
})
