## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

kri_workflows <- flatten(MakeWorkflowList("kri0001_custom", yaml_path_custom))

mapped_data <- get_data(kri_workflows, lData)

outputs <- map_vec(kri_workflows$steps, ~ .x$output)

## Test Code
testthat::test_that("Given appropriate metadata (i.e. vThresholds), flagged observations are properly marked in summary data", {
  test <- robust_runworkflow(kri_workflows, mapped_data)
  expect_true(all(outputs %in% names(test)))
  expect_true(is.vector(test[["vThreshold"]]))
  expect_true(all(map_lgl(test[outputs[outputs != "vThreshold"]], is.data.frame)))
  expect_equal(nrow(test$dfFlagged), nrow(test$dfSummary))
  expect_identical(sort(test$dfFlagged$GroupID), sort(test$dfSummary$GroupID))

  flags <- test$dfSummary %>%
    mutate(flagged_hardcode = case_when(
      Score <= test$vThreshold[1] |
        Score >= test$vThreshold[4] ~ 2,
      (Score <= test$vThreshold[2] & Score > test$vThreshold[1]) |
        (Score >= test$vThreshold[3] & Score < test$vThreshold[4]) ~ 1,
      TRUE ~ 0
    ))

  expect_identical(abs(flags$Flag), flags$flagged_hardcode)
  expect_identical(test$dfFlagged$Flag, test$dfSummary$Flag)
})
