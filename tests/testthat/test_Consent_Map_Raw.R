source(testthat::test_path("testdata/data.R"))

mapping <- list(
  dfConsent = list(strIDCol = "SubjectID",
                   strConsentTypeCol = "CONSENT_TYPE",
                   strConsentStatusCol = "CONSENT_VALUE",
                   strConsentDateCol = "CONSENT_DATE"),
  dfSubj = list(strIDCol = "SubjectID",
                strSiteCol = "SiteID",
                strRandDateCol = "RandDate")
)

# output is created as expected -------------------------------------------
test_that("output created as expected ",{
  data <- Consent_Map_Raw(dfConsent, dfSubj, strConsentTypeValue = "MAINCONSENT", mapping = NULL)
  expect_true(is.data.frame(data))
  expect_equal(names(data),c("SubjectID","SiteID","Count"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors",{
  expect_snapshot_error(Consent_Map_Raw(list(), list()))
  expect_snapshot_error(Consent_Map_Raw(dfConsent, list()))
  expect_snapshot_error(Consent_Map_Raw(list(), dfSubj))
  expect_snapshot_error(Consent_Map_Raw("Hi", "Mom"))
  expect_snapshot_error(Consent_Map_Raw(dfConsent, dfSubj, mapping = list()))
  expect_snapshot_error(Consent_Map_Raw(dfConsent %>% select(-SUBJID), dfSubj))
  expect_snapshot_error(Consent_Map_Raw(dfConsent %>% select(-CONSCAT_STD), dfSubj))
  expect_snapshot_error(Consent_Map_Raw(dfConsent %>% select(-CONSYN), dfSubj))
  expect_snapshot_error(Consent_Map_Raw(dfConsent %>% select(-CONSDAT), dfSubj))
  expect_snapshot_error(Consent_Map_Raw(dfConsent, dfSubj %>% select(-SubjectID)))
  expect_snapshot_error(Consent_Map_Raw(dfConsent, dfSubj %>% select(-SiteID)))
  expect_snapshot_error(Consent_Map_Raw(dfConsent, dfSubj %>% select(-RandDate)))
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors", {
  expect_snapshot_error(Consent_Map_Raw(dfConsent, dfSubj, mapping = list(
    dfConsent = list(strIDCol = "not an id",
                     strConsentTypeCol = "CONSENT_TYPE",
                     strConsentStatusCol = "CONSENT_VALUE",
                     strConsentDateCol = "CONSENT_DATE"),
    dfSubj = list(strIDCol = "SubjectID",
                  strSiteCol = "SiteID",
                  strRandDateCol = "RandDate"))))

  expect_snapshot_error(Consent_Map_Raw(dfConsent, dfSubj, mapping = list(
    dfConsent = list(strIDCol = "SubjectID",
                     strConsentTypeCol = "CONSENT_TYPE",
                     strConsentStatusCol = "CONSENT_VALUE",
                     strConsentDateCol = "CONSENT_DATE"),
    dfSubj = list(strIDCol = "not an id",
                  strSiteCol = "SiteID",
                  strRandDateCol = "RandDate"))))
})

# custom tests ------------------------------------------------------------
dfConsent_test_NA1 <- tibble::tribble(~SubjectID, ~CONSENT_TYPE , ~CONSENT_VALUE, ~CONSENT_DATE,
                                      NA,       "MAINCONSENT",    "Yes", "2014-12-25",
                                      1,       "MAINCONSENT",     "No", "2014-12-25"  )

dfSubj_test_NA1<- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                                  1,  1, "2013-12-25",
                                  2,  2, "2015-12-25")

dfConsent_test_NA2 <- tibble::tribble(~SubjectID, ~CONSENT_TYPE , ~CONSENT_VALUE, ~CONSENT_DATE,
                                      1,       "MAINCONSENT",    "Yes", "2014-12-25",
                                      1,       "MAINCONSENT",     "No", "2014-12-25"  )

dfSubj_test_NA2<- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                                  NA,  1, "2013-12-25",
                                  2,  2, "2015-12-25")





test_that("NA's in SubjectID and SUBJID are handled correctly",{
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test_NA1, dfSubj = dfSubj_test_NA1)))
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test_NA2, dfSubj = dfSubj_test_NA2)))
})

test_that("Incorrect strConsentTypeValue throws errors",{
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test, dfSubj = dfSubj_test, strConsentTypeValue = c("A","B"))))
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test, dfSubj = dfSubj_test, strConsentTypeValue = 1.23)))
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test, dfSubj = dfSubj_test, strConsentTypeValue = "Name_Not_in_data")))
})

dfConsent_test2 <- tibble::tribble(~SUBJID, ~CONSENT_TYPE , ~CONSENT_VALUE , ~CONSENT_DATE ,
                                   1,         "MAINCONSENT",    "Yes", "2014-12-25",
                                   1,       "MAINCONSENT",     "No", "2014-12-25")

dfSubj_test2 <- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                                1,  1, "2013-12-25",
                                2,  2, "2015-12-25")


dfInput_test2 <-  tibble::tribble(
  ~SubjectID, ~SiteID, ~Count,
  1,       1,   1,
  1,       1,   1)


test_that("NA's in data are caught and error thrown",{

  dfConsent_test_in <-  dfConsent_test2; dfConsent_test_in[1,2] = NA
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test_in, dfSubj = dfSubj_test2)))

  dfConsent_test_in <-  dfConsent_test2; dfConsent_test_in[1,3] = NA
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test_in, dfSubj = dfSubj_test2)))

  dfSubj_in <-  dfSubj_test2; dfSubj_in[2,2] = NA
  suppressMessages(expect_error(suppressWarnings(Consent_Map_Raw(dfConsent = dfConsent_test2, dfSubj = dfSubj_in))))

  dfSubj_in <-  dfSubj_test2; dfSubj_in[2,2] = NA
  suppressMessages(expect_error(Consent_Map_Raw( dfConsent = dfConsent_test2, dfSubj = dfSubj_in )))
})
