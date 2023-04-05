test_that("The utility function can correctly evaluate that the input mapping(s) have or do not have all required parameters.", {
  ### Preliminary setup
  df <- clindata::rawplus_dm

  lSpec <- list(
    vRequired = c("strIDCol", "strSiteCol", "strExposureCol"),
    vUniqueCols = "strIDCol"
  )


  ########### gsm mapping ###########
  observed_present <- gsm::is_mapping_valid(
    df = df,
    mapping = list(
      strIDCol = "subjid",
      strSiteCol = "siteid",
      strExposureCol = "timeontreatment"
    ),
    spec = lSpec
  )

  observed_missing <- gsm::is_mapping_valid(
    df = df,
    mapping = list(
      strIDCol = "subjid",
      strExposureCol = "timeontreatment"
    ),
    spec = lSpec
  )


  ########### testing ###########
  # check that is_mapping_valid recognizes that mapping contains every required parameter from vRequired (observed_present)
  are_present <- isTRUE(observed_present$tests_if$has_required_params$status)

  # check that is_mapping_valid recognizes that mapping does not contain every required parameter from vRequired (observed_missing)
  are_missing <- isFALSE(observed_missing$tests_if$has_required_params$status)

  all_tests <- isTRUE(are_present) & isTRUE(are_missing)
  expect_true(all_tests)
})
