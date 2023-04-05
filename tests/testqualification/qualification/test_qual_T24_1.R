test_that("Raw+ Protocol Deviation data can be mapped correctly to create an analysis-ready input dataset that has properly merged demographics and Protocol Deviation data with one record per subject, omitting subjects with zero days on study.", {
  ########### gsm mapping ###########
  observed <- gsm::PD_Map_Raw_Binary()


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- gsm::Read_Mapping(c("rawplus", "ctms"))

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

  # read in raw source PD data
  pd_raw_orig <- clindata::ctms_protdev

  # assign binary indicator for occurrence of PDs within each subject and remove duplicate records
  pd_raw <- pd_raw_orig %>%
    group_by_at(lMapping$dfPD$strIDCol) %>%
    select(lMapping$dfPD$strIDCol) %>%
    mutate(Count = 1) %>%
    distinct()

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and PD data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, pd_raw, by = c("subjid" = "SubjectEnrollmentNumber")) %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(
      Count = replace_na(Count, 0),
      Total = n()
    ) %>%
    filter(!(!!sym(lMapping$dfSUBJ$strTimeOnStudyCol) == 0) & !is.na(!!sym(lMapping$dfSUBJ$strTimeOnStudyCol))) %>% # remove subjects that were not treated (i.e., had 0 or NA days of treatment)
    select(all_of(cols))


  ########### testing ###########
  # check that unique number of rows is the same as the unique number of subjects
  subj_test <- length(unique(observed$SubjectID)) == nrow(expected)

  # check that there is one record per subject
  subj_length_check <- expected %>%
    group_by(SubjectID) %>%
    mutate(check = n())
  subj_length_test <- unique(subj_length_check$check) == 1

  # check that subjects with 0 days on treatment are excluded
  treat_test <- unique(!(unique(!!sym(lMapping$dfSUBJ$strTimeOnTreatmentCol) == 0) %in% unique(expected$SubjectID)))

  all_tests <- isTRUE(subj_test) & isTRUE(subj_length_test) & isTRUE(treat_test)
  expect_true(all_tests)
})
