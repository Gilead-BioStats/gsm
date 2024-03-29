test_that("A subset of rawplus Study Disposition data can be mapped correctly to create an analysis-ready input dataset.", {
  ########### gsm mapping ###########
  subset <- FilterData(
    dfInput = clindata::rawplus_studcomp,
    strCol = "compreas",
    anyVal = "ADVERSE EVENT"
  ) # filtering only for subjects who discontinued from the study due to an AE

  observed <- gsm::Disp_Map_Raw(
    dfs = list(
      dfSUBJ = clindata::rawplus_dm,
      dfSTUDCOMP = subset
    ),
    strContext = "Study"
  )


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
  lMapping$dfSTUDCOMP$strStudyDiscontinuationReasonVal <- "ADVERSE EVENT"

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

  # count unique number of subjects who discontinued from the study due to an AE
  disp_raw <- disp_raw_orig %>%
    filter(!!sym(lMapping$dfSTUDCOMP$strStudyDiscontinuationFlagCol) == lMapping$dfSTUDCOMP$strStudyDiscontinuationFlagVal) %>%
    filter(!!sym(lMapping$dfSTUDCOMP$strStudyDiscontinuationReasonCol) == lMapping$dfSTUDCOMP$strStudyDiscontinuationReasonVal) %>%
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
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  expect_equal(as.data.frame(observed), as.data.frame(expected))
})
