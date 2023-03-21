test_that("The utility function can correctly evaluate if duplicate values are or are not acceptable in given columns depending on the vUniqueCols component of the input parameter specifications.", {
  ### Preliminary setup
  df <- clindata::rawplus_dm

  lMapping <- list(
    strIDCol = "subjid",
    strSiteCol = "siteid",
    strExposureCol = "timeontreatment"
  )


  ########### gsm mapping ###########
  df1 <- df
  df1$subjid[1] <- "1350"
  observed_dup_acceptable <- gsm::is_mapping_valid(
    df = df1,
    mapping = lMapping,
    spec = list(
      vRequired = c("strIDCol", "strSiteCol", "strExposureCol")
    )
  )

  df2 <- df
  df2$subjid[1] <- "1350"
  observed_dup_not_acceptable <- gsm::is_mapping_valid(
    df = df2,
    mapping = lMapping,
    spec = list(
      vRequired = c("strIDCol", "strSiteCol", "strExposureCol"),
      vUniqueCols = "strIDCol"
    )
  )


  ########### testing ###########
  # check that is_mapping_valid recognizes that duplicates are allowed in subjid (observed_dup_acceptable)
  dup_acceptable <- isTRUE(observed_dup_acceptable$tests_if$cols_are_unique$status)

  # check that is_mapping_valid recognizes that duplicates are not allowed in subjid (observed_dup_not_acceptable)
  dup_not_acceptable <- isFALSE(observed_dup_not_acceptable$tests_if$cols_are_unique$status)

  all_tests <- isTRUE(dup_acceptable) & isTRUE(dup_not_acceptable)
  expect_true(all_tests)
})
