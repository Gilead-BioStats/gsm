test_that("Test that (NA, NaN) in input exposure data throws a warning and drops the participant(s) from the analysis.", {
  dfInput <- gsm::PD_Map_Raw(
    dfPD = clindata::rawplus_pd,
    dfSUBJ = clindata::rawplus_subj
  )

  # data
  # several NA values
  dfInputWithNA1 <- dfInput %>%
    mutate(Exposure = ifelse(substr(SubjectID,4,4) == 1, Exposure, NA_integer_),
           Rate = ifelse(is.na(Exposure), Exposure, NA_integer_))

  # one NA value
  dfInputWithNA2 <- dfInput %>%
    mutate(Exposure = ifelse(SubjectID == "1396", NA_integer_, Exposure),
           Rate = ifelse(is.na(Exposure), Exposure, NA_integer_))

  expect_warning(PD_Assess(dfInputWithNA1))
  expect_warning(PD_Assess(dfInputWithNA2))
})
