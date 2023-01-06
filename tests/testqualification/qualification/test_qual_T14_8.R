test_that("A subset of Raw+ study drug disposition data can be mapped correctly to create an analysis-ready input dataset.", {


  ########### gsm mapping ###########
  subset <- FilterData(dfInput = clindata::rawplus_sdrgcomp,
                       strCol = "sdrgreas",
                       anyVal = "ADVERSE EVENT") # filtering only for subjects who discontinued study drug due to an AE

  observed <- gsm::Disp_Map_Raw(
    dfs = list(
      dfSUBJ = clindata::rawplus_dm,
      dfSDRGCOMP = subset
    ),
    strContext = "Treatment")


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
  lMapping$dfSDRGCOMP$strTreatmentDiscontinuationReasonVal <- "ADVERSE EVENT"

  # create cols vector to facilitate connecting lMapping with source data variables
  cols <- c(SubjectID = lMapping$dfSUBJ$strIDCol,
            SiteID = lMapping$dfSUBJ$strSiteCol,
            StudyID = lMapping$dfSUBJ$strStudyCol,
            CountryID = lMapping$dfSUBJ$strCountryCol,
            CustomGroupID = lMapping$dfSUBJ$strCustomGroupCol,
            "Count",
            "Total")

  # read in raw source study drug disposition data
  disp_raw_orig <- clindata::rawplus_sdrgcomp %>%
    filter(!!sym(lMapping$dfSDRGCOMP$strTreatmentPhaseCol) == lMapping$dfSDRGCOMP$strTreatmentPhaseVal)

  # count unique number of subjects who discontinued use of study drug due to an AE
  disp_raw <- disp_raw_orig %>%
    filter(!!sym(lMapping$dfSDRGCOMP$strTreatmentDiscontinuationFlagCol) == lMapping$dfSDRGCOMP$strTreatmentDiscontinuationFlagVal) %>%
    filter(!!sym(lMapping$dfSDRGCOMP$strTreatmentDiscontinuationReasonCol) == lMapping$dfSDRGCOMP$strTreatmentDiscontinuationReasonVal) %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(Count = n()) %>%
    select(lMapping$dfSDRGCOMP$strIDCol, Count) %>%
    distinct()

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and study drug disposition data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, disp_raw) %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(Count = replace_na(Count, 0),
           Total = n()) %>%
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  expect_equal(as.data.frame(observed), as.data.frame(expected))

})
