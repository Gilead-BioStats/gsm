
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

# Add tests for NA values in columns: SubjectID, SiteID, Count
# Add tests for nThreshold

test_that("incorrect inputs throw errors",{
    expect_error(Consent_Assess(list()))
    expect_error(Consent_Assess("Hi"))
    expect_error(Consent_Assess(consent_input, strLabel=123))
    expect_error(Consent_Assess(consent_input, bDataList="Yes"))
    expect_error(Consent_Assess(consent_input, nThreshold = "A"))
    expect_error(Consent_Assess(consent_input, nThreshold = c(1,2)))
})


test_that("incorrect inputs throw errors",{
  expect_error(Consent_Assess(consent_input %>% select(-SubjectID)))
  expect_error(Consent_Assess(consent_input %>% select(-SiteID)))
  expect_error(Consent_Assess(consent_input %>% select(-Count)))
})

consent_summary <- Consent_Assess(consent_input, bDataList=FALSE)




target_output <- tibble::tribble(
  ~Assessment, ~Label, ~SiteID, ~N, ~Score, ~Flag,
  "Main Consent",     "",       1, 1L,      1L,     1,
  "Main Consent",     "",       2, 2L,      1L,     1,
  "Main Consent",     "",       3, 1L,      1L,     1
)

target_output_NA_SiteID <- tibble::tribble(
  ~Assessment, ~Label, ~SiteID, ~N, ~Score, ~Flag,
  "Main Consent",     "",       2, 2L,      1L,     1,
  "Main Consent",     "",       3, 1L,      1L,     1,
  "Main Consent",     "",       NA, 1L,      1L,     1
)

test_that("output is correct given example input",{
  expect_equal(consent_summary,target_output)
})

test_that("NA in dfInput$SubjectID does not affect resulting dfSummary output for Consent_Assess",{
  consent_input_in <- consent_input; consent_input_in[1:2,"SubjectID"] = NA
  consent_summary <- Consent_Assess(consent_input_in, bDataList=FALSE)
  expect_equal(consent_summary,target_output)
})

test_that("NA in dfInput$SiteID results in NA for SiteID in dfSummary output for Consent_Assess",{
  consent_input_in <- consent_input; consent_input_in[1,"SiteID"] = NA
  consent_summary <- Consent_Assess(consent_input_in, bDataList=FALSE)
  expect_equal(consent_summary,target_output_NA_SiteID)
})

test_that("NA in dfInput$Count results in Error for Consent_Assess",{
  consent_input_in <- consent_input; consent_input_in[1,"Count"] = NA
  expect_error(Consent_Assess(consent_input_in))
})






