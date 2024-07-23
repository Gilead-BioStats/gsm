## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

kri_workflows <- MakeWorkflowList(c('kri0003', 'kri0004', 'cou0003', 'cou0004'))
mapped_data <- get_data(kri_workflows, lData)

outputs <- map(kri_workflows, ~map_vec(.x$steps, ~.x$output))

## Test Code
testthat::test_that("Given appropriate raw participant-level data, a Protocol Deviation Assessment can be done using the Normal Approximation method.", {
  test <- map(kri_workflows, ~robust_runworkflow(.x, mapped_data))
  expect_true(
    all(
      imap_lgl(outputs, function(names, kri){
        all(names %in% names(test[[kri]]$lData))
      })
    )
  )
  expect_true(
    all(
      imap_lgl(test, function(kri, kri_name){
        all(map_lgl(kri$lData[outputs[[kri_name]][outputs[[kri_name]] != "vThreshold"]], is.data.frame))
      })
    )
  )
  walk(test, ~expect_true(is.vector(.x$lData$vThreshold)))
  walk(test, ~expect_equal(nrow(.x$lData$dfFlagged), nrow(.x$lData$dfSummary)))
  walk(test, ~expect_identical(sort(.x$lData$dfFlagged$GroupID), sort(.x$lData$dfSummary$GroupID)))

})
