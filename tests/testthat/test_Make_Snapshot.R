lData <- list(
  dfSUBJ = clindata::rawplus_dm[1:50,],
  dfAE = clindata::rawplus_ae[1:50,],
  dfPD = clindata::rawplus_protdev[1:50,],
  dfCONSENT = clindata::rawplus_consent[1:50,],
  dfIE = clindata::rawplus_ie[1:50,],
  dfSTUDCOMP = clindata::rawplus_studcomp[1:50,],
  dfSDRGCOMP = clindata::rawplus_sdrgcomp[1:50,],
  dfLB = clindata::rawplus_lb[1:50,]
)

lMeta <- list(
  config_param = clindata::config_param,
  config_schedule = clindata::config_schedule,
  config_workflow = clindata::config_workflow,
  meta_params = gsm::meta_param,
  meta_site = clindata::ctms_site,
  meta_study = clindata::ctms_study,
  meta_workflow = gsm::meta_workflow
)

lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

lAssessments <- MakeWorkflowList()

snapshot <- Make_Snapshot(lMeta = lMeta, lData = lData, lAssessments = lAssessments) %>%
  suppressWarnings()

tool_outputs <- read.csv(system.file("vignettes", "standardized_outputs.csv", package = "gsm"))
gsm_outputs <- read.csv(system.file("vignettes", "gsm_outputs.csv", package = "gsm"))

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

test_that("input data is structured as expected", {
  expect_true(is.list(lMeta))
  expect_equal(names(lMeta), c("config_param", "config_schedule", "config_workflow", "meta_params", "meta_site", "meta_study", "meta_workflow"))
  expect_equal(names(lMeta$config_param), unique(gsm_outputs$Column.Name[gsm_outputs$Table.Name == "config_param"]))
  expect_equal(names(lMeta$config_schedule), unique(gsm_outputs$Column.Name[gsm_outputs$Table.Name == "config_schedule"]))
  expect_equal(names(lMeta$config_workflow), unique(gsm_outputs$Column.Name[gsm_outputs$Table.Name == "config_workflow"]))
  expect_equal(names(lMeta$meta_params), unique(gsm_outputs$Column.Name[gsm_outputs$Table.Name == "meta_param"]))
  expect_equal(names(lMeta$meta_site), unique(gsm_outputs$Column.Name[gsm_outputs$Table.Name == "meta_site"]))
  expect_equal(names(lMeta$meta_study), unique(gsm_outputs$Column.Name[gsm_outputs$Table.Name == "meta_study"]))
  expect_equal(names(lMeta$meta_workflow), unique(gsm_outputs$Column.Name[gsm_outputs$Table.Name == "meta_workflow"]))
})

test_that("invalid data throw errors", {

  ### lMeta
  expect_error(Make_Snapshot("Hi")[["lMeta"]])

  ### lData
  expect_error(Make_Snapshot("Hola")[["lData"]])

  ### lMapping
  expect_error(Make_Snapshot("Bonjour")[["lMapping"]])

  mapping_edited <- lMapping
  mapping_edited$dfSUBJ$strSiteCol <- "cupcakes"
  expect_error(Make_Snapshot(lMapping = mapping_edited))

  ### lAssessments
  expect_error(Make_Snapshot("Ciao")[["lAssessments"]])
})

# test_that("Make_Snapshot() runs with missing datasets", {
#
#   lMeta <- list(
#     config_schedule = clindata::config_schedule,
#     config_workflow = clindata::config_workflow,
#     meta_params = gsm::meta_param,
#     meta_site = clindata::ctms_site,
#     meta_study = clindata::ctms_study,
#     meta_workflow = gsm::meta_workflow
#   )
#   snapshot <- Make_Snapshot(lMeta = lMeta, lData = lData, lAssessments = lAssessments) %>%
#     suppressWarnings()
# })

test_that("bQuiet works as intended", {
  testthat::expect_snapshot(
    test <- Make_Snapshot(lData = lData, bQuiet = FALSE)
  )
})
