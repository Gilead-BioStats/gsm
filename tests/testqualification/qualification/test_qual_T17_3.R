test_that("Raw data query data can be mapped correctly to create an analysis-ready input dataset which accurately calculates the number of data query age counts and total number of data queries reported per subject.", {
  ########### gsm mapping ###########
  observed <- gsm::QueryAge_Map_Raw()


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))

  # set expected number of days allowed to answer or resolve query
  nMaxQueryAge <- 30

  # create cols vector to facilitate connecting lMapping with source data variables
  cols <- c(
    SubjectID = lMapping$dfSUBJ$strEDCIDCol,
    SiteID = lMapping$dfSUBJ$strSiteCol,
    StudyID = lMapping$dfSUBJ$strStudyCol,
    CountryID = lMapping$dfSUBJ$strCountryCol,
    CustomGroupID = lMapping$dfSUBJ$strCustomGroupCol,
    "Count",
    "Total"
  )

  # read in raw data query age data
  query_age_orig <- clindata::edc_queries

  # count unique number of data queries open for >nMaxQueryAge days within each subject and remove duplicate records
  query_age <- query_age_orig %>%
    filter(!!sym(lMapping$dfQUERY$strQueryAgeCol) > nMaxQueryAge) %>%
    group_by_at(lMapping$dfQUERY$strIDCol) %>%
    mutate(Count = n()) %>%
    select(lMapping$dfQUERY$strIDCol, Count) %>%
    distinct()

  # count number of overall data queries within each subject and remove duplicate records
  query_age_forms <- query_age_orig %>%
    group_by_at(lMapping$dfQUERY$strIDCol) %>%
    mutate(Total = n()) %>%
    select(lMapping$dfQUERY$strIDCol, Total) %>%
    distinct()

  # combine into one data frame
  query_age_all <- full_join(query_age, query_age_forms, by = "subjectname")

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and data query age counts - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, query_age_all, by = c("subject_nsv" = "subjectname")) %>%
    mutate(Count = replace_na(Count, 0)) %>%
    filter(Total != 0 | !is.na(Total)) %>% # remove subjects without any data queries
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  # check that calculated number of data query age counts per subject is correct/consistent
  num_events <- unique(observed$Count == expected$Count)

  # check that calculated total number of data queries reported per subject is correct/consistent
  num_exposure <- unique(observed$Total == expected$Total)

  all_tests <- isTRUE(num_events) & isTRUE(num_exposure)
  expect_true(all_tests)
})
