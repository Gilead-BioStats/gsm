test_that("Raw data entry data can be mapped correctly to create an analysis-ready input dataset that has properly merged demographics and data point change counts with one record per subject, omitting subjects with no reported data points.", {


  ########### gsm mapping ###########
  observed <- gsm::DataChg_Map_Raw()


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))

  # create cols vector to facilitate connecting lMapping with source data variables
  cols <- c(SubjectID = lMapping$dfSUBJ$strIDCol,
            SiteID = lMapping$dfSUBJ$strSiteCol,
            StudyID = lMapping$dfSUBJ$strStudyCol,
            CountryID = lMapping$dfSUBJ$strCountryCol,
            CustomGroupID = lMapping$dfSUBJ$strCustomGroupCol,
            "Count",
            "Total")

  # read in raw data change count data
  data_chg_orig <- clindata::edc_data_change_rate

  # count unique number of data point changes within each subject and remove duplicate records
  data_chg <- data_chg_orig %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(Count = sum(as.numeric(!!sym(lMapping$dfDATACHG$strDataPointsChangeCol))), # count for total number of times any data point changed for a given data page
           Total = sum(as.numeric(!!sym(lMapping$dfDATACHG$strDataPointsCol)))) %>% # count for total number of data points
    select(lMapping$dfDATACHG$strIDCol, Count, Total) %>%
    distinct()

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and data change count data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, data_chg, by = "subjid") %>%
    mutate(Count = replace_na(Count, 0)) %>%
    filter(Total != 0 | !is.na(Total)) %>% # remove subjects without any data points
    select(all_of(cols))


  ########### testing ###########
  # check that unique number of rows is the same as the unique number of subjects
  subj_test <- length(unique(observed$SubjectID)) == nrow(expected)

  # check that there is one record per subject
  subj_length_check <- expected %>%
    group_by(SubjectID) %>%
    mutate(check = n())
  subj_length_test <- unique(subj_length_check$check) == 1

  # check that subjects with no reported data points are excluded
  empty_test <- unique(is_empty(expected$SubjectID[expected$Total == 0 | is.na(expected$Total)]))

  all_tests <- isTRUE(subj_test) & isTRUE(subj_length_test) & isTRUE(empty_test)
  expect_true(all_tests)

})
