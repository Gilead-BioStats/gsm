lResults <- Study_Assess()

test_that("results_bounds is created as intended", {

  results_bounds <- MakeResultsBounds(
    lResults = lResults,
    dfConfigWorkflow = gsm::config_workflow
  )

  expect_equal(class(results_bounds), "data.frame")
  expect_snapshot(names(results_bounds))

})
