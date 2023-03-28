test_that("Raw data entry data can be mapped correctly to create an analysis-ready input dataset which accurately calculates the number of data entry lag counts and total number of data pages reported per subject.", {
  ########### gsm mapping ###########
  observed <- gsm::DataEntry_Map_Raw()


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))

  # set expected number of days allowed to enter data
  nMaxDataEntryLag <- 10

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

  # read in raw data entry lag data
  # note that data_entry_lag is number of days between the visit date and the earliest field entry date
  data_entry_orig <- clindata::edc_data_pages

  # count unique number of data pages with data entry lag (i.e., >nMaxDataEntryLag days between the visit date and the earliest field entry date) within each subject and remove duplicate records
  data_entry <- data_entry_orig %>%
    filter(!!sym(lMapping$dfDATAENT$strDataEntryLagCol) > nMaxDataEntryLag) %>%
    group_by_at(lMapping$dfDATAENT$strIDCol) %>%
    mutate(Count = n()) %>%
    select(lMapping$dfDATAENT$strIDCol, Count) %>%
    distinct()

  # count number of overall data pages within each subject and remove duplicate records
  data_entry_pages <- data_entry_orig %>%
    group_by_at(lMapping$dfDATAENT$strIDCol) %>%
    mutate(Total = n()) %>%
    select(lMapping$dfDATAENT$strIDCol, Total) %>%
    distinct()

  # combine into one data frame
  data_entry_all <- full_join(data_entry, data_entry_pages, by = "subjectname")

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and data entry lag counts - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, data_entry_all, by = c("subject_nsv" = "subjectname")) %>%
    mutate(Count = replace_na(Count, 0)) %>%
    filter(Total != 0 | !is.na(Total)) %>% # remove subjects without any data pages
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  # check that calculated number of data entry lag counts per subject is correct/consistent
  num_events <- unique(observed$Count == expected$Count)

  # check that calculated total number of data pages reported per subject is correct/consistent
  num_exposure <- unique(observed$Total == expected$Total)

  all_tests <- isTRUE(num_events) & isTRUE(num_exposure)
  expect_true(all_tests)
})
