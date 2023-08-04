study <- Study_Assess()
status_workflow <- MakeStatusWorkflow(
  lResults = study,
  dfConfigWorkflow = gsm::config_workflow
)
test_that("status_workflow is created as expected", {
  expect_equal(
    class(status_workflow),
    "data.frame"
    )

  expect_snapshot(names(status_workflow))
})


test_that("correct bStatus is captured", {
  # manually make kri0001 and kri0002 bStatus == FALSE
  study_fail <- study
  study_fail$kri0001$bStatus <- FALSE
  study_fail$kri0002$bStatus <- FALSE

  status_workflow_with_failures <- MakeStatusWorkflow(
    lResults = study_fail,
    dfConfigWorkflow = gsm::config_workflow
  )

  # extract the `status` column as a character vector for the failed KRIs
  fails <- status_workflow_with_failures %>%
    filter(
      workflowid %in% c("kri0001", "kri0002")
    ) %>%
    pull(status)

  expect_false(all(fails))

})
