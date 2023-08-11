test_that("A subset of rawplus Labs data can be mapped correctly to create an analysis-ready input dataset.", {
  ########### gsm mapping ###########
  subset <- FilterData(
    dfInput = clindata::rawplus_lb,
    strCol = "treatmentemergent",
    anyVal = "Y"
  ) # filtering only for treatment-emergent abnormal lab values

  observed <- gsm::LB_Map_Raw(
    dfs = list(
      dfSUBJ = clindata::rawplus_dm,
      dfLB = subset
    )
  )


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

  # create cols vector to facilitate connecting lMapping with source data variables
  cols <- c(
    SubjectID = lMapping$dfSUBJ$strIDCol,
    SiteID = lMapping$dfSUBJ$strSiteCol,
    StudyID = lMapping$dfSUBJ$strStudyCol,
    CountryID = lMapping$dfSUBJ$strCountryCol,
    CustomGroupID = lMapping$dfSUBJ$strCustomGroupCol,
    "Count",
    "Total"
  )

  # read in raw source LB data
  lb_raw_orig <- clindata::rawplus_lb

  # count unique number of treatment-emergent abnormal lab values within each subject and remove duplicate records
  lb_raw_abn <- lb_raw_orig %>%
    filter(!!sym(lMapping$dfLB$strTreatmentEmergentCol) == lMapping$dfLB$strTreatmentEmergentVal) %>%
    filter(!!sym(lMapping$dfLB$strGradeCol) %in% unique(lMapping$dfLB$strGradeHighVal)) %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(Count = n()) %>%
    select(lMapping$dfLB$strIDCol, Count) %>%
    distinct()

  # count number of overall treatment-emergent lab values within each subject and remove duplicate records
  lb_raw_all <- lb_raw_orig %>%
    filter(!!sym(lMapping$dfLB$strTreatmentEmergentCol) == lMapping$dfLB$strTreatmentEmergentVal) %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(Total = n()) %>%
    select(lMapping$dfLB$strIDCol, Total) %>%
    distinct()

  # combine into one data frame
  lb_raw <- full_join(lb_raw_abn, lb_raw_all, by = "subjid")

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and LB data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, lb_raw, by = "subjid") %>%
    mutate(Count = replace_na(Count, 0)) %>%
    filter(Total != 0 | !is.na(Total)) %>% # remove subjects without any lab values
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  expect_equal(as.data.frame(observed), as.data.frame(expected))
})
