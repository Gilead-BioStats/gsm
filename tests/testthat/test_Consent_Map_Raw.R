source(testthat::test_path("testdata/data.R"))

mapping <- list(
  dfConsent = list(strIDCol = "SUBJID",
                   strConsentTypeCol = "CONSCAT_STD",
                   strConsentStatusCol = "CONSYN",
                   strConsentDateCol = "CONSDAT"),
  dfRDSL = list(strIDCol = "SubjectID",
                strSiteCol = "SiteID",
                strRandDateCol = "RandDate")
)

# output is created as expected -------------------------------------------
test_that("output created as expected ",{
  data <- Consent_Map_Raw(dfConsent, dfRDSL, strConsentTypeValue = "mainconsent", mapping = NULL)
  expect_true(is.data.frame(data))
  expect_equal(names(data),c("SubjectID","SiteID","Count"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors",{
  expect_snapshot_error(Consent_Map_Raw(list(), list()))
  expect_snapshot_error(Consent_Map_Raw(dfConsent, list()))
  expect_snapshot_error(Consent_Map_Raw(list(), dfRDSL))
  expect_snapshot_error(Consent_Map_Raw("Hi", "Mom"))
  expect_snapshot_error(Consent_Map_Raw(dfConsent, dfRDSL, mapping = list()))
  expect_snapshot_error(Consent_Map_Raw(dfConsent %>% select(-SUBJID), dfRDSL))
  expect_snapshot_error(Consent_Map_Raw(dfConsent %>% select(-CONSCAT_STD), dfRDSL))
  expect_snapshot_error(Consent_Map_Raw(dfConsent %>% select(-CONSYN), dfRDSL))
  expect_snapshot_error(Consent_Map_Raw(dfConsent %>% select(-CONSDAT), dfRDSL))
  expect_snapshot_error(Consent_Map_Raw(dfConsent, dfRDSL %>% select(-SubjectID)))
  expect_snapshot_error(Consent_Map_Raw(dfConsent, dfRDSL %>% select(-SiteID)))
  expect_snapshot_error(Consent_Map_Raw(dfConsent, dfRDSL %>% select(-RandDate)))
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors", {
  expect_snapshot_error(Consent_Map_Raw(dfConsent, dfRDSL, mapping = list(
    dfConsent = list(strIDCol = "not an id",
                     strConsentTypeCol = "CONSCAT_STD",
                     strConsentStatusCol = "CONSYN",
                     strConsentDateCol = "CONSDAT"),
    dfRDSL = list(strIDCol = "SubjectID",
                  strSiteCol = "SiteID",
                  strRandDateCol = "RandDate"))))

  expect_snapshot_error(Consent_Map_Raw(dfConsent, dfRDSL, mapping = list(
    dfConsent = list(strIDCol = "SUBJID",
                     strConsentTypeCol = "CONSCAT_STD",
                     strConsentStatusCol = "CONSYN",
                     strConsentDateCol = "CONSDAT"),
    dfRDSL = list(strIDCol = "not an id",
                  strSiteCol = "SiteID",
                  strRandDateCol = "RandDate"))))
})

# custom tests ------------------------------------------------------------
dfConsent_test_NA1 <- tibble::tribble(~SUBJID, ~CONSCAT_STD , ~CONSYN , ~CONSDAT,
                                      NA,       "MAINCONSENT",    "Yes", "2014-12-25",
                                      1,       "MAINCONSENT",     "No", "2014-12-25"  )

dfRDSL_test_NA1<- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                                  1,  1, "2013-12-25",
                                  2,  2, "2015-12-25")

dfConsent_test_NA2 <- tibble::tribble(~SUBJID, ~CONSCAT_STD , ~CONSYN , ~CONSDAT,
                                      1,       "MAINCONSENT",    "Yes", "2014-12-25",
                                      1,       "MAINCONSENT",     "No", "2014-12-25"  )

dfRDSL_test_NA2<- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                                  NA,  1, "2013-12-25",
                                  2,  2, "2015-12-25")





test_that("NA's in SubjectID and SUBJID are handled correctly",{
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test_NA1, dfRDSL = dfRDSL_test_NA1)))
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test_NA2, dfRDSL = dfRDSL_test_NA2)))
})

test_that("Incorrect strConsentTypeValue throws errors",{
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test, strConsentTypeValue = c("A","B"))))
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test, strConsentTypeValue = 1.23)))
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test, strConsentTypeValue = "Name_Not_in_data")))
})

dfConsent_test2 <- tibble::tribble(~SUBJID, ~CONSCAT_STD , ~CONSYN , ~CONSDAT,
                                   1,         "MAINCONSENT",    "Yes", "2014-12-25",
                                   1,       "MAINCONSENT",     "No", "2014-12-25")

dfRDSL_test2 <- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                                1,  1, "2013-12-25",
                                2,  2, "2015-12-25")


dfInput_test2 <-  tibble::tribble(
  ~SubjectID, ~SiteID, ~Count,
  1,       1,   1,
  1,       1,   1)


test_that("NA's in data are caught and error thrown",{

  dfConsent_test_in <-  dfConsent_test2; dfConsent_test_in[1,2] = NA
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test_in, dfRDSL = dfRDSL_test2)))

  dfConsent_test_in <-  dfConsent_test2; dfConsent_test_in[1,3] = NA
  suppressMessages(expect_error(Consent_Map_Raw(dfConsent = dfConsent_test_in, dfRDSL = dfRDSL_test2)))

  dfRDSL_in <-  dfRDSL_test2; dfRDSL_in[2,2] = NA
  suppressMessages(expect_error(suppressWarnings(Consent_Map_Raw(dfConsent = dfConsent_test2, dfRDSL = dfRDSL_in))))

  dfRDSL_in <-  dfRDSL_test2; dfRDSL_in[2,2] = NA
  suppressMessages(expect_error(Consent_Map_Raw( dfConsent = dfConsent_test2, dfRDSL = dfRDSL_in )))
})
