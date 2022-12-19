test_that("Raw+ AE data can be mapped correctly to create an analysis-ready input dataset that has properly merged demographics and AE data with one record per subject, omitting subjects with zero days of treatment exposure.", {


  ########### gsm mapping ###########
  observed <- gsm::AE_Map_Raw()


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

  # create vector to facilitate connecting lMapping with source data
  cols <- c(SubjectID = lMapping$dfSUBJ$strIDCol,
            SiteID = lMapping$dfSUBJ$strSiteCol,
            StudyID = lMapping$dfSUBJ$strStudyCol,
            CountryID = lMapping$dfSUBJ$strCountryCol,
            CustomGroupID = lMapping$dfSUBJ$strCustomGroupCol,
            Exposure = lMapping$dfSUBJ$strTimeOnTreatmentCol,
            "Count",
            "Rate")

  # read in source AE data
  ae_raw_orig <- clindata::rawplus_ae

  # count unique number of AEs within each subject and remove duplicate records
  ae_raw <- ae_raw_orig %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    select(lMapping$dfAE$strIDCol) %>%
    mutate(Count = n()) %>%
    distinct()

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and AE data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, ae_raw) %>%
    mutate(Count = replace_na(Count, 0),
           Rate = as.numeric(Count)/!!sym(lMapping$dfSUBJ$strTimeOnTreatmentCol)) %>%
    filter(!(!!sym(lMapping$dfSUBJ$strTimeOnTreatmentCol) == 0)) %>% # remove subjects that were not treated
    select(all_of(cols))

  # test setup
  # unique number of rows is the same as the unique number of subjects
  subj_test <- length(unique(observed$SubjectID)) == nrow(expected)
  # one record per subject
  subj_length_check <- expected %>%
    group_by(SubjectID) %>%
    mutate(check = n())
  subj_length_test <- unique(subj_length_check$check) == 1
  # subjects with 0 days on treatment are excluded
  treat_test <- unique(!(unique(!!sym(lMapping$dfSUBJ$strTimeOnTreatmentCol) == 0) %in% unique(expected$SubjectID)))
  all_tests <- isTRUE(subj_test) & isTRUE(subj_length_test) & isTRUE(treat_test)

  # test
  expect_true(all_tests)

})

