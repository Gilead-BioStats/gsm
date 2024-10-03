## Test Setup
kri_workflows <- MakeWorkflowList(c("kri0011", "cou0011"))
kri_custom <- MakeWorkflowList(c("kri0011_custom", "cou0011_custom"), yaml_path_custom_metrics)

## Test Code
testthat::test_that("Data Change Rate Assessments can be done correctly using a grouping variable, such as Site, Country, or Study, when applicable.", {
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
