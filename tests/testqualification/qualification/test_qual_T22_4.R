test_that("The utility function can correctly evaluate that the elements of the input mapping(s) are or are not of character class.", {
  ### Preliminary setup
  df <- clindata::rawplus_dm

  lSpec <- list(
    vRequired = c("strIDCol", "strSiteCol", "strExposureCol"),
    vUniqueCols = "strIDCol"
  )


  ########### gsm mapping ###########
  observed_are_chr <- gsm::is_mapping_valid(
    df = df,
    mapping = list(
      strIDCol = "subjid",
      strSiteCol = "siteid",
      strExposureCol = "timeontreatment"
    ),
    spec = lSpec
  )

  observed_not_chr <- gsm::is_mapping_valid(
    df = df,
    mapping = list(
      strIDCol = 1,
      strSiteCol = 2,
      strExposureCol = 3
    ),
    spec = lSpec
  )


  ########### testing ###########
  # check that is_mapping_valid recognizes elements of mapping as character (observed_are_chr)
  is_chr <- isTRUE(observed_are_chr$tests_if$mappings_are_character$status)

  # check that is_mapping_valid recognizes that elements of mapping are not character (observed_not_chr)
  is_not_chr <- isFALSE(observed_not_chr$tests_if$mappings_are_character$status)

  all_tests <- isTRUE(is_chr) & isTRUE(is_not_chr)
  expect_true(all_tests)
})
