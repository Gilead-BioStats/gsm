dfConsent_test <- tibble::tribble(~SUBJID, ~CONSCAT_STD , ~CONSYN , ~CONSDAT,
                                  1,       "MAINCONSENT",    "Yes", "2014-12-25",
                                  1,       "MAINCONSENT",     "No", "2014-12-25",
                                  1,       "MAINCONSENT",    "Yes", "2014-12-25",
                                  1,       "MAINCONSENT",    "Yes", "2014-12-25",
                                  1,        "NoNCONSENT",    "Yes", "2014-12-25",
                                  2,       "MAINCONSENT",     "No", "2014-12-25",
                                  2,       "MAINCONSENT",    "Yes", "2014-12-25",
                                  2,       "MAINCONSENT",    "Yes", "2014-12-25",
                                  3,       "MAINCONSENT",     "No", "2014-12-25",
                                  4,        "NonCONSENT",    "Yes", "2014-12-25",
                                  5,       "MAINCONSENT",    "Yes", "2014-12-25"  )

dfRDSL_test <- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                                   1,  1, "2013-12-25",
                                   2,  2, "2015-12-25",
                                   3,  2, "2013-12-25",
                                   4,  3, "2013-12-25",
                                   5,  3, "2013-12-25")



dfInput_test <-  tibble::tribble(
  ~SubjectID, ~SiteID, ~Count,
  1,       1,   1,
  1,       1,   1,
  1,       1,   1,
  1,       1,   1,
  2,       2,   1,
  2,       2,   0,
  2,       2,   0,
  3,       2,   1,
  5,       3,   1)


test_that("output created as expected and has correct structure",{
  consent_input <-  Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test)
   expect_true(is.data.frame(consent_input))
   expect_equal(
   names(consent_input),
   c("SubjectID","SiteID","Count"))
 })

test_that("incorrect inputs throw errors",{
    expect_error(Consent_Map_Raw(list(), list()))
    expect_error(Consent_Map_Raw("Hi","Mom"))
})


test_that("incorrect inputs throw errors",{
  expect_error( Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = list()))
  expect_error( Consent_Map_Raw(dfConsent = list(), dfRDSL = dfRDSL_test))
})


test_that("error given if required column not found",{
  expect_error(
    Consent_Map_Raw( 
      dfConsent =  dfConsent_test %>% rename(ID = SUBJID),
      dfRDSL = dfRDSL_test
    )
  )
  expect_error(
    Consent_Map_Raw(
      dfConsent_test %>% select(-SUBJID),
    dfRDSL = dfRDSL_test
    )
  )
  
  expect_error(
    Consent_Map_Raw(
      dfConsent_test %>% select(-INVID) ,
    dfRDSL = dfRDSL_test
    )
  )
  
  expect_error(
    Consent_Map_Raw(
      dfConsent_test %>% select(-CONSCAT_STD),
      dfRDSL = dfRDSL_test
    )
  )
  expect_error(
    Consent_Map_Raw(
      dfConsent_test %>% select(-CONSYN),
      dfRDSL = dfRDSL_test
    )
  )
  
  expect_error(
    Consent_Map_Raw(
      dfConsent_test %>% select(-CONSDAT),
      dfRDSL = dfRDSL_test
    )
  )
  
  expect_error(
    Consent_Map_Raw(
      dfConsent_test,
      dfRDSL = dfRDSL_test %>% select(-SUBJID)
    )
  )
  
  expect_error(
    Consent_Map_Raw(
      dfConsent_test,
      dfRDSL = dfRDSL_test %>% select(-RGMNDTN)
    )
  )
})


test_that("output is correct given clindata example input",{
  

  expect_equal(dfInput_test, Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test))

  
  
})


