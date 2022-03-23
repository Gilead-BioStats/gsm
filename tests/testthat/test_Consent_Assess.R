
dfConsent <- tibble::tribble(~SUBJID,  ~INVID,  ~CONSCAT_STD , ~CONSYN , ~CONSDAT,
                            1,       1,  "MAINCONSENT",    "Yes", "2014-12-24",
                            2,       2,  "MAINCONSENT",    "Yes", "2014-12-25",
                            3,       2,  "MAINCONSENT",     "No", "2014-12-24",
                            4,       2,   "NonCONSENT",    "Yes", "2014-12-24",
                            5,       3,  "MAINCONSENT",    "Yes", "2014-12-24"  )

dfRDSL_test <- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
                                   1,  1, "2014-12-25",
                                   2,  2, "2014-12-25",
                                   3,  2, "2014-12-25",
                                   4,  3, "2014-12-25",
                                   5,  3, "2014-12-25")

consent_input <-  Consent_Map_Raw(dfConsent = dfConsent, dfRDSL= dfRDSL_test, strConsentTypeValue = "MAINCONSENT")

test_that("output is created as expected",{
    consent_list <- Consent_Assess(consent_input)
    expect_true(is.list(consent_list))
    expect_equal(names(consent_list),c("strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary"))
    expect_true("data.frame" %in% class(consent_list$dfInput))
    expect_true("data.frame" %in% class(consent_list$dfTransformed))
    expect_true("data.frame" %in% class(consent_list$dfAnalyzed))
    expect_true("data.frame" %in% class(consent_list$dfFlagged))
    expect_true("data.frame" %in% class(consent_list$dfSummary))
    expect_type(consent_list$strFunctionName, "character")
    expect_type(consent_list$lParams, "list")
})


test_that("correct function and params are returned", {
  consent_assessment <- Consent_Assess(consent_input, nThreshold = 0.6)
  expect_equal("Consent_Assess()", consent_assessment$strFunctionName)
  expect_equal("0.6", consent_assessment$lParams$nThreshold)
})


# Add tests for NA values in columns: SubjectID, SiteID, Count
# Add tests for nThreshold

test_that("incorrect inputs throw errors",{
    expect_error(Consent_Assess(list()))
    expect_error(Consent_Assess("Hi"))
    expect_error(Consent_Assess(consent_input, nThreshold = "A"))
    expect_error(Consent_Assess(consent_input, nThreshold = c(1,2)))
})

test_that("invalid lTags throw errors",{
    expect_error(Consent_Assess(consent_input, lTags="hi mom"))
    expect_error(Consent_Assess(consent_input, lTags=list("hi","mom")))
    expect_error(Consent_Assess(consent_input, lTags=list(greeting="hi","mom")))
    expect_silent(Consent_Assess(consent_input, lTags=list(greeting="hi",person="mom")))
})

test_that("incorrect inputs throw errors",{
  expect_error(Consent_Assess(consent_input %>% select(-SubjectID)))
  expect_error(Consent_Assess(consent_input %>% select(-SiteID)))
  expect_error(Consent_Assess(consent_input %>% select(-Count)))
})

consent_summary <- Consent_Assess(consent_input)

target_output <- tibble::tribble(
  ~SiteID, ~N, ~Score, ~Flag, ~Assessment,
  2,       2L,      2L,     1, "Consent",
  3,       2L,      1L,     1, "Consent",
  1,       1L,      0L,     0, "Consent"
)

test_that("output is correct given example input",{
  expect_equal(consent_summary$dfSummary,target_output)
})

# TODO: These should all throw errors after refactor is complete.
# target_output_NA_SiteID <- tibble::tribble(
#   ~Assessment, ~Label, ~SiteID, ~N, ~Score, ~Flag,
#   "Main Consent",     "",       2, 2L,      1L,     1,
#   "Main Consent",     "",       3, 1L,      1L,     1,
#   "Main Consent",     "",       NA, 1L,      1L,     1
# )
# test_that("NA in dfInput$SubjectID does not affect resulting dfSummary output for Consent_Assess",{
#   consent_input_in <- consent_input
#   consent_input_in[1:2,"SubjectID"] = NA
#   consent_summary <- Consent_Assess(consent_input_in)
#   expect_equal(consent_summary$dfSummary,target_output)
# })

# test_that("NA in dfInput$SiteID results in NA for SiteID in dfSummary output for Consent_Assess",{
#   consent_input_in <- consent_input
#   consent_input_in[1,"SiteID"] = NA
#   consent_summary <- Consent_Assess(consent_input_in)
#   expect_equal(consent_summary$dfSummary,target_output_NA_SiteID)
# })

# test_that("NA in dfInput$Count results in Error for Consent_Assess",{
#   consent_input_in <- consent_input; consent_input_in[1,"Count"] = NA
#   expect_error(Consent_Assess(consent_input_in))
# })


test_that("problematic lTags names are caught", {

  expect_error(
    Consent_Assess(consent_input, lTags = list(SiteID = "")),
    "lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'"
  )

  expect_error(
    Consent_Assess(consent_input, lTags = list(N = "")),
    "lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'"
  )

  expect_error(
    Consent_Assess(consent_input, lTags = list(Score = "")),
    "lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'"
  )

  expect_error(
    Consent_Assess(consent_input, lTags = list(Flag = "")),
    "lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'"
  )

})



