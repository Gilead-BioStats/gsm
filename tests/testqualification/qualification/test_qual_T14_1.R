test_that("rawplus Study Disposition data can be mapped correctly to create an analysis-ready input dataset that has properly merged demographics and Study Disposition data with one record per subject.", {
  ########### gsm mapping ###########
  observed <- gsm::Disp_Map_Raw(strContext = "Study")


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

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

  # read in raw source study disposition data
  disp_raw_orig <- clindata::rawplus_studcomp

  # count unique number of subjects who discontinued from the study
  disp_raw <- disp_raw_orig %>%
    filter(!!sym(lMapping$dfSTUDCOMP$strStudyDiscontinuationFlagCol) == lMapping$dfSTUDCOMP$strStudyDiscontinuationFlagVal) %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(Count = n()) %>%
    select(lMapping$dfSTUDCOMP$strIDCol, Count) %>%
    distinct()

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and study disposition data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, disp_raw, by = "subjid") %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(
      Count = replace_na(Count, 0),
      Total = n()
    ) %>%
    select(all_of(cols))


  ########### testing ###########
  # check that unique number of rows is the same as the unique number of subjects
  subj_test <- length(unique(observed$SubjectID)) == nrow(expected)

  # check that there is one record per subject
  subj_length_check <- expected %>%
    group_by(SubjectID) %>%
    mutate(check = n())
  subj_length_test <- unique(subj_length_check$check) == 1

  all_tests <- isTRUE(subj_test) & isTRUE(subj_length_test)
  expect_true(all_tests)
})
