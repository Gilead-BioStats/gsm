## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

kri_workflows <- MakeWorkflowList(c(sprintf("kri%04d", 1:2), sprintf("cou%04d", 1:2)))
kri_custom <- MakeWorkflowList(c(sprintf("kri%04d_custom", 1:2), sprintf("cou%04d_custom", 1:2)), yaml_path_custom)

mapped_data <- get_data(kri_workflows, lData)

outputs <- map(kri_workflows, ~ map_vec(.x$steps, ~ .x$output))

## Test Code
testthat::test_that("Adverse Event Assessments can be done correctly using a grouping variable, such as Site or Country for KRIs, and Study for QTLs, when applicable.", {
  ## regular -----------------------------------------
  test <- map(kri_workflows, ~ robust_runworkflow(.x, mapped_data, steps = 1:3))

  # grouping col in yaml file is interpreted correctly in dfInput GroupID
  iwalk(test, ~ expect_identical(
    sort(unique(.x$dfInput$GroupID)),
    sort(unique(.x$dfEnrolled[[kri_workflows[[.y]]$steps[[2]]$params$strGroupCol]]))
  ))

  # data is properly transformed by correct group in dfTransformed
  iwalk(test, ~ expect_equal(
    n_distinct(.x$dfEnrolled[[kri_workflows[[.y]]$steps[[2]]$params$strGroupCol]]),
    nrow(.x$dfTransformed)
  ))

  ## custom -------------------------------------------
  test_custom <- map(kri_custom, ~ robust_runworkflow(.x, mapped_data, steps = 1:3))

  # grouping col in custom yaml file is interpreted correctly in dfInput GroupID
  iwalk(test_custom, ~ expect_identical(
    sort(unique(.x$dfInput$GroupID)),
    sort(unique(.x$dfEnrolled[[kri_custom[[.y]]$steps[[2]]$params$strGroupCol]]))
  ))

  # data is properly transformed by correct group in dfTransformed
  iwalk(test_custom, ~ expect_equal(
    n_distinct(.x$dfEnrolled[[kri_custom[[.y]]$steps[[2]]$params$strGroupCol]]),
    nrow(.x$dfTransformed)
  ))

  mapped_data$dfEnrolled %>% glimpse()

  ## custom edits -------------------------------------
  kri_custom2 <- map(kri_workflows, function(kri) {
    kri$steps[[2]]$params$strGroupCol <- "agerep"
    kri$steps[[2]]$params$strGroupLevel <- "Age"
    return(kri)
  })

  test_custom2 <- map(kri_custom2, ~ robust_runworkflow(.x, mapped_data, steps = 1:3))

  # grouping col in custom2 workflow is interpreted correctly in dfInput GroupID
  iwalk(test_custom2, ~ expect_identical(
    sort(unique(.x$dfInput$GroupID)),
    sort(unique(.x$dfEnrolled[[kri_custom2[[.y]]$steps[[2]]$params$strGroupCol]]))
  ))

  # data is properly transformed by correct group in dfTransformed
  iwalk(test_custom2, ~ expect_equal(
    n_distinct(.x$dfEnrolled[[kri_custom2[[.y]]$steps[[2]]$params$strGroupCol]]),
    nrow(.x$dfTransformed)
  ))
})
