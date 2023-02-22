test_that("Raw+ PD data can be mapped correctly to create an analysis-ready input dataset, which accurately indicates if there are protocol deviations associated with each subject (0 = no associated PDs, 1 = associated PDs).", {


  ########### gsm mapping ###########
  observed <- gsm::PD_Map_Raw_Binary()


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

  # read in raw source PD data
  pd_raw_orig <- clindata::rawplus_protdev

  # assign binary indicator for occurrence of PDs within each subject and remove duplicate records
  pd_raw <- pd_raw_orig %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    select(lMapping$dfPD$strIDCol) %>%
    mutate(Count = 1) %>%
    distinct()

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and PD data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, pd_raw, by = "subjid") %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(Count = replace_na(Count, 0),
           Total = n()) %>%
    filter(!(!!sym(lMapping$dfSUBJ$strTimeOnStudyCol) == 0) & !is.na(!!sym(lMapping$dfSUBJ$strTimeOnStudyCol))) %>% # remove subjects that were not treated (i.e., had 0 or NA days of treatment)
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  # check that binary indicator of events per subject is correct/consistent
  num_events <- unique(observed$Count == expected$Count)
  expect_true(num_events)

})
