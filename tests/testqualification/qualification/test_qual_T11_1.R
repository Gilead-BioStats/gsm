test_that("Raw+ AE data can be mapped correctly to create an analysis-ready input dataset that has properly merged demographics and AE data with one record per subject, omitting subjects with zero days of treatment exposure.", {


  ########### gsm mapping ###########
  observed <- gsm::AE_Map_Raw()


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
    select(subjid, siteid, studyid, country, invid, timeontreatment, Count, Rate)

  # rename columns
  colnames(expected) <- c("SubjectID", "SiteID", "StudyID", "CountryID", "CustomGroupID", "Exposure", "Count", "Rate")

  # test setup
  subj_test <- length(unique(observed$SubjectID)) == nrow(expected) # unique number of rows is the same as the unique number of subjects
  subj_length_check <- expected %>%
    group_by(SubjectID) %>%
    mutate(check = n())
  subj_length_test <- unique(subj_length_check$check) == 1 # one record per subject
  treat_test <- unique(!(no_treat_subjs %in% unique(expected$SubjectID))) # subjects with 0 days on treatment are excluded
  all_tests <- isTRUE(subj_test) & isTRUE(subj_length_test) & isTRUE(treat_test)

  # test
  expect_true(all_tests)

})

