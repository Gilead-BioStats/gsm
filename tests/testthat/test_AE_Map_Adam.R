source(testthat::test_path("testdata/data.R"))

# output is created as expected -------------------------------------------
test_that("output is created as expected",{
  data <- AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE))
  expect_true(is.data.frame(data))
  expect_equal(names(data), c("SubjectID","SiteID","Count","Exposure","Rate"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_snapshot(AE_Map_Adam(dfs = list(dfADSL = list(), dfADAE = list()), bQuiet = F))
  expect_snapshot(AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = list()), bQuiet = F))
  expect_snapshot(AE_Map_Adam(dfs = list(dfADSL = list(), dfADAE = dfADAE), bQuiet = F))
  expect_snapshot(AE_Map_Adam(dfs = list(dfADSL = "Hi", dfADAE = "Mom"), bQuiet = F))
  expect_snapshot(AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE, mapping = list()), bQuiet = F))
  expect_snapshot(AE_Map_Adam(dfs = list(dfADSL = dfADSL %>% select(-USUBJID), dfADAE = dfADAE), bQuiet = F))
  expect_snapshot(AE_Map_Adam(dfs = list(dfADSL = dfADSL %>% select(-SITEID), dfADAE = dfADAE), bQuiet = F))
  expect_snapshot(AE_Map_Adam(dfs = list(dfADSL = dfADSL %>% select(-TRTSDT), dfADAE = dfADAE), bQuiet = F))
  expect_snapshot(AE_Map_Adam(dfs = list(dfADSL = dfADSL %>% select(-TRTEDT), dfADAE = dfADAE), bQuiet = F))
  expect_snapshot(AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE %>% select(-USUBJID)), bQuiet = F))
})

# incorrect mappings throw errors -----------------------------------------

# can't test these until mappings are updated in clindata

test_that("incorrect mappings throw errors",{

  expect_null(AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE),
                                    lMapping = list(
    dfADSL = list(strIDCol="not an id",
                  strSiteCol = "SITEID",
                  strStartCol = "TRTSDT",
                  strEndCol = "TRTEDT"),
    dfADAE = list(strIDCol="USUBJID"))))

  expect_null(AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE),
                                   lMapping = list(
    dfADSL = list(strIDCol="USUBJID",
                  strSiteCol = "SITEID",
                  strStartCol = "TRTSDT",
                  strEndCol = "TRTEDT"),
    dfADAE = list(strIDCol="not an id"))))

})

# custom tests ------------------------------------------------------------
test_that("NA values in input data are handled", {
  # NA Site ID, treatment start date, and treatment end date.
  dfExposure1 <- tibble::tribble(
    ~USUBJID, ~SITEID, ~TRTSDT     ,  ~TRTEDT    ,
    1       , NA     , '2021-12-21', '2022-03-20',
    2       , 1      , NA          , '2022-03-20',
    3       , 3      , '2022-12-21', NA          ,
    4       , 2      , '2022-12-21', '2022-03-20'
  ) %>%
  dplyr::mutate(
    dplyr::across(TRTSDT, as.Date),
    dplyr::across(TRTEDT, as.Date)
  )
  dfADAE1 <- tibble::tribble(
    ~USUBJID, 1,1,1,1,2,2,4,4
  )
  mapped1 <- AE_Map_Adam(
    list(dfADAE = dfADAE1, dfADSL = dfExposure1)
  )
  expect_null(mapped1)

  # NA SubjectID in AE domain.
  dfExposure2 <- tibble::tribble(
    ~USUBJID, ~SITEID, ~TRTSDT     ,  ~TRTEDT    ,
    1       , 1      , '2021-12-21', '2022-03-20',
    2       , 1      , '2021-12-21', '2022-03-20',
    3       , 3      , '2022-12-21', '2022-03-20',
    4       , 2      , '2022-12-21', '2022-03-20'
  ) %>%
  dplyr::mutate(
    dplyr::across(TRTSDT, as.Date),
    dplyr::across(TRTEDT, as.Date)
  )
  dfADAE2 <- tibble::tribble(
    ~USUBJID, NA,1,1,1,2,2,4,4
  )
  mapped2 <- AE_Map_Adam(
    list(dfADAE = dfADAE2, dfADSL = dfExposure2)
  )
  expect_null(mapped2)

  # NA SubjectID in SUBJ domain.
  dfExposure3 <- tibble::tribble(
    ~USUBJID, ~SITEID, ~TRTSDT     ,  ~TRTEDT    ,
    NA      , 1      , '2021-12-21', '2022-03-20',
    2       , 1      , '2021-12-21', '2022-03-20',
    3       , 3      , '2022-12-21', '2022-03-20',
    4       , 2      , '2022-12-21', '2022-03-20'
  ) %>%
  dplyr::mutate(
    dplyr::across(TRTSDT, as.Date),
    dplyr::across(TRTEDT, as.Date)
  )
  dfADAE3 <- tibble::tribble(
    ~USUBJID, 1,1,1,1,2,2,4,4
  )
  mapped3 <- AE_Map_Adam(
    list(dfADAE = dfADAE3, dfADSL = dfExposure3)
  )
  expect_null(mapped3)

  #expect_snapshot_error(AE_Map_Raw(dfADAE = dfADAE1, dfADSL = dfExposure1))
  #expect_snapshot_error(AE_Map_Raw(dfADAE = dfADAE2, dfADSL = dfExposure2))
  #expect_snapshot_error(AE_Map_Raw(dfADAE = dfADAE3, dfADSL = dfExposure3))
})
