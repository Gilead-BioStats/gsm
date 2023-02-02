test_that("Raw data query data can be mapped correctly to create an analysis-ready input dataset that has all required columns in the default EDC mapping specifications.", {


  ########### gsm mapping ###########
  observed <- gsm::QueryRate_Map_Raw()


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))

  # create cols vector to facilitate connecting lMapping with source data variables
  cols <- c(SubjectID = lMapping$dfSUBJ$strIDCol,
            SiteID = lMapping$dfSUBJ$strSiteCol,
            StudyID = lMapping$dfSUBJ$strStudyCol,
            CountryID = lMapping$dfSUBJ$strCountryCol,
            CustomGroupID = lMapping$dfSUBJ$strCustomGroupCol,
            "DataPoint",
            "Count",
            "Rate")

  # read in raw data query data and data point count data
  query_count_orig <- clindata::edc_queries
  data_count_orig <- clindata::edc_data_change_rate

  # count unique number of data queries within each subject and remove duplicate records
  query_count <- query_count_orig %>%
    group_by_at(lMapping$dfQUERY$strIDCol) %>%
    mutate(flag = ifelse(is.na(qrystatus), 0, 1),
           Count = sum(flag)) %>%
    select(lMapping$dfQUERY$strIDCol, Count) %>%
    distinct()

  # count number of overall data points within each subject and remove duplicate records
  data_count <- data_count_orig %>%
    group_by_at(lMapping$dfDATACHG$strIDCol) %>%
    mutate(DataPoint = sum(as.numeric(!!sym(lMapping$dfDATACHG$strDataPointsCol)))) %>%
    select(lMapping$dfDATACHG$strIDCol, DataPoint) %>%
    distinct()

  # combine into one data frame
  query_rate <- full_join(query_count, data_count, by = "subjid")

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and data query rate data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, query_rate, by = "subjid") %>%
    mutate(Count = replace_na(Count, 0),
           Rate = as.numeric(Count)/as.numeric(DataPoint)) %>%
    filter(DataPoint != 0 | !is.na(DataPoint)) %>% # remove subjects without any data points
    select(all_of(cols))


  ########### testing ###########
  expect_equal(colnames(observed), colnames(expected))

})
