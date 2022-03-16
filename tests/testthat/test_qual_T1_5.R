test_that("Test that (NA, NaN) in input exposure data throws a warning and drops the participant(s) from the analysis.", {
  dfInput <- gsm::AE_Map_Raw(
    dfAE = clindata::raw_ae %>% filter(SUBJID != ""),
    dfRDSL = clindata::rawplus_rdsl %>% filter(!is.na(TimeOnTreatment))
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

  expect_warning(AE_Assess(dfInputWithNA1))
  expect_warning(AE_Assess(dfInputWithNA2))
})
