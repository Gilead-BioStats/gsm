source(testthat::test_path("testdata/data.R"))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  data <- Disp_Map(dfDisp, strCol = "DCREASCD", strReason = "Adverse Event")
  expect_true(is.data.frame(data))
  expect_equal(names(data), c("SubjectID", "SiteID", "DCREASCD", "Count"))
})


# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors",{
  expect_snapshot_error(Disp_Map(list()))
  expect_snapshot_error(Disp_Map("Hi"))
  expect_snapshot_error(Disp_Map(dfDisp %>% select(-DCREASCD)))
  expect_snapshot_error(Disp_Map(dfDisp, strCol = "Hi"))
  expect_snapshot_error(Disp_Map(dfDisp, strCol = "DCREASCD", strReason = list()))
})

# incorrect mappings throw errors -----------------------------------------


# custom tests ------------------------------------------------------------
test_that("strReason = 'any' works as expected", {

  output <- Disp_Map(dfDisp,
                     strCol = "DCREASCD",
                     strReason = "any")

  expect_equal(c("SubjectID", "SiteID", "DCREASCD", "Count"), names(output))

  expect_true(
    nrow(output %>%
           group_by(SubjectID) %>%
           filter(n()>1)) == 0
  )

  expect_equal(0, output %>%
                filter(DCREASCD == "Completed") %>%
                summarize(total = sum(Count)) %>%
                pull(total))

})


test_that("strReason works when set to specific reason", {

  output <- Disp_Map(dfDisp,
                     strCol = "DCREASCD",
                     strReason = "adverse event")

  expect_equal(
    names(output),
    c("SubjectID", "SiteID", "DCREASCD", "Count")
  )

  expect_true(
    nrow(output %>%
           group_by(SubjectID) %>%
           filter(n()>1)) == 0
  )

})


test_that("strReason can't also be in vReasonIgnore", {

  strReason <- "adverse event"
  vReasonIgnore <- "adverse event"

  expect_error(
    Disp_Map(dfDisp,
           strCol = "DCREASCD",
           strReason = strReason,
           vReasonIgnore = vReasonIgnore)
  )

})


test_that("vReasonIgnore works as expected",{

  ignoreAll <- c("Completed", "Adverse Event", "Sponsor Decision", "Death",
    "Withdrew Consent", "Physician Decision", "Protocol Violation",
    "Lost to Follow-up", "I/E Not Met", "Lack of Efficacy")

  ignoreNone <- ""

  ignoreAdverseEvent <- "adverse event"

  expect_equal(
    Disp_Map(dfDisp, strCol = "DCREASCD", strReason = "any", vReasonIgnore = ignoreAll) %>%
      summarize(Sum = sum(Count)) %>%
      pull(Sum),
    0
  )

  expect_equal(
    Disp_Map(dfDisp, strCol = "DCREASCD", strReason = "any", vReasonIgnore = ignoreNone) %>%
      summarize(Sum = sum(Count)) %>%
      pull(Sum),
    4
  )

  expect_equal(
    Disp_Map(dfDisp, strCol = "DCREASCD", strReason = "any", vReasonIgnore = ignoreAdverseEvent) %>%
      filter(DCREASCD == "Adverse Event") %>%
      summarize(Sum = sum(Count)) %>%
      pull(Sum),
    0
  )


})

