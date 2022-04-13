source(testthat::test_path("testdata/data.R"))

mapping <- list(
  dfCONSENT = list(strIDCol = "SubjectID",
                   strTypeCol = "CONSENT_TYPE",
                   strValueCol = "CONSENT_VALUE",
                   strDateCol = "CONSENT_DATE"),
  dfSUBJ = list(strIDCol = "SubjectID",
                strSiteCol = "SiteID",
                strRandDateCol = "RandDate")
)

# output is created as expected -------------------------------------------
test_that("output created as expected ",{
  data <- Consent_Map_Raw(dfCONSENT, dfSUBJ, strConsentTypeValue = "MAINCONSENT", mapping = NULL)
  expect_true(is.data.frame(data))
  expect_equal(names(data),c("SubjectID","SiteID","Count"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors",{
  expect_snapshot_error(Consent_Map_Raw(list(), list()))
  expect_snapshot_error(Consent_Map_Raw(dfCONSENT, list()))
  expect_snapshot_error(Consent_Map_Raw(list(), dfSUBJ))
  expect_snapshot_error(Consent_Map_Raw("Hi", "Mom"))
  expect_snapshot_error(Consent_Map_Raw(dfCONSENT, dfSUBJ, mapping = list()))
  expect_snapshot_error(Consent_Map_Raw(dfCONSENT %>% select(-CONSENT_DATE), dfSUBJ))
  expect_snapshot_error(Consent_Map_Raw(dfCONSENT %>% select(-CONSENT_TYPE), dfSUBJ))
  expect_snapshot_error(Consent_Map_Raw(dfCONSENT %>% select(-CONSENT_VALUE), dfSUBJ))
  expect_snapshot_error(Consent_Map_Raw(dfCONSENT, dfSUBJ %>% select(-SubjectID)))
  expect_snapshot_error(Consent_Map_Raw(dfCONSENT, dfSUBJ %>% select(-SiteID)))
  expect_snapshot_error(Consent_Map_Raw(dfCONSENT, dfSUBJ %>% select(-RandDate)))
  expect_snapshot_error(Consent_Map_Raw(dfCONSENT, bind_rows(dfSUBJ, head(dfSUBJ, 1))))
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors", {
  expect_snapshot_error(Consent_Map_Raw(dfCONSENT, dfSUBJ, mapping = list(
    dfCONSENT = list(strIDCol = "not an id",
                     strTypeCol = "CONSENT_TYPE",
                     strValueCol = "CONSENT_VALUE",
                     strDateCol = "CONSENT_DATE"),
    dfSUBJ = list(strIDCol = "SubjectID",
                  strSiteCol = "SiteID",
                  strRandDateCol = "RandDate"))))

  expect_snapshot_error(Consent_Map_Raw(dfCONSENT, dfSUBJ, mapping = list(
    dfCONSENT = list(strIDCol = "SubjectID",
                     strTypeCol = "CONSENT_TYPE",
                     strValueCol = "CONSENT_VALUE",
                     strDateCol = "CONSENT_DATE"),
    dfSUBJ = list(strIDCol = "not an id",
                  strSiteCol = "SiteID",
                  strRandDateCol = "RandDate"))))
})

# custom tests ------------------------------------------------------------
dfCONSENT_test_NA1 <- tibble::tribble(~SubjectID, ~CONSENT_TYPE , ~CONSENT_VALUE, ~CONSENT_DATE,
                                      NA,       "MAINCONSENT",    "Yes", "2014-12-25",
                                      1,       "MAINCONSENT",     "No", "2014-12-25"  )

dfSUBJ_test_NA1<- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                                  1,  1, "2013-12-25",
                                  2,  2, "2015-12-25")

dfCONSENT_test_NA2 <- tibble::tribble(~SubjectID, ~CONSENT_TYPE , ~CONSENT_VALUE, ~CONSENT_DATE,
                                      1,       "MAINCONSENT",    "Yes", "2014-12-25",
                                      1,       "MAINCONSENT",     "No", "2014-12-25"  )

dfSUBJ_test_NA2<- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                                  NA,  1, "2013-12-25",
                                  2,  2, "2015-12-25")





test_that("NA's in SubjectID and SUBJID are handled correctly",{
  suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test_NA1, dfSUBJ = dfSUBJ_test_NA1)))
  suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test_NA2, dfSUBJ = dfSUBJ_test_NA2)))
})

test_that("Incorrect strConsentTypeValue throws errors",{
  suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test, dfSUBJ = dfSUBJ_test, strConsentTypeValue = c("A","B"))))
  suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test, dfSUBJ = dfSUBJ_test, strConsentTypeValue = 1.23)))
  suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test, dfSUBJ = dfSUBJ_test, strConsentTypeValue = "Name_Not_in_data")))
})

dfCONSENT_test2 <- tibble::tribble(~SUBJID, ~CONSENT_TYPE , ~CONSENT_VALUE , ~CONSENT_DATE ,
                                   1,         "MAINCONSENT",    "Yes", "2014-12-25",
                                   1,       "MAINCONSENT",     "No", "2014-12-25")

dfSUBJ_test2 <- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                                1,  1, "2013-12-25",
                                2,  2, "2015-12-25")


dfInput_test2 <-  tibble::tribble(
  ~SubjectID, ~SiteID, ~Count,
  1,       1,   1,
  1,       1,   1)


test_that("NA's in data are caught and error thrown",{

  dfCONSENT_test_in <-  dfCONSENT_test2; dfCONSENT_test_in[1,2] = NA
  suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test_in, dfSUBJ = dfSUBJ_test2)))

  dfCONSENT_test_in <-  dfCONSENT_test2; dfCONSENT_test_in[1,3] = NA
  suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test_in, dfSUBJ = dfSUBJ_test2)))

  dfSUBJ_in <-  dfSUBJ_test2; dfSUBJ_in[2,2] = NA
  suppressMessages(expect_error(suppressWarnings(Consent_Map_Raw(dfCONSENT = dfCONSENT_test2, dfSUBJ = dfSUBJ_in))))

  dfSUBJ_in <-  dfSUBJ_test2; dfSUBJ_in[2,2] = NA
  suppressMessages(expect_error(Consent_Map_Raw( dfCONSENT = dfCONSENT_test2, dfSUBJ = dfSUBJ_in )))
})
