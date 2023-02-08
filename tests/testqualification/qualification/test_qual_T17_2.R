test_that("Raw data query data can be mapped correctly to create an analysis-ready input dataset that has all required columns in the default EDC mapping specifications.", {
  ########### gsm mapping ###########
  observed <- gsm::QueryAge_Map_Raw()


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))

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

  # read in raw data query age data
  query_age_orig <- clindata::edc_queries

  # count unique number of data queries open for >30 days within each subject and remove duplicate records
  query_age <- query_age_orig %>%
    filter(!!sym(lMapping$dfQUERY$strQueryAgeCol) %in% unique(lMapping$dfQUERY$strQueryAgeVal)) %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(Count = n()) %>%
    select(lMapping$dfDATAENT$strIDCol, Count) %>%
    distinct()

  # count number of overall data queries within each subject and remove duplicate records
  query_age_forms <- query_age_orig %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(Total = n()) %>%
    select(lMapping$dfQUERY$strIDCol, Total) %>%
    distinct()

  # combine into one data frame
  query_age_all <- full_join(query_age, query_age_forms, by = "subjid")

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and data query age counts - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, query_age_all, by = "subjid") %>%
    mutate(Count = replace_na(Count, 0)) %>%
    filter(Total != 0 | !is.na(Total)) %>% # remove subjects without any data queries
    select(all_of(cols))


  ########### testing ###########
  expect_equal(colnames(observed), colnames(expected))
})
