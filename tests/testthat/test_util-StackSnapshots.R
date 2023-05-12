# setup -------------------------------------------------------------------
source(testthat::test_path("testdata/data.R"))

makeTestData <- function(data) {
  data %>%
    slice(1:300) %>%
    mutate(
      subjectname = substr(subjectname, 0, 4),
      subjectname = case_when(subjectname == "0001" ~ "0003",
                              subjectname == "0002" ~ "0496",
                              subjectname == "0004" ~ "1350",
                              .default = subjectname
      )
    )
}

lData <- list(
  dfSUBJ = dfSUBJ_expanded %>% mutate(enrollyn = "Y"),
  dfAE = dfAE_expanded,
  dfPD = dfPD_expanded,
  dfCONSENT = dfCONSENT_expanded,
  dfIE = dfIE_expanded,
  dfSTUDCOMP = dfSTUDCOMP_expanded,
  dfSDRGCOMP = dfSDRGCOMP_expanded,
  dfLB = clindata::rawplus_lb %>% filter(subjid %in% dfSUBJ_expanded$subjid) %>% slice(1:2000),
  dfDATACHG = makeTestData(clindata::edc_data_points),
  dfDATAENT = makeTestData(clindata::edc_data_pages),
  dfQUERY = makeTestData(clindata::edc_queries)
)

lMapping <- c(
  yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_ctms.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_adam.yaml", package = "gsm"))
)

lMeta <- list(
  config_param = clindata::config_param,
  config_workflow = clindata::config_workflow,
  meta_params = gsm::meta_param,
  meta_site = clindata::ctms_site,
  meta_study = clindata::ctms_study,
  meta_workflow = gsm::meta_workflow
)

lAssessments <- MakeWorkflowList()

snapshot <- Make_Snapshot(lData = lData)

cPath <- system.file('snapshots', 'AA-AA-000-0000', package = "gsm")

expected_data <- c("meta_param", "meta_workflow", "results_analysis", "results_summary",
                   "status_param", "status_site", "status_study", "status_workflow",
                   "parameters")

test_that("all expected datasets are present in stacked data", {



  stacked_data <- StackSnapshots(cPath = cPath)

  expect_true(all(expected_data %in% names(stacked_data)))
  expect_type(stacked_data, "list")

})

test_that("all expected datasets are present in stacked data with new snapshot appended", {

  stacked_data <- StackSnapshots(cPath = cPath, lSnapshot = snapshot)
  expect_true(all(expected_data %in% names(stacked_data)))
  expect_type(stacked_data, "list")

  all_snapshot_dates <- stacked_data %>%
    map( ~ {.x$snapshot_date %>% unique()}) %>%
    {do.call("c", .)} %>% unique()

  expect_true(Sys.Date() %in% all_snapshot_dates)

})


test_that("error is thrown when cPath does not exist", {
  cPath <- "path/to/nonexistent/folder"
  expect_error(StackSnapshots(cPath))
})

test_that("message is thrown when expected data is missing", {

  defunct_snapshot <- snapshot
  defunct_snapshot$lSnapshot <- snapshot$lSnapshot[names(snapshot$lSnapshot) %in% c("results_summary", "results_analysis")]

  expect_snapshot(defunct_stacked_data <- StackSnapshots(cPath = cPath, lSnapshot = defunct_snapshot))

})
