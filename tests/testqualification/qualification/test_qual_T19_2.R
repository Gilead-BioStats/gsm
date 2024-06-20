test_that("Given pre-specified mapping, input data can be filtered to produce a data frame which retains all original source columns.", {
  # ########### gsm mapping ###########
  # observed <- FilterDomain(
  #   df = clindata::rawplus_ae,
  #   lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
  #   strDomain = "dfAE",
  #   strColParam = "strSeriousCol",
  #   strValParam = "strSeriousVal"
  # )
  #
  #
  # ########### double programming ###########
  # # read in default mapping specs
  # lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
  #
  # # specify columns to retain
  # cols <- colnames(clindata::rawplus_ae)
  #
  # # read in raw source AE data
  # ae_raw_orig <- clindata::rawplus_ae
  #
  # # filter raw source AE data for serious AEs
  # expected <- ae_raw_orig %>%
  #   filter(!!sym(lMapping$dfAE$strSeriousCol) == lMapping$dfAE$strSeriousVal)
  #
  #
  # ########### testing ###########
  # # check that observed and expected have same columns
  # col_check <- unique(colnames(observed) == colnames(expected))
  #
  # # check that observed has the same columns as clindata::rawplus_ae
  # cross_check <- unique(colnames(observed) == colnames(ae_raw_orig))
  #
  # all_tests <- isTRUE(col_check) & isTRUE(cross_check)
  # expect_true(all_tests)
})
