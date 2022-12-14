test_that("Raw+ AE data can be mapped correctly to create an analysis-ready input dataset that has properly merged demographics and AE data with one record per subject, omitting subjects with zero days of treatment exposure.", {


  ########### gsm mapping ###########
  observed <- gsm::AE_Map_Raw() %>%
    arrange(SubjectID) # sort for ease of testing


  ########### double programming ###########
  # read in source AE data
  ae_raw_orig <- clindata::rawplus_ae

  # count unique number of AEs within each subject and remove duplicate records
  ae_raw <- ae_raw_orig %>%
    group_by(subjid) %>%
    mutate(Count = n()) %>%
    select(subjid, siteid, studyid, invid, Count) %>%
    distinct()


  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # create vector of subjects that were not treated, as they will be excluded
  no_treat_subjs <- unique(dm_raw_orig$subjid[dm_raw_orig$timeontreatment == 0])


  # join DM and AE data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, ae_raw) %>%
    mutate(Count = replace_na(Count, 0),
           Rate = Count/timeontreatment) %>%
    filter(!(subjid %in% no_treat_subjs)) %>% # remove subjects that were not treated
    select(subjid, siteid, studyid, country, invid, timeontreatment, Count, Rate) %>%
    arrange(subjid) # sort for ease of testing

  # rename columns
  cols <- c("SubjectID", "SiteID", "StudyID", "CountryID", "CustomGroupID", "Exposure", "Count", "Rate")
  colnames(expected) <- cols

  expect_equal(observed, expected)

})

