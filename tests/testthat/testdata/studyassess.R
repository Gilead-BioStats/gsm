source(testthat::test_path("testdata/data.R"))

standardOutput <- Study_Assess(
  lData = lData,
  bQuiet = TRUE
)

saveRDS(standardOutput, testthat::test_path("testdata/studyassess.rda"))
