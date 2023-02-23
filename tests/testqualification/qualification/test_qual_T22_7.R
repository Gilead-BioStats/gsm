test_that("The utility function can correctly evaluate if NA values are or are not acceptable in given columns depending on the vNACols component of the input parameter specifications.", {


  ### Preliminary setup
  df <- clindata::rawplus_dm

  lMapping <- list(
    strIDCol = "subjid",
    strSiteCol = "siteid",
    strExposureCol = "timeontreatment"
  )


  ########### gsm mapping ###########
  df1 <- df
  df1$subjid[1] <- NA
  observed_na_acceptable <- gsm::is_mapping_valid(
    df = df1,
    mapping = lMapping,
    spec = list(
      vRequired = c("strIDCol", "strSiteCol", "strExposureCol"),
      vUniqueCols = "strIDCol",
      vNACols = "strIDCol"
    )
  )

  df2 <- df
  df2$subjid[1] <- NA
  observed_na_not_acceptable <- gsm::is_mapping_valid(
    df = df2,
    mapping = lMapping,
    spec = list(
      vRequired = c("strIDCol", "strSiteCol", "strExposureCol"),
      vUniqueCols = "strIDCol"
    )
  )


  ########### testing ###########
  # check that is_mapping_valid recognizes that NAs are allowed in subjid (observed_na_acceptable)
  na_acceptable <- isTRUE(observed_na_acceptable$tests_if$columns_have_na$status)

  # check that is_mapping_valid recognizes that NAs are not allowed in subjid (observed_na_not_acceptable)
  na_not_acceptable <- isFALSE(observed_na_not_acceptable$tests_if$columns_have_na$status)

  all_tests <- isTRUE(na_acceptable) & isTRUE(na_not_acceptable)
  expect_true(all_tests)

})
