dfConsent_test <- tibble::tribble(~SUBJID, ~CONSCAT_STD , ~CONSYN , ~CONSDAT,
                                  1,       "MAINCONSENT",    "Yes", "2014-12-24",
                                  2,       "MAINCONSENT",    "Yes", "2014-12-24",
                                  3,       "MAINCONSENT",    "Yep", "2014-12-24", #Bad CONSYN
                                  4,       "MAINCONSENT",    "No", "2014-12-24", #Bad CONSYN
                                  5,       "MAINCONSENT",    "Yes", "2014-12-25", #consent same as rand
                                  6,       "MAINCONSENT",    "Yes", "2014-12-26", #consent after rand
                                  7,       "NoCONSENT",      "Yes", "2014-12-24" #Wrong consent type
)

dfRDSL_test <- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                               1,  1, "2014-12-25",
                               2,  1, "2014-12-25",
                               3,  1, "2014-12-25",
                               4,  1, "2014-12-25",
                               5,  1, "2014-12-25",
                               6,  1, "2014-12-25",
                               7,  1, "2014-12-25")

dfInput_test <-  tibble::tribble(
  ~SubjectID, ~SiteID, ~Count,
  1,       1,   0,
  2,       1,   0,
  3,       1,   1,
  4,       1,   1,
  5,       1,   1,
  6,       1,   1,
  7,       1,   1
)

test_that("output created as expected and has correct structure",{
  consent_input <- Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test, strConsentTypeValue = "mainconsent", mapping = NULL)
  expect_true(is.data.frame(consent_input))
  expect_equal(
    names(consent_input),
    c("SubjectID","SiteID","Count"))
})

test_that("incorrect inputs throw errors",{
  suppressMessages(expect_error(Consent_Map_Raw(list(), list())))
  suppressMessages(expect_error(Consent_Map_Raw("Hi","Mom")))
})


test_that("incorrect inputs throw errors",{  
  suppressMessages(expect_error( Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = list())))
  suppressMessages(expect_error( Consent_Map_Raw(dfConsent = list(), dfRDSL = dfRDSL_test)))
  suppressMessages(expect_error( Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test, strConsentTypeValue = "mainconsent", mapping = "hi there")))
  suppressMessages(expect_error( Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test, strConsentTypeValue = "mainconsent", mapping = list())))
  suppressMessages(expect_error( Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test, strConsentTypeValue = 1)))
})


test_that("error given if required column not found",{
  suppressMessages(
    expect_error(
      Consent_Map_Raw(
        dfConsent =  dfConsent_test %>% rename(ID = SUBJID),
        dfRDSL = dfRDSL_test
      )
    )
  )
  suppressMessages(
    expect_error(
      Consent_Map_Raw(
        dfConsent_test %>% select(-SUBJID),
        dfRDSL = dfRDSL_test
      )
    )
  )
  suppressMessages(
    expect_error(
      Consent_Map_Raw(
        dfConsent_test %>% select(-INVID) ,
        dfRDSL = dfRDSL_test
      )
    )
  )
  suppressMessages(
    expect_error(
      Consent_Map_Raw(
        dfConsent_test %>% select(-CONSCAT_STD),
        dfRDSL = dfRDSL_test
      )
    )
  )
  suppressMessages(
    expect_error(
      Consent_Map_Raw(
        dfConsent_test %>% select(-CONSYN),
        dfRDSL = dfRDSL_test
      )
    )
  )
  suppressMessages(
    expect_error(
      Consent_Map_Raw(
        dfConsent_test %>% select(-CONSDAT),
        dfRDSL = dfRDSL_test
      )
    )
  )
  suppressMessages(
    expect_error(
      Consent_Map_Raw(
        dfConsent_test,
        dfRDSL = dfRDSL_test %>% select(-SUBJID)
      )
    )
  )
  suppressMessages(
    expect_error(
      Consent_Map_Raw(
        dfConsent_test,
        dfRDSL = dfRDSL_test %>% select(-RGMNDTN)
      )
    )
  )
  suppressMessages(
    expect_error(
      Consent_Map_Raw(
        dfConsent_test,
        dfRDSL = dfRDSL_test %>% select(- SubjectID)
      )
    )
  )
  suppressMessages(
    expect_error(
      Consent_Map_Raw(
        dfConsent_test,
        dfRDSL = dfRDSL_test %>% select(- SiteID)
      )
    )
  )
  suppressMessages(
    expect_error(
      Consent_Map_Raw(
        dfConsent_test,
        dfRDSL = dfRDSL_test %>% select(- RandDate)
      )
    )
  )
})


test_that("output is correct given clindata example input",{
  expect_equal(dfInput_test, Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test))
})

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
