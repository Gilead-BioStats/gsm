test_that("A subset of Raw+ AE data can be mapped correctly to create an analysis-ready input dataset.", {


  ########### gsm mapping ###########
  subset <- FilterData(dfInput = clindata::rawplus_ae,
                       strCol = "aeser",
                       anyVal = "Y") # filtering only for serious AEs

  observed <- gsm::AE_Map_Raw(
    dfs = list(
      dfSUBJ = clindata::rawplus_dm,
      dfAE = subset
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
            Exposure = lMapping$dfSUBJ$strTimeOnTreatmentCol,
            "Count",
            "Rate")

  # read in raw source AE data
  ae_raw_orig <- clindata::rawplus_ae

  # count unique number of serious AEs within each subject and remove duplicate records
  ae_raw <- ae_raw_orig %>%
    filter(!!sym(lMapping$dfAE$strSeriousCol) == lMapping$dfAE$strSeriousVal) %>%
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
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  expect_equal(as.data.frame(observed), as.data.frame(expected))

})

