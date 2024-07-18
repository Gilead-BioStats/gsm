test_that("Given appropriate workflow specific output from `Input_Rate()`, correctly transforms and condenses data down to specified group level", {
  source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

  ## create dfInputs
  Input_Rate_Results <- map(kri_workflows, function(kri){
    suppressMessages(
      RunStep(lStep = kri$steps[map_lgl(kri$steps, ~.x$name == "Input_Rate")][[1]], lData = lData_mapped, lMeta = kri$meta)
    )
  })

  Transform_Rate_Results <- map(Input_Rate_Results, Transform_Rate)

  ## output summarises to proper group level
  expect_true(
    all(
      imap_lgl(Transform_Rate_Results, function(df, kri){
        nrow(df) == nrow(Input_Rate_Results[[kri]] %>% distinct(GroupID))
      })
    )
  )

  ## output correctly outputs metric
  expect_true(
    all(
      imap_lgl(Input_Rate_Results, function(df, name){
        test <- df %>%
          group_by(GroupID) %>%
          summarise(Metric = sum(Numerator, na.rm = TRUE)/sum(Denominator, na.rm = TRUE))
        identical(test, Transform_Rate_Results[[name]] %>% select("GroupID", "Metric"))
      })
    )
  )


})
