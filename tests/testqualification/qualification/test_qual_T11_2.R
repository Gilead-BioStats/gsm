test_that("Raw+ AE data can be mapped correctly to create an analysis-ready input dataset that has all required columns in the default Raw+ mapping specifications.", {


  ########### gsm mapping ###########
  observed <- gsm::AE_Map_Raw()


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
    filter(!(!!sym(lMapping$dfSUBJ$strTimeOnTreatmentCol) == 0) & !is.na(!!sym(lMapping$dfSUBJ$strTimeOnTreatmentCol))) %>% # remove subjects that were not treated (i.e., had 0 or NA days of treatment)
    select(all_of(cols))


  ########### testing ###########
  expect_equal(colnames(observed), colnames(expected))

})

