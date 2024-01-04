source(testthat::test_path("testdata/data.R"))


# setup -------------------------------------------------------------------
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
  config_param = gsm::config_param,
  config_workflow = gsm::config_workflow,
  meta_params = gsm::meta_param,
  meta_site = clindata::ctms_site,
  meta_study = clindata::ctms_study,
  meta_workflow = gsm::meta_workflow
)

lAssessments <- MakeWorkflowList()

snapshot <- Make_Snapshot(lMeta = lMeta, lData = lData, lMapping = lMapping, lAssessments = lAssessments)
# end setup ---------------------------------------------------------------



test_that("cPath works as intended", {
  tmpdir <- tempdir()
  snapshot %>% Save_Snapshot(cPath = tmpdir)

  all_files <- list.files(tmpdir)

  expected_files <- gsm::rbm_data_spec %>%
    filter(
      System == "Gismo",
      (grepl("rpt_", Table) & .data$Table != "rpt_study_snapshot")
    ) %>%
    mutate(Table = paste0(Table, ".parquet")) %>%
    pull(Table) %>%
    unique()

  expect_true(all(expected_files %in% all_files))
  expect_true("snapshot.rds" %in% all_files)
})

test_that("bCreateDefaultFolder creates a folder and saves output correctly", {
  tmpdir <- tempdir()
  snapshot %>% Save_Snapshot(cPath = tmpdir, bCreateDefaultFolder = TRUE)

  all_files <- list.files(paste0(tmpdir, "/", as.character(Sys.Date())))

  expected_files <- gsm::rbm_data_spec %>%
    filter(
      System == "Gismo",
      (grepl("rpt_", Table) & .data$Table != "rpt_study_snapshot")
    ) %>%
    mutate(Table = paste0(Table, ".parquet")) %>%
    pull(Table) %>%
    unique()

  expect_true(all(expected_files %in% all_files))
  expect_true("snapshot.rds" %in% all_files)
})


test_that("non-existent folder is caught", {
  tmpdir <- tempdir()

  expect_error(
    snapshot %>% Save_Snapshot(cPath = paste0(tmpdir, "/abc123"))
  )
})
