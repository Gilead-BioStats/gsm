test_that("Raw+ Labs data can be mapped correctly to create an analysis-ready input dataset that has properly merged demographics and abnormal lab data with one record per subject, omitting subjects with no reported lab values.", {
  ########### gsm mapping ###########
  observed <- gsm::LB_Map_Raw()


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
  lb_raw <- full_join(lb_raw_abn, lb_raw_all, by = "subjid")

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and LB data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, lb_raw, by = "subjid") %>%
    mutate(Count = replace_na(Count, 0)) %>%
    filter(Total != 0 | !is.na(Total)) %>% # remove subjects without any lab values
    select(all_of(cols))


  ########### testing ###########
  # check that unique number of rows is the same as the unique number of subjects
  subj_test <- length(unique(observed$SubjectID)) == nrow(expected)

  # check that there is one record per subject
  subj_length_check <- expected %>%
    group_by(SubjectID) %>%
    mutate(check = n())
  subj_length_test <- unique(subj_length_check$check) == 1

  # check that subjects with no reported lab values are excluded
  empty_test <- unique(is_empty(expected$SubjectID[expected$Total == 0 | is.na(expected$Total)]))

  all_tests <- isTRUE(subj_test) & isTRUE(subj_length_test) & isTRUE(empty_test)
  expect_true(all_tests)
})
