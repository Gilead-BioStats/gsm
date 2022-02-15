dfConsent_test <- tibble::tribble(~SUBJID,  ~INVID,  ~CONSCAT_STD , ~CONSYN , ~CONSDAT,
                                  1,       1,  "MAINCONSENT",    "Yes", "2014-12-25",
                                  1,       1,  "MAINCONSENT",    "Yes", "2014-12-25",
                                  1,       1,  "MAINCONSENT",     "No", "2014-12-25",
                                  1,       1,  "MAINCONSENT",    "Yes", "2014-12-25",
                                  1,       1,   "NoNCONSENT",    "Yes", "2014-12-25",
                                  2,       2,  "MAINCONSENT",     "No", "2014-12-25",
                                  2,       2,  "MAINCONSENT",    "Yes", "2014-12-25",
                                  2,       2,  "MAINCONSENT",    "Yes", "2014-12-25",
                                  3,       2,  "MAINCONSENT",     "No", "2014-12-25",
                                  4,       2,   "NonCONSENT",    "Yes", "2014-12-25",
                                  5,       3,  "MAINCONSENT",    "Yes", "2014-12-25"  )

dfIxrsrand_test <- tibble::tribble(~SUBJID, ~RGMNDTN,
                                   1,   "2013-12-25",
                                   2,   "2015-12-25",
                                   3,   "2013-12-25",
                                   4,   "2013-12-25",
                                   5,   "2013-12-25")

dfInput_test <-  tibble::tribble(
  ~SubjectID, ~SiteID, ~Count,
  1,       1,   TRUE,
  1,       1,   TRUE,
  1,       1,   TRUE,
  1,       1,   TRUE,
  2,       2,   TRUE,
  2,       2,  FALSE,
  2,       2,  FALSE,
  3,       2,   TRUE,
  5,       3,   TRUE
)
test_that("output created as expected and has correct structure",{
  consent_input <-  Consent_Map_Raw(dfConsent = dfConsent_test, dfIxrsrand = dfIxrsrand_test)
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
  expect_error( Consent_Map_Raw(dfConsent = dfConsent_test, dfIxrsrand = list()))
  expect_error( Consent_Map_Raw(dfConsent = list(), dfIxrsrand = dfIxrsrand_test))
})


test_that("error given if required column not found",{
  expect_error(
    Consent_Map_Raw( 
     dfConsent =  dfConsent_test %>% rename(ID = SUBJID),
     dfIxrsrand = dfIxrsrand_test
    )
  )
  expect_error(
    Consent_Map_Raw(
      dfConsent_test %>% select(-SUBJID),
    dfIxrsrand = dfIxrsrand_test
    )
  )
  
  expect_error(
    Consent_Map_Raw(
      dfConsent_test %>% select(-INVID) ,
    dfIxrsrand = dfIxrsrand_test
    )
  )
  
  expect_error(
    Consent_Map_Raw(
      dfConsent_test %>% select(-CONSCAT_STD),
      dfIxrsrand = dfIxrsrand_test
    )
  )
  expect_error(
    Consent_Map_Raw(
      dfConsent_test %>% select(-CONSYN),
      dfIxrsrand = dfIxrsrand_test
    )
  )
  
  expect_error(
    Consent_Map_Raw(
      dfConsent_test %>% select(-CONSDAT),
      dfIxrsrand = dfIxrsrand_test
    )
  )
  
  expect_error(
    Consent_Map_Raw(
      dfConsent_test,
      dfIxrsrand = dfIxrsrand_test %>% select(-SUBJID)
    )
  )
  
  expect_error(
    Consent_Map_Raw(
      dfConsent_test,
      dfIxrsrand = dfIxrsrand_test %>% select(-RGMNDTN)
    )
  )
})


test_that("output is correct given clindata example input",{
  

  expect_equal(dfInput_test, Consent_Map_Raw(dfConsent = dfConsent_test, dfIxrsrand = dfIxrsrand_test))

  
  
})


