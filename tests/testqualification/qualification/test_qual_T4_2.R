# Test Setup -------------------------------------------------------
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))
mapping_workflow <- flatten(MakeWorkflowList("mapping", yaml_path))
mapped_data_reg <- run_possible_mappings(mapping_workflow, lData)$lData
ae_workflow <- flatten(MakeWorkflowList("kri0001_custom_thresholds", yaml_path))

# define dfBounds --------------------------------------------------
steps <- seq(which(map_lgl(ae_workflow$steps, ~str_detect(.x$output, "dfBounds"))))
dfBounds <- robust_runworkflow(ae_workflow, mapped_data_reg, steps)$lData$dfBounds

## define outputs --------------------------------------------------
outputs <- map_vec(ae_workflow$steps[steps], ~.x$output)

## Test Code -------------------------------------------------------
testthat::test_that("Given appropriate metadata (i.e. vThresholds), data.frame of bounds can be created", {
  expect_no_error(robust_runworkflow(ae_workflow, mapped_data_reg, steps)$lData$dfBounds)
  expect_true(all(outputs %in% names(test$lData)))
  expect_true(all(map_lgl(test$lData[outputs], is.data.frame)))
  expect_true(all(unique(dfBounds$Threshold) %in% c(ae_workflow$meta$vThreshold, 0)))
})
