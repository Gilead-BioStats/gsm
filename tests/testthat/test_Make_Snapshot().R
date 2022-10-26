### lMeta
### lData
### lMapping
### lAssessments
### cPath

lMeta <- list(
  config_param = clindata::config_param,
  config_schedule = clindata::config_schedule,
  config_workflow = clindata::config_workflow,
  meta_params = gsm::meta_param,
  meta_site = clindata::ctms_site,
  meta_study = clindata::ctms_study,
  meta_workflow = gsm::meta_workflow
)

lData <- list(
  dfSUBJ = clindata::rawplus_dm[1:50,],
  dfAE = clindata::rawplus_ae[1:50,],
  dfLB = clindata::rawplus_lb[1:50,],
  dfPD = clindata::rawplus_protdev[1:50,],
  dfSTUDCOMP = clindata::rawplus_studcomp[1:50,],
  dfSDRGCOMP = clindata::rawplus_sdrgcomp[1:50,]
)

lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

snapshot <- Make_Snapshot(lData = lData)

tool_outputs <- read.csv(system.file("vignettes", "standardized_outputs.csv", package = "gsm"))

test_that("output is generated as expected", {
  expect_true(is.list(snapshot))
  expect_equal(names(snapshot), c("status_study", "status_site", "status_workflow", "status_param", "status_schedule", "results_summary", "results_bounds", "meta_workflow", "meta_param"))
  expect_equal(names(snapshot$status_study), unique(tool_outputs$Column.Name[tool_outputs$Table.Name == "status_study"]))
  expect_equal(names(snapshot$status_site), unique(tool_outputs$Column.Name[tool_outputs$Table.Name == "status_site"]))
  expect_equal(names(snapshot$status_workflow), unique(tool_outputs$Column.Name[tool_outputs$Table.Name == "status_workflow"]))
  expect_equal(names(snapshot$status_param), unique(tool_outputs$Column.Name[tool_outputs$Table.Name == "status_param"]))
  expect_equal(names(snapshot$status_schedule), unique(tool_outputs$Column.Name[tool_outputs$Table.Name == "status_schedule"]))
  expect_equal(names(snapshot$results_summary), unique(tool_outputs$Column.Name[tool_outputs$Table.Name == "results_summary"]))
  expect_equal(names(snapshot$results_bounds), unique(tool_outputs$Column.Name[tool_outputs$Table.Name == "results_bounds"]))
  expect_equal(names(snapshot$meta_workflow), unique(tool_outputs$Column.Name[tool_outputs$Table.Name == "meta_workflow"]))
  expect_equal(names(snapshot$meta_param), unique(tool_outputs$Column.Name[tool_outputs$Table.Name == "meta_param"]))
})





### incorrect input


test_that("bQuiet works as intended", {
  test_logical_assess_parameters(snapshot, dfInput)
})
