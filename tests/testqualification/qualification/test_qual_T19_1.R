test_that("Given pre-specified mapping, input data can be filtered to produce a data frame with the correct number of rows.", {
  ########### gsm mapping ###########
  observed <- FilterDomain(
    df = clindata::rawplus_ae,
    lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
    strDomain = "dfAE",
    strColParam = "strSeriousCol",
    strValParam = "strSeriousVal"
  )


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

  # read in raw source AE data
  ae_raw_orig <- clindata::rawplus_ae

  # filter raw source AE data for serious AEs
  expected <- ae_raw_orig %>%
    filter(!!sym(lMapping$dfAE$strSeriousCol) == lMapping$dfAE$strSeriousVal)


  ########### testing ###########
  # check that observed and expected have same number of rows
  row_check <- nrow(observed) == nrow(expected)

  # check that observed has the same number of rows as clindata::rawplus_ae where aeser == "Y"
  cross_check <- nrow(observed) == nrow(ae_raw_orig[ae_raw_orig$aeser == "Y", ])

  all_tests <- isTRUE(row_check) & isTRUE(cross_check)
  expect_true(all_tests)
})
