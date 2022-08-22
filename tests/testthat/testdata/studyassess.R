source(testthat::test_path("testdata/data.R"))

standardOutput <- Study_Assess(
  lData = lData,
  bQuiet = TRUE
)

usethis::use_data(standardOutput, overwrite = TRUE)
