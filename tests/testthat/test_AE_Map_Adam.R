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

