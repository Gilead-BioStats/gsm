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
  dfPD = clindata::rawplus_protdev[1:50,],
  dfCONSENT = clindata::rawplus_consent[1:50,],
  dfIE = clindata::rawplus_ie[1:50,],
  dfSTUDCOMP = clindata::rawplus_studcomp[1:50,],
  dfSDRGCOMP = clindata::rawplus_sdrgcomp[1:50,],
  dfLB = clindata::rawplus_lb[1:50,]
)

lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

lAssessments <- MakeWorkflowList()

cPath <- NULL

bQuiet <- TRUE

snapshot <- Make_Snapshot(lMeta = lMeta, lData = lData, lMapping = lMapping, lAssessments = lAssessments)

tool_outputs <- read.csv(system.file("/standardized_outputs.csv", package = "gsm"))
gsm_outputs <- read.csv(system.file("/gsm_outputs.csv", package = "gsm"))

################################################################################################################

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

################################################################################################################

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

################################################################################################################

test_that("invalid data throw errors", {


  ### lMeta - testing lMeta equal to character string and missing config_param
  expect_error(Make_Snapshot("Hi")[["lMeta"]])

  lMeta_edited <- list(
    config_schedule = clindata::config_schedule,
    config_workflow = clindata::config_workflow,
    meta_params = gsm::meta_param,
    meta_site = clindata::ctms_site,
    meta_study = clindata::ctms_study,
    meta_workflow = gsm::meta_workflow
  )
  expect_error(Make_Snapshot(lMeta = lMeta_edited, lData = lData, lMapping = lMapping, lAssessments = lAssessments))


  ### lData - testing lData equal to character string and missing dfSUBJ
  expect_error(Make_Snapshot("Hola")[["lData"]])

  lData_edited <- list(
    dfAE = clindata::rawplus_ae[1:50,],
    dfPD = clindata::rawplus_protdev[1:50,],
    dfCONSENT = clindata::rawplus_consent[1:50,],
    dfIE = clindata::rawplus_ie[1:50,],
    dfSTUDCOMP = clindata::rawplus_studcomp[1:50,],
    dfSDRGCOMP = clindata::rawplus_sdrgcomp[1:50,],
    dfLB = clindata::rawplus_lb[1:50,]
  )
  expect_error(Make_Snapshot(lMeta = lMeta, lData = lData_edited, lMapping = lMapping, lAssessments = lAssessments))


  ### lMapping - testing lMapping equal to character string and with mislabeled siteID in dfSUBJ
  expect_error(Make_Snapshot("Bonjour")[["lMapping"]])

  lMapping_edited <- lMapping
  lMapping_edited$dfSUBJ$strSiteCol <- "cupcakes"
  expect_error(Make_Snapshot(lMeta = lMeta, lData = lData, lMapping = lMapping_edited, lAssessments = lAssessments))


  ### lAssessments - testing lAssessments equal to character string and with invalid YAML specs
  expect_error(Make_Snapshot("Ciao")[["lAssessments"]])

  lAssessments_edited <- list(
    yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
    yaml::read_yaml(system.file("mappings", "mapping_adam.yaml", package = "gsm"))
  )
  expect_error(Make_Snapshot(lMeta = lMeta, lData = lData, lMapping = lMapping, lAssessments = lAssessments_edited))
})

################################################################################################################

test_that("Custom lAssessments and lMapping works together as intended", {
  lAssessments_edited <- MakeWorkflowList()
  lAssessments_edited$kri0001 <- yaml::read_yaml(system.file("/testpath/ae_assessment_moderate.yaml", package = "gsm"))
  lAssessments_edited$kri0001$name <- "aetoxgr"
  lAssessments_edited$kri0001$path <- file.path(system.file("/testpath/ae_assessment_moderate.yaml", package = "gsm"))

  lMapping_edited<- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
  lMapping_edited$dfAE$strGradeCol <- "MODERATE"

  expect_snapshot(snapshot <- Make_Snapshot(lMeta = lMeta, lData = lData, lMapping = lMapping_edited, lAssessments = lAssessments_edited))
})

################################################################################################################

test_that("cPath works as intended", {
  cPath_edited <- file.path(system.file("/testpath/", package = "gsm"))
  snapshot <- Make_Snapshot(lMeta = lMeta, lData = lData, lMapping = lMapping, lAssessments = lAssessments, cPath = cPath_edited)

  expect_true(file.exists(file.path(system.file("/testpath/", package = "gsm"), paste0(unique(tool_outputs$Table.Name[1]), ".csv"))))
  expect_true(file.exists(file.path(system.file("/testpath/", package = "gsm"), paste0(unique(tool_outputs$Table.Name[2]), ".csv"))))
  expect_true(file.exists(file.path(system.file("/testpath/", package = "gsm"), paste0(unique(tool_outputs$Table.Name[3]), ".csv"))))
  expect_true(file.exists(file.path(system.file("/testpath/", package = "gsm"), paste0(unique(tool_outputs$Table.Name[4]), ".csv"))))
  expect_true(file.exists(file.path(system.file("/testpath/", package = "gsm"), paste0(unique(tool_outputs$Table.Name[5]), ".csv"))))
  expect_true(file.exists(file.path(system.file("/testpath/", package = "gsm"), paste0(unique(tool_outputs$Table.Name[6]), ".csv"))))
  expect_true(file.exists(file.path(system.file("/testpath/", package = "gsm"), paste0(unique(tool_outputs$Table.Name[7]), ".csv"))))
  expect_true(file.exists(file.path(system.file("/testpath/", package = "gsm"), paste0(unique(tool_outputs$Table.Name[8]), ".csv"))))
  expect_true(file.exists(file.path(system.file("/testpath/", package = "gsm"), paste0(unique(tool_outputs$Table.Name[9]), ".csv"))))
})

################################################################################################################

test_that("Make_Snapshot() runs with non-essential missing datasets/metadata", {


  ### Removed dfAE
  lData_edited <- list(
    dfSUBJ = clindata::rawplus_dm[1:50,],
    dfPD = clindata::rawplus_protdev[1:50,],
    dfCONSENT = clindata::rawplus_consent[1:50,],
    dfIE = clindata::rawplus_ie[1:50,],
    dfSTUDCOMP = clindata::rawplus_studcomp[1:50,],
    dfSDRGCOMP = clindata::rawplus_sdrgcomp[1:50,],
    dfLB = clindata::rawplus_lb[1:50,]
  )
  expect_silent(Make_Snapshot(lMeta = lMeta, lData = lData_edited, lMapping = lMapping, lAssessments = lAssessments))


  ### Removed meta_params
  lMeta_edited <- list(
    config_param = clindata::config_param,
    config_schedule = clindata::config_schedule,
    config_workflow = clindata::config_workflow,
    meta_site = clindata::ctms_site,
    meta_study = clindata::ctms_study,
    meta_workflow = gsm::meta_workflow
  )
  expect_silent(Make_Snapshot(lMeta = lMeta_edited, lData = lData, lMapping = lMapping, lAssessments = lAssessments))
})

################################################################################################################

test_that("bQuiet works as intended", {
  expect_silent(Make_Snapshot(lData = lData, bQuiet = TRUE))
  expect_snapshot(snapshot <- Make_Snapshot(lData = lData, bQuiet = FALSE))
})
