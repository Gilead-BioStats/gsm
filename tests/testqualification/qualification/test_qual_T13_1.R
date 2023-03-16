test_that("Raw data entry data can be mapped correctly to create an analysis-ready input dataset that has properly merged demographics and data entry lag counts with one record per subject, omitting subjects with no reported data pages.", {
  ########### gsm mapping ###########
  observed <- gsm::DataEntry_Map_Raw()


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))

  nMaxDataEntryLag <- 10

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

  # read in raw data entry lag data
  # note that data_entry_lag is number of days between the visit date and the earliest field entry date
  data_entry_orig <- clindata::edc_data_pages

  # count unique number of data pages with data entry lag (i.e., >10 days between the visit date and the earliest field entry date - where data_entry_lag_fl == "Y") within each subject and remove duplicate records
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
    select(all_of(cols))


  ########### testing ###########
  # check that unique number of rows is the same as the unique number of subjects
  subj_test <- length(unique(observed$SubjectID)) == nrow(expected)

  # check that there is one record per subject
  subj_length_check <- expected %>%
    group_by(SubjectID) %>%
    mutate(check = n())
  subj_length_test <- unique(subj_length_check$check) == 1

  # check that subjects with no reported data pages are excluded
  page_test <- unique(is_empty(expected$SubjectID[expected$Total == 0 | is.na(expected$Total)]))

  all_tests <- isTRUE(subj_test) & isTRUE(subj_length_test) & isTRUE(page_test)
  expect_true(all_tests)
})
