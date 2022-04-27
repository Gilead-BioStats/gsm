source(testthat::test_path("testdata/data.R"))

# output is created as expected -------------------------------------------
test_that("output created as expected ",{
  data <- Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ))
  expect_true(is.data.frame(data))
  expect_equal(names(data),c("SubjectID","SiteID","Count"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors",{
  expect_snapshot(Consent_Map_Raw(dfs = list(dfCONSENT = list(), dfSUBJ = list()), bQuiet = F))
  expect_snapshot(Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = list()), bQuiet = F))
  expect_snapshot(Consent_Map_Raw(dfs = list(dfCONSENT = list(), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(Consent_Map_Raw(dfs = list(dfCONSENT = "Hi", dfSUBJ = "Mom"), bQuiet = F))
  expect_snapshot(Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ), lMapping = list(), bQuiet = F))
  expect_snapshot(Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT %>% select(-CONSENT_DATE), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT %>% select(-CONSENT_TYPE), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT %>% select(-CONSENT_VALUE), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ %>% select(-SubjectID)), bQuiet = F))
  expect_snapshot(Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ %>% select(-SiteID)), bQuiet = F))
  expect_snapshot(Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ %>% select(-RandDate)), bQuiet = F))
  expect_snapshot(Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = bind_rows(dfSUBJ, head(dfSUBJ, 1))), bQuiet = F))
})



# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors", {
  expect_snapshot(Consent_Map_Raw(
    dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ),
    lMapping = list(dfCONSENT = list(strIDCol = "not an id",
                                      strTypeCol = "CONSENT_TYPE",
                                      strValueCol = "CONSENT_VALUE",
                                      strDateCol = "CONSENT_DATE"),
                     dfSUBJ= list(strIDCol = "SubjectID",
                                  strSiteCol = "SiteID",
                                  strRandDateCol = "RandDate")),
    bQuiet = F
    )
  )

  expect_snapshot(Consent_Map_Raw(
    dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ),
    lMapping = list(dfCONSENT = list(strIDCol = "SubjectID",
                                     strTypeCol = "CONSENT_TYPE",
                                     strValueCol = "CONSENT_VALUE",
                                     strDateCol = "CONSENT_DATE"),
                    dfSUBJ= list(strIDCol = "not an id",
                                 strSiteCol = "SiteID",
                                 strRandDateCol = "RandDate")),
    bQuiet = F
    )
  )
})

# custom tests ------------------------------------------------------------
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
