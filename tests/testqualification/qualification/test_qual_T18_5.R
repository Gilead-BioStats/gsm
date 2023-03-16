test_that("Raw data query data can be mapped correctly to create an analysis-ready input dataset where the sum of the variable Count is equivalent to the number of rows in the source 'edc_queries' dataset.", {
  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))

  # create cols vector to facilitate connecting lMapping with source data variables
  cols <- c(
    SubjectID = lMapping$dfSUBJ$strEDCIDCol,
    SiteID = lMapping$dfSUBJ$strSiteCol,
    StudyID = lMapping$dfSUBJ$strStudyCol,
    CountryID = lMapping$dfSUBJ$strCountryCol,
    CustomGroupID = lMapping$dfSUBJ$strCustomGroupCol,
    "Count",
    "DataPoint",
    "Rate"
  )

  # read in raw data query data and data point count data
  query_count_orig <- clindata::edc_queries
  data_count_orig <- clindata::edc_data_points

  # count unique number of data queries within each subject and remove duplicate records
  query_count <- query_count_orig %>%
    group_by_at(lMapping$dfQUERY$strIDCol) %>%
    mutate(
      flag = ifelse(is.na(querystatus), 0, 1),
      Count = sum(flag)
    ) %>%
    select(lMapping$dfQUERY$strIDCol, Count) %>%
    distinct()

  # count number of overall data points within each subject and remove duplicate records
  data_count <- data_count_orig %>%
    group_by_at(lMapping$dfDATACHG$strIDCol) %>%
    mutate(DataPoint = n()) %>%
    select(lMapping$dfDATACHG$strIDCol, DataPoint) %>%
    distinct()

  # combine into one data frame
  query_rate <- full_join(query_count, data_count, by = "subjectname")

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and data query rate data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, query_rate, by = c("subject_nsv" = "subjectname")) %>%
    mutate(
      Count = replace_na(Count, 0),
      Rate = as.numeric(Count) / as.numeric(DataPoint)
    ) %>%
    filter(DataPoint != 0 | !is.na(DataPoint)) %>% # remove subjects without any data points
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  # check that overall sum of Count is the same as the number of rows in edc_queries
  expect_equal(sum(expected$Count), nrow(query_count_orig))
})
