test_that("The utility function can correctly evaluate that the input parameter specifications are or are not a list.", {
  # ### Preliminary setup
  # df <- clindata::rawplus_dm
  #
  # lMapping <- list(
  #   strIDCol = "subjid",
  #   strSiteCol = "siteid",
  #   strExposureCol = "timeontreatment"
  # )
  #
  #
  # ########### gsm mapping ###########
  # observed_is_list <- gsm::is_mapping_valid(
  #   df = df,
  #   mapping = lMapping,
  #   spec = list(
  #     vRequired = c("strIDCol", "strSiteCol", "strExposureCol"),
  #     vUniqueCols = "strIDCol"
  #   )
  # )
  #
  # observed_is_not_list <- gsm::is_mapping_valid(
  #   df = df,
  #   mapping = lMapping,
  #   spec = "this is not a list"
  # )
  #
  #
  # ########### testing ###########
  # # check that is_mapping_valid recognizes spec as a list (observed_is_list)
  # is_list <- isTRUE(observed_is_list$tests_if$spec_is_list$status)
  #
  # # check that is_mapping_valid recognizes that spec is not a list (observed_is_not_list)
  # is_not_list <- isFALSE(observed_is_not_list$tests_if$spec_is_list$status)
  #
  # all_tests <- isTRUE(is_list) & isTRUE(is_not_list)
  # expect_true(all_tests)
})
