test_that("A subset of raw data entry data can be mapped correctly to create an analysis-ready input dataset.", {
  ########### gsm mapping ###########
  subset <- FilterData(
    dfInput = clindata::edc_data_points,
    strCol = "formoid",
    anyVal = "PK"
  ) # filtering only for PK forms

  observed <- gsm::DataChg_Map_Raw(
    dfs = list(
      dfSUBJ = clindata::rawplus_dm,
      dfDATACHG = subset
    )
  )


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- gsm::Read_Mapping(c("rawplus", "edc"))

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

  # read in raw data change count data
  data_chg_orig <- clindata::edc_data_points

  # count unique number of PK data point changes within each subject and remove duplicate records
  data_chg <- data_chg_orig %>%
    filter(!!sym(lMapping$dfDATACHG$strFormCol) == "PK") %>%
    group_by_at(lMapping$dfDATACHG$strIDCol) %>%
    mutate(
      Count = sum(as.numeric(!!sym(lMapping$dfDATACHG$strNChangesCol))), # count for total number of times any data point changed for a given data page
      Total = n()
    ) %>% # count for total number of data points
    select(lMapping$dfDATACHG$strIDCol, Count, Total) %>%
    distinct()

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and data change count data - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, data_chg, by = c("subject_nsv" = "subjectname")) %>%
    mutate(Count = replace_na(Count, 0)) %>%
    filter(Total != 0 | !is.na(Total)) %>% # remove subjects without any data points
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  expect_equal(as.data.frame(observed), as.data.frame(expected))
})
