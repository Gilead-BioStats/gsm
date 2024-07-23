# Test Setup -------------------------------------------------------
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))
mapping_workflow <- flatten(MakeWorkflowList("mapping", yaml_path_original))
ae_workflow <- flatten(MakeWorkflowList("kri0001_custom", yaml_path_custom))
mapped_data <- get_data(ae_workflow, lData)

# define dfBounds --------------------------------------------------
steps <- seq(which(map_lgl(ae_workflow$steps, ~str_detect(.x$output, "dfBounds"))))
dfBounds <- robust_runworkflow(ae_workflow, mapped_data, steps)$lData$dfBounds

## define outputs --------------------------------------------------
outputs <- map_vec(ae_workflow$steps[steps], ~.x$output)

## Test Code -------------------------------------------------------
testthat::test_that("Given appropriate metadata (i.e. vThresholds), data.frame of bounds can be created", {
  expect_no_error(robust_runworkflow(ae_workflow, mapped_data, steps)$lData$dfBounds)
  expect_true(all(outputs %in% names(test$lData)))
  expect_true(is.vector(test$lData[["vThreshold"]]))
  expect_true(all(map_lgl(test$lData[outputs[outputs != "vThreshold"]], is.data.frame)))
  expect_true(all(unique(dfBounds$Threshold) %in% c(ae_workflow$meta$vThreshold, 0)))

})
