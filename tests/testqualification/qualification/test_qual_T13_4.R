test_that("A subset of raw data entry data can be mapped correctly to create an analysis-ready input dataset.", {
  ########### gsm mapping ###########
  subset <- FilterData(
    dfInput = clindata::edc_data_pages,
    strCol = "formoid",
    anyVal = "PK"
  ) # filtering only for PK forms

  observed <- gsm::DataEntry_Map_Raw(
    dfs = list(
      dfSUBJ = clindata::rawplus_dm,
      dfDATAENT = subset
    )
  )


  ########### double programming ###########
  # read in default mapping specs
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))

  # set expected number of days allowed to enter data
  nMaxDataEntryLag <- 10

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

  # read in raw data entry lag data
  # note that data_entry_lag is number of days between the visit date and the earliest field entry date
  data_entry_orig <- clindata::edc_data_pages

  # count unique number of PK data pages with data entry lag (i.e., >nMaxDataEntryLag days between the visit date and the earliest field entry date) within each subject and remove duplicate records
  data_entry <- data_entry_orig %>%
    filter(!!sym(lMapping$dfDATAENT$strFormCol) == "PK") %>%
    filter(!!sym(lMapping$dfDATAENT$strDataEntryLagCol) > nMaxDataEntryLag) %>%
    group_by_at(lMapping$dfDATAENT$strIDCol) %>%
    mutate(Count = n()) %>%
    select(lMapping$dfDATAENT$strIDCol, Count) %>%
    distinct()

  # count number of overall PK data pages within each subject and remove duplicate records
  data_entry_pages <- data_entry_orig %>%
    filter(!!sym(lMapping$dfDATAENT$strFormCol) == "PK") %>%
    group_by_at(lMapping$dfDATAENT$strIDCol) %>%
    mutate(Total = n()) %>%
    select(lMapping$dfDATAENT$strIDCol, Total) %>%
    distinct()

  # combine into one data frame
  data_entry_all <- full_join(data_entry, data_entry_pages, by = "subjectname")

  # read in raw source DM data
  dm_raw_orig <- clindata::rawplus_dm
  dm_raw <- dm_raw_orig

  # join DM and data entry lag counts - full_join() to keep records from both data frames
  expected <- full_join(dm_raw, data_entry_all, by = c("subject_nsv" = "subjectname")) %>%
    mutate(Count = replace_na(Count, 0)) %>%
    filter(Total != 0 | !is.na(Total)) %>% # remove subjects without any data pages
    arrange(!!sym(lMapping$dfSUBJ$strIDCol)) %>%
    select(all_of(cols))


  ########### testing ###########
  expect_equal(as.data.frame(observed), as.data.frame(expected))
})
