test_that("Given correct input data and metadata, the correct number of sites per study can be derived.", {
  # ########### gsm mapping ###########
  # observed <- gsm::Get_Enrolled(
  #   dfSUBJ = clindata::rawplus_dm,
  #   dfConfig = gsm::config_param,
  #   lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
  #   strUnit = "site",
  #   strBy = "study"
  # )
  #
  #
  # ########### double programming ###########
  # # read in default mapping specs
  # lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
  #
  # # read in raw source DM data
  # dm_raw_orig <- clindata::rawplus_dm
  #
  # # group by study and calculate total
  # expected <- dm_raw_orig %>%
  #   group_by_at(lMapping$dfSUBJ$strStudyCol) %>%
  #   mutate(n = length(unique(!!sym(lMapping$dfSUBJ$strSiteCol))))
  #
  #
  # ########### testing ###########
  # expect_equal(observed, as.integer(unique(expected$n)))
})
