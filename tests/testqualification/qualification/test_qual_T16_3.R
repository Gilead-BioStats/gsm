test_that("Raw+ Protocol Deviation data can be mapped correctly to create an analysis-ready input dataset which accurately calculates the number of Protocol Deviations and days on study per subject.", {


  ########### gsm mapping ###########
  observed <- gsm::PD_Map_Raw_Rate()


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

  # create cols vector to facilitate connecting lMapping with source data variables
  cols <- c(SubjectID = lMapping$dfSUBJ$strIDCol,
            SiteID = lMapping$dfSUBJ$strSiteCol,
            StudyID = lMapping$dfSUBJ$strStudyCol,
            CountryID = lMapping$dfSUBJ$strCountryCol,
            CustomGroupID = lMapping$dfSUBJ$strCustomGroupCol,
            Exposure = lMapping$dfSUBJ$strTimeOnStudyCol,
            "Count",
            "Rate")

  # read in raw source PD data
  pd_raw_orig <- clindata::rawplus_protdev

  # count unique number of PDs within each subject and remove duplicate records
  pd_raw <- pd_raw_orig %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    select(lMapping$dfPD$strIDCol) %>%
    mutate(Count = n()) %>%
    distinct()

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and PD data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, pd_raw, by = "subjid") %>%
    mutate(Count = replace_na(Count, 0),
           Rate = as.numeric(Count)/!!sym(lMapping$dfSUBJ$strTimeOnStudyCol)) %>%
    filter(!(!!sym(lMapping$dfSUBJ$strTimeOnStudyCol) == 0) & !is.na(!!sym(lMapping$dfSUBJ$strTimeOnStudyCol))) %>% # remove subjects that were not treated (i.e., had 0 or NA days of treatment)
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  # check that calculated number of events per subject is correct/consistent
  num_events <- unique(observed$Count == expected$Count)

  # check that calculated days on study per subject is correct/consistent
  num_exposure <- unique(observed$Exposure == expected$Exposure)

  # check that calculated rate of PDs/days on study per subject is correct/consistent
  rate <- unique(observed$Rate == expected$Rate)

  all_tests <- isTRUE(num_events) & isTRUE(num_exposure) & isTRUE(rate)
  expect_true(all_tests)

})
