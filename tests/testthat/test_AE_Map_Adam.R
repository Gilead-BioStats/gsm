source(testthat::test_path("testdata/data.R"))

mapping <- list(
  dfADSL = list(strIDCol="USUBJID",
                strSiteCol = "SITEID",
                strStartCol = "TRTSDT",
                strEndCol = "TRTEDT"),
  dfADAE = list(strIDCol="USUBJID")
)


# output is created as expected -------------------------------------------
test_that("output is created as expected",{
  data <- AE_Map_Adam(dfADSL, dfADAE)
  expect_true(is.data.frame(data))
  expect_equal(names(data), c("SubjectID","SiteID","Count","Exposure","Rate"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_snapshot_error(AE_Map_Adam(list(), list()))
  expect_snapshot_error(AE_Map_Adam(dfADSL, list()))
  expect_snapshot_error(AE_Map_Adam(list(), dfADAE))
  expect_snapshot_error(AE_Map_Adam("Hi", "Mom"))
  expect_snapshot_error(AE_Map_Adam(dfADSL, dfADAE, mapping = list()))
  expect_snapshot_error(AE_Map_Adam(dfADSL %>% select(-USUBJID), dfADAE))
  expect_snapshot_error(AE_Map_Adam(dfADSL %>% select(-SITEID), dfADAE))
  expect_snapshot_error(AE_Map_Adam(dfADSL %>% select(-TRTSDT), dfADAE))
  expect_snapshot_error(AE_Map_Adam(dfADSL %>% select(-TRTEDT), dfADAE))
  expect_snapshot_error(AE_Map_Adam(dfADSL, dfADAE %>% select(-USUBJID)))

})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors",{

  expect_snapshot_error(AE_Map_Adam(dfADSL, dfADAE, mapping = list(
    dfADSL = list(strIDCol="not an id",
                  strSiteCol = "SITEID",
                  strStartCol = "TRTSDT",
                  strEndCol = "TRTEDT"),
    dfADAE = list(strIDCol="USUBJID"))))

  expect_snapshot_error(AE_Map_Raw(dfADSL, dfADAE, mapping = list(
    dfADSL = list(strIDCol="USUBJID",
                  strSiteCol = "SITEID",
                  strStartCol = "TRTSDT",
                  strEndCol = "TRTEDT"),
    dfADAE = list(strIDCol="not an id"))))
})

# custom tests ------------------------------------------------------------

