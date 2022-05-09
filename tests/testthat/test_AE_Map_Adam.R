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
test_that("NA values in input data are handled",{
  # NA SiteID and TimeOnTreatment.
  dfExposure1 <- tibble::tribble(
    ~USUBJID, ~SITEID, ~TRTSDT, ~TRTEDT,
    1, 1, ,
    2, 1, ,
    3, NA, ,
    4, 2, 
  )
  dfAE1 <- tibble::tribble(
    ~USUBJID, 1,1,1,1,2,2,4,4
  )
  mapped1 <- AE_Map_Adam(
    list(dfADAE = dfAE1, dfADSL = dfExposure1)
  )
  expect_null(mapped1)

  # NA SubjectID in AE domain.
  dfExposure2 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, 20,
    3,   3, 30,
    4,   2, 50
  )
  dfAE2 <- tibble::tribble(
    ~SubjectID, 1,NA,1,1,2,2,4,4
  )
  mapped2 <- AE_Map_Adam(
    list(dfADAE = dfAE2, dfADSL = dfExposure2)
  )
  expect_null(mapped2)

  # NA SubjectID in SUBJ domain.
  dfAE3 <- tibble::tribble(~SubjectID, 1,1,1,1,2,2,4,4)
  dfExposure3 <- tibble::tribble(
    ~USUBJID, ~SITEID, ~TRTSDT, ~TRTEDT,
    NA, 1, ,
    2, 1, ,
    3, 2, ,
    4, 2, 
  )
  mapped3 <- AE_Map_Raw(
    list(dfADAE = dfAE3, dfADSL = dfExposure3)
  )
  expect_null(mapped2)

  #expect_snapshot_error(AE_Map_Raw(dfAE = dfAE1, dfSUBJ = dfExposure1))
  #expect_snapshot_error(AE_Map_Raw(dfAE = dfAE2, dfSUBJ = dfExposure2))
  #expect_snapshot_error(AE_Map_Raw(dfAE = dfAE3, dfSUBJ = dfExposure3))
})
