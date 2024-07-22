# Test Setup -------------------------------------------------------
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))
mapping_workflow <- flatten(MakeWorkflowList("mapping", yaml_path_original))
mapped_data_reg <- run_possible_mappings(mapping_workflow, lData)$lData
ae_workflow_custom <- flatten(MakeWorkflowList("kri0001_custom", yaml_path_custom))
ae_workflow_default <- flatten(MakeWorkflowList("kri0001", yaml_path_original))

vThreshold <- c(-4, -2, 2, 4)
ae_workflow_custom$meta$vThreshold <- vThreshold

# define Data ------------------------------------------------------
test_custom <- robust_runworkflow(ae_workflow_custom, mapped_data_reg)
test_default <- robust_runworkflow(ae_workflow_default, mapped_data_reg)

hardcode_flag_custom <- test_custom$lData$dfFlagged %>%
  mutate('hardcode_flag' = case_when(Score <= vThreshold[1] |
                                       Score >= vThreshold[4] ~ 2,
                                     Score > vThreshold[1] & Score <= vThreshold[2] |
                                       Score < vThreshold[4] & Score >= vThreshold[3] ~ 1,
                                     TRUE ~ 0))

hardcode_flag_default <- test_default$lData$dfFlagged %>%
  mutate('hardcode_flag' = case_when(Score <= ae_workflow_default$meta$vThreshold[1] |
                                       Score >= ae_workflow_default$meta$vThreshold[4] ~ 2,
                                     Score > ae_workflow_default$meta$vThreshold[1] & Score <= ae_workflow_default$meta$vThreshold[2] |
                                       Score < ae_workflow_default$meta$vThreshold[4] & Score >= ae_workflow_default$meta$vThreshold[3] ~ 1,
                                     TRUE ~ 0))

## define outputs --------------------------------------------------
outputs <- map_vec(ae_workflow_custom$steps, ~.x$output)

## Test Code -------------------------------------------------------
testthat::test_that("Given appropriate raw participant-level data, flag values can be correctly assigned to records that meet flagging criteria, including custom thresholding.", {
  # Custom vThreshold
  expect_true(all(outputs %in% names(test_custom$lData)))
  expect_true(all(map_lgl(test_custom$lData[outputs], is.data.frame)))
  expect_equal(nrow(test_custom$lData$dfFlagged), nrow(test_custom$lData$dfSummary))
  expect_identical(sort(test_custom$lData$dfFlagged$GroupID), sort(test_custom$lData$dfSummary$GroupID))
  expect_true(all(unique(test_custom$lData$dfBounds$Threshold) %in% c(vThreshold, 0)))
  expect_identical(test_custom$lData$dfFlagged$Flag, test_custom$lData$dfSummary$Flag)
  expect_identical(abs(hardcode_flag_custom$Flag), hardcode_flag_custom$hardcode_flag)

  # default vThreshold
  expect_true(all(outputs %in% names(test_default$lData)))
  expect_true(all(map_lgl(test_default$lData[outputs], is.data.frame)))
  expect_equal(nrow(test_default$lData$dfFlagged), nrow(test_default$lData$dfSummary))
  expect_identical(sort(test_default$lData$dfFlagged$GroupID), sort(test_default$lData$dfSummary$GroupID))
  expect_true(all(unique(test_default$lData$dfBounds$Threshold) %in% c(ae_workflow_default$meta$vThreshold, 0)))
  expect_identical(test_default$lData$dfFlagged$Flag, test_default$lData$dfSummary$Flag)
  expect_identical(abs(hardcode_flag_default$Flag), hardcode_flag_default$hardcode_flag)
})
