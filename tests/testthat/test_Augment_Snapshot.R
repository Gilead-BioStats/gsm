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
  dfQUERY = makeTestData(clindata::edc_queries),
  dfENROLL = dfENROLL
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

snapshot <- Make_Snapshot(lData = lData)

# tests -------------------------------------------------------------------
test_that("Augment_Snapshot fails when data is missing", {
  expect_error()
  expect_error(Augment_Snapshot())
})
