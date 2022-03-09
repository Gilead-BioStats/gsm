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
  ~SubjectID, ~SiteID,    ~RandDate,  ~CONSCAT_STD, ~CONSYN,     ~CONSDAT, ~flag_noconsent, ~flag_missing_consent, ~flag_missing_rand, ~flag_date_compare, ~any_flag, ~Count,
  1,       1, "2013-12-25", "MAINCONSENT",   "Yes", "2014-12-25",           FALSE,                 FALSE,              FALSE,               TRUE,      TRUE,      1,
  1,       1, "2013-12-25", "MAINCONSENT",    "No", "2014-12-25",            TRUE,                 FALSE,              FALSE,               TRUE,      TRUE,      1,
  1,       1, "2013-12-25", "MAINCONSENT",   "Yes", "2014-12-25",           FALSE,                 FALSE,              FALSE,               TRUE,      TRUE,      1,
  1,       1, "2013-12-25", "MAINCONSENT",   "Yes", "2014-12-25",           FALSE,                 FALSE,              FALSE,               TRUE,      TRUE,      1,
  2,       2, "2015-12-25", "MAINCONSENT",    "No", "2014-12-25",            TRUE,                 FALSE,              FALSE,              FALSE,      TRUE,      1,
  2,       2, "2015-12-25", "MAINCONSENT",   "Yes", "2014-12-25",           FALSE,                 FALSE,              FALSE,              FALSE,     FALSE,      0,
  2,       2, "2015-12-25", "MAINCONSENT",   "Yes", "2014-12-25",           FALSE,                 FALSE,              FALSE,              FALSE,     FALSE,      0,
  3,       2, "2013-12-25", "MAINCONSENT",    "No", "2014-12-25",            TRUE,                 FALSE,              FALSE,               TRUE,      TRUE,      1,
  5,       3, "2013-12-25", "MAINCONSENT",   "Yes", "2014-12-25",           FALSE,                 FALSE,              FALSE,               TRUE,      TRUE,      1
)


test_that("output created as expected and has correct structure",{
  consent_input <-  Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test)
   expect_true(is.data.frame(consent_input))
   expect_equal(
   names(consent_input),
   c("SubjectID", "SiteID", "RandDate", "CONSCAT_STD", "CONSYN",
     "CONSDAT", "flag_noconsent", "flag_missing_consent", "flag_missing_rand",
     "flag_date_compare", "any_flag", "Count"))
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


  expect_error(
    Consent_Map_Raw(
      dfConsent_test,
      dfRDSL = dfRDSL_test %>% select(- SubjectID)
    )
  )

  expect_error(
    Consent_Map_Raw(
      dfConsent_test,
      dfRDSL = dfRDSL_test %>% select(- SiteID)
    )
  )

  expect_error(
    Consent_Map_Raw(
      dfConsent_test,
      dfRDSL = dfRDSL_test %>% select(- RandDate)
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
  expect_error(Consent_Map_Raw(dfConsent = dfConsent_test_NA1, dfRDSL = dfRDSL_test_NA1))
  expect_error(Consent_Map_Raw(dfConsent = dfConsent_test_NA2, dfRDSL = dfRDSL_test_NA2))

})

test_that("Incorrect strConsentReason throws errors",{
  expect_error(Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test, strConsentReason = c("A","B")))
  expect_error(Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test, strConsentReason = 1.23))
  expect_error(Consent_Map_Raw(dfConsent = dfConsent_test, dfRDSL = dfRDSL_test, strConsentReason = "Name_Not_in_data"))

})


dfConsent_test2 <- tibble::tribble(~SUBJID, ~CONSCAT_STD , ~CONSYN , ~CONSDAT,
                                  1,         "MAINCONSENT",    "Yes", "2014-12-25",
                                  1,       "MAINCONSENT",     "No", "2014-12-25")

dfRDSL_test2 <- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                               1,  1, "2013-12-25",
                               2,  2, "2015-12-25")


dfInput_test2 <-  tibble::tribble(
  ~SubjectID, ~SiteID,    ~RandDate,  ~CONSCAT_STD, ~CONSYN,     ~CONSDAT, ~flag_noconsent, ~flag_missing_consent, ~flag_missing_rand, ~flag_date_compare, ~any_flag, ~Count,
  1,       1, "2013-12-25", "MAINCONSENT",   "Yes", "2014-12-25",           FALSE,                 FALSE,              FALSE,               TRUE,      TRUE,      1,
  1,       1, "2013-12-25", "MAINCONSENT",    "No", "2014-12-25",            TRUE,                 FALSE,              FALSE,               TRUE,      TRUE,      1
)

test_that("NA's in data are removed and handled correctly",{
 dfConsent_test_in <-  dfConsent_test2; dfConsent_test_in[1,2] = NA
  expect_equal(
    tibble::tribble(
    ~SubjectID, ~SiteID,    ~RandDate,  ~CONSCAT_STD, ~CONSYN,     ~CONSDAT, ~flag_noconsent, ~flag_missing_consent, ~flag_missing_rand, ~flag_date_compare, ~any_flag, ~Count,
    1,       1, "2013-12-25", "MAINCONSENT",    "No", "2014-12-25",            TRUE,                 FALSE,              FALSE,               TRUE,      TRUE,      1
  ),
  Consent_Map_Raw(dfConsent = dfConsent_test_in, dfRDSL = dfRDSL_test2)
  )

  dfConsent_test_in <-  dfConsent_test2; dfConsent_test_in[1,3] = NA
  expect_equal(
    tibble::tribble(
    ~SubjectID, ~SiteID,    ~RandDate,  ~CONSCAT_STD, ~CONSYN,     ~CONSDAT, ~flag_noconsent, ~flag_missing_consent, ~flag_missing_rand, ~flag_date_compare, ~any_flag, ~Count,
    1,       1, "2013-12-25", "MAINCONSENT",      NA, "2014-12-25",              NA,                 FALSE,              FALSE,               TRUE,      TRUE,      1,
    1,       1, "2013-12-25", "MAINCONSENT",    "No", "2014-12-25",            TRUE,                 FALSE,              FALSE,               TRUE,      TRUE,      1
  ),
  Consent_Map_Raw(dfConsent = dfConsent_test_in, dfRDSL = dfRDSL_test2)
  )

  dfRDSL_in <-  dfRDSL_test2; dfRDSL_in[2,2] = NA
  expect_equal(
    tibble::tribble(
      ~SubjectID, ~SiteID,    ~RandDate,  ~CONSCAT_STD, ~CONSYN,     ~CONSDAT, ~flag_noconsent, ~flag_missing_consent, ~flag_missing_rand, ~flag_date_compare, ~any_flag, ~Count,
      1,       1, "2013-12-25", "MAINCONSENT",   "Yes", "2014-12-25",           FALSE,                 FALSE,              FALSE,               TRUE,      TRUE,      1,
      1,       1, "2013-12-25", "MAINCONSENT",    "No", "2014-12-25",            TRUE,                 FALSE,              FALSE,               TRUE,      TRUE,      1
    ),
    suppressWarnings(Consent_Map_Raw(dfConsent = dfConsent_test2, dfRDSL = dfRDSL_in))
    )



})

test_that("Warning provided for missing (NA) SiteID's in dfRDSL",{
  dfRDSL_in <-  dfRDSL_test2; dfRDSL_in[2,2] = NA
  expect_warning(Consent_Map_Raw( dfConsent = dfConsent_test2, dfRDSL = dfRDSL_in ))
})


