
dfConsent <- tibble::tribble(~SUBJID,  ~INVID,  ~CONSCAT_STD , ~CONSYN , ~CONSDAT,
                            1,       1,  "MAINCONSENT",    "Yes", "2014-12-25",
                            2,       2,  "MAINCONSENT",    "Yes", "2014-12-25",
                            3,       2,  "MAINCONSENT",     "No", "2014-12-25",
                            4,       2,   "NonCONSENT",    "Yes", "2014-12-25",
                            5,       3,  "MAINCONSENT",    "Yes", "2014-12-25"  )

dfRDSL_test <- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                                   1,  1, "2013-12-25",
                                   2,  2, "2015-12-25",
                                   3,  2, "2013-12-25",
                                   4,  3, "2013-12-25",
                                   5,  3, "2013-12-25")

consent_input <-  Consent_Map_Raw(dfConsent = dfConsent, dfRDSL= dfRDSL_test)

test_that("summary df created as expected and has correct structure",{
    consent_list <- Consent_Assess(consent_input) 
    expect_true(is.data.frame(consent_list))
    expect_equal(names(consent_list),c("Assessment","Label", "SiteID", "N", "Score", "Flag"))
})

test_that("list of df created when bDataList=TRUE",{
    consent_list <- Consent_Assess(consent_input, bDataList=TRUE)
    expect_true(is.list(consent_list))
    expect_equal(names(consent_list),c('dfInput','dfTransformed','dfAnalyzed','dfFlagged','dfSummary'))
})

test_that("incorrect inputs throw errors",{
    expect_error(Consent_Assess(list()))
    expect_error(Consent_Assess("Hi"))
    expect_error(Consent_Assess(consent_input, cLabel=123))
    expect_error(Consent_Assess(consent_input, cMethod="abacus"))
    expect_error(Consent_Assess(consent_input, bDataList="Yes"))
})


test_that("incorrect inputs throw errors",{
  expect_error(Consent_Assess(consent_input %>% select(-SubjectID)))
  expect_error(Consent_Assess(consent_input %>% select(-SiteID)))
  expect_error(Consent_Assess(consent_input %>% select(-Count)))
})

consent_summary <- Consent_Assess(consent_input, bDataList=FALSE)




target_output <- tibble::tribble(
  ~Assessment, ~Label, ~SiteID, ~N, ~Score, ~Flag,
  "Main Consent",     "",       1, 1L,      NA,     1,
  "Main Consent",     "",       2, 2L,      NA,     1,
  "Main Consent",     "",       3, 1L,      NA,     1
)

test_that("output is correct given example input",{
  expect_equal(consent_summary,target_output)
})






