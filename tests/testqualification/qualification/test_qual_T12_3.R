test_that("Raw data entry data can be mapped correctly to create an analysis-ready input dataset which accurately calculates the number of times any data point changed for a given data page and the total number of data points reported per subject.", {
  ########### gsm mapping ###########
  observed <- gsm::DataChg_Map_Raw()


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- gsm::Read_Mapping(c("rawplus", "edc"))

  # create cols vector to facilitate connecting lMapping with source data variables
  cols <- c(
    SubjectID = lMapping$dfSUBJ$strEDCIDCol,
    SiteID = lMapping$dfSUBJ$strSiteCol,
    StudyID = lMapping$dfSUBJ$strStudyCol,
    CountryID = lMapping$dfSUBJ$strCountryCol,
    CustomGroupID = lMapping$dfSUBJ$strCustomGroupCol,
    "Count",
    "Total"
  )

  # read in raw data change count data
  data_chg_orig <- clindata::edc_data_points

  # count unique number of data point changes within each subject and remove duplicate records
  data_chg <- data_chg_orig %>%
    group_by_at(lMapping$dfDATACHG$strIDCol) %>%
    mutate(
      Count = sum(as.numeric(!!sym(lMapping$dfDATACHG$strNChangesCol))), # count for total number of times any data point changed for a given data page
      Total = n()
    ) %>% # count for total number of data points
    select(lMapping$dfDATACHG$strIDCol, Count, Total) %>%
    distinct()

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and data change count data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, data_chg, by = c("subject_nsv" = "subjectname")) %>%
    mutate(Count = replace_na(Count, 0)) %>%
    filter(Total != 0 | !is.na(Total)) %>% # remove subjects without any data points
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  # check that calculated number of times any data point changed for a given data page per subject is correct/consistent
  num_events <- unique(observed$Count == expected$Count)

  # check that calculated total number of data points reported per subject is correct/consistent
  num_exposure <- unique(observed$Total == expected$Total)

  all_tests <- isTRUE(num_events) & isTRUE(num_exposure)
  expect_true(all_tests)
})
