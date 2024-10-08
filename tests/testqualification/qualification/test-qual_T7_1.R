## Test Setup
kri_workflows <- MakeWorkflowList(c("kri0003", "kri0004", "cou0003", "cou0004"))

outputs <- map(kri_workflows, ~ map_vec(.x$steps, ~ .x$output))

## Test Code
testthat::test_that("Given appropriate raw participant-level data, a Protocol Deviation Assessment can be done using the Normal Approximation method.", {
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
        all(map_lgl(kri[outputs[[kri_name]][!(outputs[[kri_name]] %in% c("vThreshold", "lAnalysis"))]], is.data.frame))
      })
    )
  )
  walk(test, ~ expect_true(is.vector(.x$vThreshold)))
  walk(test, ~ expect_equal(nrow(.x$Analysis_Flagged), nrow(.x$Analysis_Summary)))
  walk(test, ~ expect_identical(sort(.x$Analysis_Flagged$GroupID), sort(.x$Analysis_Summary$GroupID)))
})
