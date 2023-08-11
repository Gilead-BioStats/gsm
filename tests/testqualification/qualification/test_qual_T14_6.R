test_that("rawplus Study Treatment Disposition data can be mapped correctly to create an analysis-ready input dataset which accurately calculates the number of subjects who discontinued use of study treatment.", {
  ########### gsm mapping ###########
  observed <- gsm::Disp_Map_Raw(strContext = "Treatment")


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

  # read in raw source study treatment disposition data
  disp_raw_orig <- clindata::rawplus_sdrgcomp %>%
    filter(!!sym(lMapping$dfSDRGCOMP$strTreatmentPhaseCol) == lMapping$dfSDRGCOMP$strTreatmentPhaseVal)

  # count unique number of subjects who discontinued use of study treatment
  disp_raw <- disp_raw_orig %>%
    filter(!!sym(lMapping$dfSDRGCOMP$strTreatmentDiscontinuationFlagCol) == lMapping$dfSDRGCOMP$strTreatmentDiscontinuationFlagVal) %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(Count = n()) %>%
    select(lMapping$dfSDRGCOMP$strIDCol, Count) %>%
    distinct()

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and study treatment disposition data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, disp_raw, by = "subjid") %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(
      Count = replace_na(Count, 0),
      Total = n()
    ) %>%
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  # check that calculated number of subjects who discontinued use of study treatment is correct/consistent
  num_events <- unique(observed$Count == expected$Count)
  expect_true(num_events)
})
