test_that("Given appropriate data arguments, correctly derive rate.", {
  source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

  Input_Rate_Inputs <- map_df(kri_workflows, function(kri){
    reshape2::melt(kri$steps[map_lgl(kri$steps, ~.x$output == "dfAnalyzed")][[1]]$name)
      }, .id = "workflow")

  Input_Rate_Inputs <- map(kri_workflows, function(kri){
    kri$steps[map_lgl(kri$steps, ~.x$name == "Input_Rate")][[1]]$params
  })

  Input_Rate_Results <- map(kri_workflows, function(kri){
    suppressMessages(
      RunStep(kri$steps[kri$steps$name == "Input_Rate"], lData = lData_mapped, lMeta = kri$meta)
    )
  })

})
