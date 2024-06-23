test_that("Given appropriate workflow specific output from `Transform_Rate()`, correctly proforms normal approximation statistics using `binary` strType", {
  source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

  ## create dfInputs
  Input_Rate_Results <- map(kri_workflows, function(kri){
    suppressMessages(
      RunStep(lStep = kri$steps[map_lgl(kri$steps, ~.x$name == "Input_Rate")][[1]], lData = lData_mapped, lMeta = kri$meta)
    )
  })

  Transform_Rate_Results <- map(Input_Rate_Results, Transform_Rate)


})
