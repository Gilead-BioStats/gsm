test_that("Given correct input data and metadata, the correct number of enrolled participants per site can be derived.", {
  ########### gsm mapping ###########
  observed <- gsm::Get_Enrolled(
    dfSUBJ = clindata::rawplus_dm,
    dfConfig = gsm::config_param,
    lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
    strUnit = "participant",
    strBy = "site"
  )


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

  # create cols vector to facilitate connecting lMapping with source data variables
  cols <- c(
    SiteID = lMapping$dfSUBJ$strSiteCol,
    "enrolled_participants"
  )

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm

  # group by study and calculate total
  expected <- dm_raw_orig %>%
    group_by_at(lMapping$dfSUBJ$strSiteCol) %>%
    mutate(enrolled_participants = length(unique(!!sym(lMapping$dfSUBJ$strIDCol)))) %>%
    arrange(!!sym(lMapping$dfSUBJ$strSiteCol)) %>%
    select(all_of(cols)) %>%
    distinct()


  ########### testing ###########
  expect_equal(as.data.frame(observed), as.data.frame(expected))
})
