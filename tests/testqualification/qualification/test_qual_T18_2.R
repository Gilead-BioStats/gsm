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
  query_age_orig <- clindata::edc_queries
  query_count_orig <- clindata::edc_data_change_rate

  # combine into one data frame
  query <- full_join(query_age_orig, query_count_orig, by = c("subjid", "foldername", "form")) %>%
    select(lMapping$dfQUERY$strIDCol, lMapping$dfQUERY$strVisitCol, lMapping$dfQUERY$strFormCol, lMapping$dfQUERY$strFieldCol, lMapping$dfDATACHG$strDataPointsCol, qrystatus) %>%
    distinct()

  # count unique number of data queries within each subject and remove duplicate records
  query_age <- query %>%
    group_by_at(lMapping$dfSUBJ$strIDCol) %>%
    mutate(DataPoint = sum(as.numeric(!!sym(lMapping$dfDATACHG$strDataPointsCol))),
           flag = ifelse(is.na(qrystatus), 0, 1),
           Count = sum(flag),
           Rate = as.numeric(Count)/as.numeric(DataPoint)) %>%
    select(lMapping$dfDATACHG$strIDCol, DataPoint, Count, Rate) %>%
    distinct()

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and data query rate data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, query_age) %>%
    mutate(Count = replace_na(Count, 0)) %>%
    filter(DataPoint != 0 | !is.na(DataPoint)) %>% # remove subjects without any data points
    select(all_of(cols))


  ########### testing ###########
  expect_equal(colnames(observed), colnames(expected))

})
