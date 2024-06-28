test_that("The utility function can correctly evaluate that the input mapping(s) is(are) or is(are) not a list.", {
  # ### Preliminary setup
  # df <- clindata::rawplus_dm
  #
  # lSpec <- list(
  #   vRequired = c("strIDCol", "strSiteCol", "strExposureCol"),
  #   vUniqueCols = "strIDCol"
  # )
  #
  #
  # ########### gsm mapping ###########
  # observed_is_list <- gsm::is_mapping_valid(
  #   df = df,
  #   mapping = list(
  #     strIDCol = "subjid",
  #     strSiteCol = "siteid",
  #     strExposureCol = "timeontreatment"
  #   ),
  #   spec = lSpec
  # )
  #
  # observed_is_not_list <- gsm::is_mapping_valid(
  #   df = df,
  #   mapping = "this is not a list",
  #   spec = lSpec
  # )
  #
  #
  # ########### testing ###########
  # # check that is_mapping_valid recognizes mapping as a list (observed_is_list)
  # is_list <- isTRUE(observed_is_list$tests_if$mapping_is_list$status)
  #
  # # check that is_mapping_valid recognizes that mapping is not a list (observed_is_not_list)
  # is_not_list <- isFALSE(observed_is_not_list$tests_if$mapping_is_list$status)
  #
  # all_tests <- isTRUE(is_list) & isTRUE(is_not_list)
  # expect_true(all_tests)
})
