## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

kri_workflows <- MakeWorkflowList(c(sprintf("kri%04d", 1:2), sprintf("cou%04d", 1:2)))
kri_custom <- MakeWorkflowList(c(sprintf("kri%04d_custom", 1:2), sprintf("cou%04d_custom", 1:2)), yaml_path_custom)

mapped_data <- get_data(kri_workflows, lData)

outputs <- map(kri_workflows, ~ map_vec(.x$steps, ~ .x$output))

## Test Code
testthat::test_that("Given appropriate raw participant-level data, an Adverse Event Assessment can be done using the Normal Approximation method.
", {
  # default
  test <- map(kri_workflows, ~ robust_runworkflow(.x, mapped_data))

  expect_true(
    all(
      imap_lgl(outputs, function(names, kri) {
        all(names %in% names(test[[kri]]))
      })
    )
  )
  expect_true(
    all(
      imap_lgl(test, function(kri, kri_name) {
        all(map_lgl(kri[outputs[[kri_name]][outputs[[kri_name]] != "vThreshold"]], is.data.frame))
      })
    )
  )
  walk(test, ~ expect_true(is.vector(.x$vThreshold)))
  walk(test, ~ expect_equal(nrow(.x$dfFlagged), nrow(.x$dfSummary)))
  walk(test, ~ expect_identical(sort(.x$dfFlagged$GroupID), sort(.x$dfSummary$GroupID)))

  # custom
  test_custom <- map(kri_workflows, ~ robust_runworkflow(.x, mapped_data))

  expect_true(
    all(
      imap_lgl(outputs, function(names, kri) {
        all(names %in% names(test_custom[[kri]]))
      })
    )
  )
  expect_true(
    all(
      imap_lgl(test_custom, function(kri, kri_name) {
        all(map_lgl(kri[outputs[[kri_name]][outputs[[kri_name]] != "vThreshold"]], is.data.frame))
      })
    )
  )
  walk(test_custom, ~ expect_true(is.vector(.x$vThreshold)))
  walk(test_custom, ~ expect_equal(nrow(.x$dfFlagged), nrow(.x$dfSummary)))
  walk(test_custom, ~ expect_identical(sort(.x$dfFlagged$GroupID), sort(.x$dfSummary$GroupID)))
})
