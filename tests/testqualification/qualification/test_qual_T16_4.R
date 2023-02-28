test_that("A subset of Raw+ Protocol Deviation data can be mapped correctly to create an analysis-ready input dataset.", {


  ########### gsm mapping ###########
  subset <- FilterData(dfInput = clindata::rawplus_protdev,
                       strCol = "importnt",
                       anyVal = "Y") # filtering only for important PDs

  observed <- gsm::PD_Map_Raw_Rate(
    dfs = list(
      dfSUBJ = clindata::rawplus_dm,
      dfPD = subset
    ))


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

  # count unique number of important PDs within each subject and remove duplicate records
  pd_raw <- pd_raw_orig %>%
    filter(!!sym(lMapping$dfPD$strImportantCol) == lMapping$dfPD$strImportantVal) %>%
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
  expect_equal(as.data.frame(observed), as.data.frame(expected))

})
