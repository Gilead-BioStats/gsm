test_that("The utility function can correctly evaluate that the input data frame has or does not have the expected columns.", {


  ### Preliminary setup
  lMapping <- list(
    strIDCol = "subjid",
    strSiteCol = "siteid",
    strExposureCol = "timeontreatment"
  )

  lSpec <- list(
    vRequired = c("strIDCol", "strSiteCol", "strExposureCol"),
    vUniqueCols = "strIDCol"
  )


  ########### gsm mapping ###########
  observed_present <- gsm::is_mapping_valid(
    df = clindata::rawplus_dm,
    mapping = lMapping,
    spec = lSpec
  )

  observed_missing <- gsm::is_mapping_valid(
    df = clindata::rawplus_dm %>%
      select(-subjid),
    mapping = lMapping,
    spec = lSpec
  )


  ########### testing ###########
  # check that is_mapping_valid recognizes the expected columns in df (observed_present)
  expected_cols <- isTRUE(observed_present$tests_if$has_expected_columns$status)

  # check that is_mapping_valid recognizes when an expected column is missing from df (observed_missing)
  missing <- isFALSE(observed_missing$tests_if$has_expected_columns$status)

  all_tests <- isTRUE(expected_cols) & isTRUE(missing)
  expect_true(all_tests)

})
