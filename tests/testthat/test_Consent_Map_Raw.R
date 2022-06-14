source(testthat::test_path("testdata/data.R"))
input_spec <- yaml::read_yaml(paste0(here::here(), '/inst/specs/Consent_Map_Raw.yaml'))
output_mapping <- yaml::read_yaml(paste0(here::here(), '/inst/mappings/Consent_Assess.yaml'))

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
    test_incorrect_inputs(
        Consent_Map_Raw,
        dfCONSENT,
        'dfCONSENT',
        dfSUBJ,
        input_spec
    )
})

# output is created as expected -------------------------------------------
test_that("output created as expected ", {
    test_correct_output(
        Consent_Map_Raw,
        dfCONSENT,
        'dfCONSENT',
        dfSUBJ,
        output_mapping
    )
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors", {
  expect_snapshot(Consent_Map_Raw(
    dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ),
    lMapping = list(
      dfCONSENT = list(
        strIDCol = "not an id",
        strTypeCol = "CONSENT_TYPE",
        strValueCol = "CONSENT_VALUE",
        strDateCol = "CONSENT_DATE"
      ),
      dfSUBJ = list(
        strIDCol = "SubjectID",
        strSiteCol = "SiteID",
        strRandDateCol = "RandDate"
      )
    ),
    bQuiet = F
  ))

  expect_snapshot(Consent_Map_Raw(
    dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ),
    lMapping = list(
      dfCONSENT = list(
        strIDCol = "SubjectID",
        strTypeCol = "CONSENT_TYPE",
        strValueCol = "CONSENT_VALUE",
        strDateCol = "CONSENT_DATE"
      ),
      dfSUBJ = list(
        strIDCol = "not an id",
        strSiteCol = "SiteID",
        strRandDateCol = "RandDate"
      )
    ),
    bQuiet = F
  ))
})

# custom tests ------------------------------------------------------------
test_that("NA values in input data are handled", {
  # NA SiteID and TimeOnTreatment.
  dfCONSENT1 <- tibble::tribble(
    ~SubjectID, 1, 1, 1, 1, 2, 2, 4, 4
  )
  dfExposure1 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1, 1, 10,
    2, 1, NA,
    3, NA, 30,
    4, 2, 50
  )
  mapped1 <- Consent_Map_Raw(
    list(dfCONSENT = dfCONSENT1, dfSUBJ = dfExposure1)
  )
  expect_null(mapped1)

  # NA SubjectID in Consent domain.
  dfCONSENT2 <- tibble::tribble(
    ~SubjectID, 1, NA, 1, 1, 2, 2, 4, 4
  )
  dfExposure2 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1, 1, 10,
    2, 1, 20,
    3, 3, 30,
    4, 2, 50
  )
  mapped2 <- Consent_Map_Raw(
    list(dfCONSENT = dfCONSENT2, dfSUBJ = dfExposure2)
  )
  expect_null(mapped2)

  # NA SubjectID in SUBJ domain.
  dfCONSENT3 <- tibble::tribble(
    ~SubjectID, 1, 1, 1, 1, 2, 2, 4, 4
  )
  dfExposure3 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    NA, 1, 10,
    2, 1, 20,
    3, 2, 30,
    4, 2, 50
  )
  mapped3 <- Consent_Map_Raw(
    list(dfCONSENT = dfCONSENT3, dfSUBJ = dfExposure3)
  )
  expect_null(mapped3)
})

test_that("bQuiet works as intended", {
  expect_message(
    Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ), bQuiet = FALSE)
  )
})

test_that("bReturnChecks works as intended", {
  expect_true(
    all(names(Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ), bReturnChecks = TRUE)) == c("df", "lChecks"))
  )
})
# dfCONSENT_test_NA1 <- tibble::tribble(~SubjectID, ~CONSENT_TYPE , ~CONSENT_VALUE, ~CONSENT_DATE,
#                                       NA,       "MAINCONSENT",    "Yes", "2014-12-25",
#                                       1,       "MAINCONSENT",     "No", "2014-12-25"  )
#
# dfSUBJ_test_NA1<- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
#                                   1,  1, "2013-12-25",
#                                   2,  2, "2015-12-25")
#
# dfCONSENT_test_NA2 <- tibble::tribble(~SubjectID, ~CONSENT_TYPE , ~CONSENT_VALUE, ~CONSENT_DATE,
#                                       1,       "MAINCONSENT",    "Yes", "2014-12-25",
#                                       1,       "MAINCONSENT",     "No", "2014-12-25"  )
#
# dfSUBJ_test_NA2<- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
#                                   NA,  1, "2013-12-25",
#                                   2,  2, "2015-12-25")
#
#
#
#
#
# test_that("NA's in SubjectID and SUBJID are handled correctly",{
#   suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test_NA1, dfSUBJ = dfSUBJ_test_NA1)))
#   suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test_NA2, dfSUBJ = dfSUBJ_test_NA2)))
# })
#
# test_that("Incorrect strConsentTypeValue throws errors",{
#   suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test, dfSUBJ = dfSUBJ_test, strConsentTypeValue = c("A","B"))))
#   suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test, dfSUBJ = dfSUBJ_test, strConsentTypeValue = 1.23)))
#   suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test, dfSUBJ = dfSUBJ_test, strConsentTypeValue = "Name_Not_in_data")))
# })
#
# dfCONSENT_test2 <- tibble::tribble(~SUBJID, ~CONSENT_TYPE , ~CONSENT_VALUE , ~CONSENT_DATE ,
#                                    1,         "MAINCONSENT",    "Yes", "2014-12-25",
#                                    1,       "MAINCONSENT",     "No", "2014-12-25")
#
# dfSUBJ_test2 <- tibble::tribble(~SubjectID, ~SiteID, ~RandDate,
#                                 1,  1, "2013-12-25",
#                                 2,  2, "2015-12-25")
#
#
# dfInput_test2 <-  tibble::tribble(
#   ~SubjectID, ~SiteID, ~Count,
#   1,       1,   1,
#   1,       1,   1)
#
#
# test_that("NA's in data are caught and error thrown",{
#
#   dfCONSENT_test_in <-  dfCONSENT_test2; dfCONSENT_test_in[1,2] = NA
#   suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test_in, dfSUBJ = dfSUBJ_test2)))
#
#   dfCONSENT_test_in <-  dfCONSENT_test2; dfCONSENT_test_in[1,3] = NA
#   suppressMessages(expect_error(Consent_Map_Raw(dfCONSENT = dfCONSENT_test_in, dfSUBJ = dfSUBJ_test2)))
#
#   dfSUBJ_in <-  dfSUBJ_test2; dfSUBJ_in[2,2] = NA
#   suppressMessages(expect_error(suppressWarnings(Consent_Map_Raw(dfCONSENT = dfCONSENT_test2, dfSUBJ = dfSUBJ_in))))
#
#   dfSUBJ_in <-  dfSUBJ_test2; dfSUBJ_in[2,2] = NA
#   suppressMessages(expect_error(Consent_Map_Raw( dfCONSENT = dfCONSENT_test2, dfSUBJ = dfSUBJ_in )))
# })
