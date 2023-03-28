test_that("A subset of Raw+ Protocol Deviation data can be mapped correctly to create an analysis-ready input dataset.", {
  ########### gsm mapping ###########
  subset <- FilterData(
    dfInput = clindata::ctms_protdev,
    strCol = "DeemedImportant",
    anyVal = "Yes"
  ) # filtering only for important PDs

  observed <- gsm::PD_Map_Raw_Binary(
    dfs = list(
      dfSUBJ = clindata::rawplus_dm,
      dfPD = subset
    )
  )


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_ctms.yaml", package = "gsm"))

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
    filter(!!sym(lMapping$dfPD$strImportantCol) == lMapping$dfPD$strImportantVal) %>%
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
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  expect_equal(as.data.frame(observed), as.data.frame(expected))
})
