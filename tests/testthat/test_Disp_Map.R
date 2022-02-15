library(safetyData)


df <- dplyr::tribble(
  ~SUBJID, ~SITEID,          ~DCREASCD,
  "00000-1015",   "701",        "Completed",
  "00000-1023",   "701",    "Adverse Event",
  "00000-1028",   "701",        "Completed",
  "00000-1033",   "701", "Sponsor Decision",
  "00000-1034",   "701",        "Completed",
  "00000-1047",   "701",    "Adverse Event",
  "00000-1097",   "701",        "Completed",
  "00000-1111",   "701",    "Adverse Event",
  "00000-1115",   "701",    "Adverse Event",
  "00000-1118",   "701",        "Completed",
  "00000-1130",   "701",        "Completed",
  "00000-1133",   "701",        "Completed",
  "00000-1146",   "701",    "Adverse Event",
  "00000-1148",   "701",        "Completed",
  "00000-1153",   "701",        "Completed",
  "00000-1180",   "701",    "Adverse Event",
  "00000-1181",   "701",    "Adverse Event",
  "00000-1188",   "701",    "Adverse Event",
  "00000-1192",   "701",        "Completed",
  "00000-1203",   "701",        "Completed"
)

expectedOutput <- dplyr::tribble(
  ~SubjectID, ~SiteID,          ~DCREASCD, ~Count,
  "1015",   "701",        "Completed",      0,
  "1023",   "701",    "Adverse Event",      1,
  "1028",   "701",        "Completed",      0,
  "1033",   "701", "Sponsor Decision",      0,
  "1034",   "701",        "Completed",      0,
  "1047",   "701",    "Adverse Event",      1,
  "1097",   "701",        "Completed",      0,
  "1111",   "701",    "Adverse Event",      1,
  "1115",   "701",    "Adverse Event",      1,
  "1118",   "701",        "Completed",      0,
  "1130",   "701",        "Completed",      0,
  "1133",   "701",        "Completed",      0,
  "1146",   "701",    "Adverse Event",      1,
  "1148",   "701",        "Completed",      0,
  "1153",   "701",        "Completed",      0,
  "1180",   "701",    "Adverse Event",      1,
  "1181",   "701",    "Adverse Event",      1,
  "1188",   "701",    "Adverse Event",      1,
  "1192",   "701",        "Completed",      0,
  "1203",   "701",        "Completed",      0
)




test_that("incorrect inputs throw errors",{
  expect_error(Disp_Map(dfDisp = list(),
                        strCol = list(),
                        strReason = list())
               )

  expect_error(Disp_Map(dfDisp = df,
                        strCol = list(),
                        strReason = list())
  )

  expect_error(Disp_Map(dfDisp = df,
                        strCol = "DCREASCD",
                        strReason = list())
  )

  expect_error(Disp_Map(dfDisp = df,
                        strCol = list())
  )

  expect_error(Disp_Map(dfDisp = df,
                        strReason = "any")
  )

  expect_error(Disp_Map(dfDisp = df %>% rename(SSUUBBJJIIDD = SUBJID),
                        strCol = "DCREASCD")
  )

  expect_error(Disp_Map(dfDisp = df %>% rename(SITEID2 = SITEID),
                        strCol = "DCREASCD")
  )


})


test_that("output as expected", {

  output <- Disp_Map(dfDisp = df,
                     strCol = "DCREASCD",
                     strReason = "any")

  testOutput <- Disp_Map(dfDisp = safetyData::adam_adsl, strCol = "DCREASCD", strReason = "adverse event")
  testOutput <- head(testOutput, n = 20)

  expect_equal(
    names(output),
    c("SubjectID", "SiteID", "DCREASCD", "Count")
  )

  expect_true(
    nrow(output %>%
             group_by(SubjectID) %>%
             filter(n()>1)) == 0
  )

  # ignore because tribble does not include label attrs found in
  # expected output
  expect_equal(
    expectedOutput,
    testOutput,
    ignore_attr = TRUE
  )


})
