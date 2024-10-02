## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

kri_workflows <- MakeWorkflowList(c(sprintf("kri%04d", 8:9), sprintf("cou%04d", 8:9)))
kri_custom <- MakeWorkflowList(c(sprintf("kri%04d_custom", 8:9), sprintf("cou%04d_custom", 8:9)), yaml_path_custom_metrics)

#mapped_data <- get_data(mappings_wf, lData)
mapped_data <- RunWorkflows(mappings_wf, lData)

## Test Code
testthat::test_that("Query Rate Assessments can be done correctly using a grouping variable, such as Site, Country, or Study, when applicable.", {
  ## regular -----------------------------------------
  test <- map(kri_workflows, ~ robust_runworkflow(.x, mapped_data, steps = 1:3))

  # grouping col in yaml file is interpreted correctly in dfInput GroupID
  iwalk(test, ~ expect_identical(
    sort(unique(.x$Analysis_Input$GroupID)),
    sort(unique(.x$dfEnrolled[[kri_workflows[[.y]]$steps[[2]]$params$strGroupCol]]))
  ))

  # data is properly transformed by correct group in dfTransformed
  iwalk(test, ~ expect_equal(
    n_distinct(.x$dfEnrolled[[kri_workflows[[.y]]$steps[[2]]$params$strGroupCol]]),
    nrow(.x$Analysis_Transformed)
  ))

  ## custom -------------------------------------------
  test_custom <- map(kri_custom, ~ robust_runworkflow(.x, mapped_data, steps = 1:3))

  # grouping col in custom yaml file is interpreted correctly in dfInput GroupID
  iwalk(test_custom, ~ expect_identical(
    sort(unique(.x$Analysis_Input$GroupID)),
    sort(unique(.x$dfEnrolled[[kri_custom[[.y]]$steps[[2]]$params$strGroupCol]]))
  ))

  # data is properly transformed by correct group in dfTransformed
  iwalk(test_custom, ~ expect_equal(
    n_distinct(.x$dfEnrolled[[kri_custom[[.y]]$steps[[2]]$params$strGroupCol]]),
    nrow(.x$Analysis_Transformed)
  ))
})
