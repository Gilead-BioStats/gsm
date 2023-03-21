test_that("The utility function can correctly evaluate that the input data is or is not a data frame.", {
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
  observed_is_df <- gsm::is_mapping_valid(
    df = clindata::rawplus_dm,
    mapping = lMapping,
    spec = lSpec
  )

  observed_is_not_df <- gsm::is_mapping_valid(
    df = c("this", "is", "not", "a", "data frame"),
    mapping = lMapping,
    spec = lSpec
  )


  ########### testing ###########
  # check that is_mapping_valid recognizes df as a data frame (observed_is_df)
  is_df <- isTRUE(observed_is_df$tests_if$is_data_frame$status)

  # check that is_mapping_valid recognizes that df is not a dataframe (observed_is_not_df)
  is_not_df <- isFALSE(observed_is_not_df$tests_if$is_data_frame$status)

  all_tests <- isTRUE(is_df) & isTRUE(is_not_df)
  expect_true(all_tests)
})
