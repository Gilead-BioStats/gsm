## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))
mapping_workflow <- flatten(MakeWorkflowList("mapping", yaml_path_original))
mapped_data_reg <- run_possible_mappings(mapping_workflow, lData)$lData
ae_workflow <- flatten(MakeWorkflowList("kri0001_custom", yaml_path_custom))
outputs <- map_vec(ae_workflow$steps, ~.x$output)
## Test Code
testthat::test_that("Given appropriate metadata (i.e. vThresholds), flagged observations are properly marked in summary data", {
  test <- robust_runworkflow(ae_workflow, mapped_data_reg)
  expect_true(all(outputs %in% names(test$lData)))
  expect_true(all(map_lgl(test$lData[outputs], is.data.frame)))
  expect_equal(nrow(test$lData$dfFlagged), nrow(test$lData$dfSummary))
  expect_identical(sort(test$lData$dfFlagged$GroupID), sort(test$lData$dfSummary$GroupID))

  flags <- test$lData$dfSummary %>%
    mutate(flagged_hardcode = case_when(Score <= ae_workflow$meta$vThreshold[1] |
                                           Score >= ae_workflow$meta$vThreshold[4] ~ 2,
                                         (Score <= ae_workflow$meta$vThreshold[2] & Score > ae_workflow$meta$vThreshold[1]) |
                                           (Score >= ae_workflow$meta$vThreshold[3] & Score < ae_workflow$meta$vThreshold[4]) ~ 1,
                                         TRUE ~ 0)
           )

  expect_identical(flags$Flag, flags$flagged_hardcode)
  expect_identical(test$lData$dfFlagged$Flag, test$lData$dfSummary$Flag)
})
