test_that("Raw+ lab data can be mapped correctly to create an analysis-ready input dataset that has all required columns in the default Raw+ mapping specifications.", {


  ########### gsm mapping ###########
  observed <- gsm::LB_Map_Raw()


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

  # create cols vector to facilitate connecting lMapping with source data variables
  cols <- c(SubjectID = lMapping$dfSUBJ$strIDCol,
            SiteID = lMapping$dfSUBJ$strSiteCol,
            StudyID = lMapping$dfSUBJ$strStudyCol,
            CountryID = lMapping$dfSUBJ$strCountryCol,
            CustomGroupID = lMapping$dfSUBJ$strCustomGroupCol,
            "Count",
            "Total")

  # read in raw source LB data
  lb_raw_orig <- clindata::rawplus_lb

  # count unique number of abnormal lab values within each subject and remove duplicate records
  lb_raw_abn <- lb_raw_orig %>%
    filter(!!sym(lMapping$dfLB$strGradeCol) %in% unique(lMapping$dfLB$strGradeHighVal)) %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(Count = n()) %>%
    select(lMapping$dfLB$strIDCol, Count) %>%
    distinct()

  # count number of overall lab values within each subject and remove duplicate records
  lb_raw_all <- lb_raw_orig %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(Total = n()) %>%
    select(lMapping$dfLB$strIDCol, Total) %>%
    distinct()

  # combine into one data frame
  lb_raw <- full_join(lb_raw_abn, lb_raw_all)

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and LB data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, lb_raw) %>%
    mutate(Count = replace_na(Count, 0)) %>%
    filter(Total != 0 | !is.na(Total)) %>% # remove subjects without any lab values
    select(all_of(cols))


  ########### testing ###########
  expect_equal(colnames(observed), colnames(expected))

})
