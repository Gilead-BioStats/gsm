## Test Setup
kri_workflows <- flatten(MakeWorkflowList("kri0001_custom", yaml_path_custom_metrics))
outputs <- map_vec(kri_workflows$steps, ~ .x$output)

## Test Code
testthat::test_that("Given appropriate metadata (i.e. vThresholds), flagged observations are properly marked in summary data", {
  test <- robust_runworkflow(kri_workflows, mapped_data)
  expect_true(all(outputs %in% names(test)))
  expect_true(is.vector(test[["vThreshold"]]))
  expect_true(all(map_lgl(test[outputs[!(outputs %in% c("vThreshold", "lAnalysis"))]], is.data.frame)))
  expect_equal(nrow(test$Analysis_Flagged), nrow(test$Analysis_Summary))
  expect_identical(sort(test$Analysis_Flagged$GroupID), sort(test$Analysis_Summary$GroupID))

  flags <- test$Analysis_Summary %>%
    mutate(flagged_hardcode = case_when(
      Score <= test$vThreshold[1] |
        Score >= test$vThreshold[4] ~ 2,
      (Score <= test$vThreshold[2] & Score > test$vThreshold[1]) |
        (Score >= test$vThreshold[3] & Score < test$vThreshold[4]) ~ 1,
      TRUE ~ 0
    ))

  expect_identical(abs(flags$Flag), flags$flagged_hardcode)
  expect_identical(test$Analysis_Flagged$Flag, test$Analysis_Summary$Flag)
})
