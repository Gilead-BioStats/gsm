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

snapshot <- Make_Snapshot()

test_that("output is generated as expected", {
  expect_true(is.list(snapshot))
  expect_equal(names(snapshot), c("status_study", "status_site", "status_workflow", "status_param", "status_schedule", "results_summary", "results_bounds", "meta_workflow", "meta_param"))
  expect_equal(names(snapshot$status_study), c("studyid", "enrolled_sites", "enrolled_participants", "planned_sites", "planned_participants", "title", "nickname", "indication", "ta", "phase", "status", "fpfv", "lplv", "rbm_flag"))
  expect_equal(names(snapshot$status_site), c("studyid", "siteid", "institution", "status"))
})





### incorrect input


test_that("bQuiet works as intended", {
  test_logical_assess_parameters(snapshot, dfInput)
})
