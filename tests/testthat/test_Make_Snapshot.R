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
  config_param = gsm::config_param,
  config_workflow = gsm::config_workflow,
  meta_params = gsm::meta_param,
  meta_site = clindata::ctms_site,
  meta_study = clindata::ctms_study,
  meta_workflow = gsm::meta_workflow
)

lAssessments <- MakeWorkflowList()

snapshot <- Make_Snapshot(lData = lData)

################################################################################################################

test_that("output is generated as expected", {
  specColumns <- function(table) {
    gsm::rbm_data_spec %>%
      filter(System == "Gismo" & Table == table) %>%
      pull(Column)
  }

  expect_true(is.list(snapshot))
  expect_true("Date" %in% class(snapshot$lSnapshotDate))
  expect_true(is.list(snapshot$lSnapshot))
  expect_true(is.list(snapshot$lStudyAssessResults))
  expect_true(is.list(snapshot$lInputs))
  expect_snapshot(names(snapshot))
  expect_snapshot(names(snapshot$lSnapshot))
  expect_snapshot(names(snapshot$lStudyAssessResults))
  expect_snapshot(names(snapshot$lInputs))
  expect_equal(sort(names(snapshot$lSnapshot$status_study)), sort(specColumns("status_study")))
  expect_equal(sort(names(snapshot$lSnapshot$status_site)), sort(specColumns("status_site")))
  expect_equal(sort(names(snapshot$lSnapshot$status_workflow)), sort(specColumns("status_workflow")))
  expect_equal(sort(names(snapshot$lSnapshot$status_param)), sort(specColumns("status_param")))
  expect_equal(sort(names(snapshot$lSnapshot$results_summary)), sort(specColumns("results_summary")))
  expect_equal(sort(names(snapshot$lSnapshot$results_bounds)), sort(specColumns("results_bounds")))
  expect_equal(sort(names(snapshot$lSnapshot$meta_workflow)), sort(specColumns("meta_workflow")))
  expect_equal(sort(names(snapshot$lSnapshot$meta_param)), sort(specColumns("meta_param")))
})

################################################################################################################

test_that("input data is structured as expected", {
  gsmColumns <- function(table) {
    gsm::rbm_data_spec %>%
      filter(System == "GSM" & Table == table) %>%
      pull(Column)
  }

  expect_true(is.list(lMeta))
  expect_snapshot(names(lMeta))

  expect_equal(sort(names(lMeta$config_param)), sort(gsmColumns("config_param")))
  expect_equal(sort(names(lMeta$config_workflow)), sort(gsmColumns("config_workflow")))
  expect_equal(sort(names(lMeta$meta_params)), sort(gsmColumns("meta_param")))
  expect_equal(sort(names(lMeta$meta_workflow)), sort(gsmColumns("meta_workflow")))

  # all names %in% because enrolled_participants/site are added in Make_Snapshot()
  expect_true(all(names(lMeta$meta_site) %in% gsmColumns("meta_site")))
  expect_true(all(names(lMeta$meta_study) %in% gsmColumns("meta_study")))
})

################################################################################################################

test_that("invalid data throw errors", {
  ### lMeta - testing lMeta equal to character string and missing config_param
  expect_error(Make_Snapshot("Hi"))

  lMeta_edited <- list(
    config_workflow = gsm::config_workflow,
    meta_params = gsm::meta_param,
    meta_site = clindata::ctms_site,
    meta_study = clindata::ctms_study,
    meta_workflow = gsm::meta_workflow
  )
  expect_error(Make_Snapshot(lMeta = lMeta_edited, lData = lData, lMapping = lMapping, lAssessments = lAssessments))

  lData_edited <- list(
    dfAE = dfAE_expanded,
    dfPD = dfPD_expanded,
    dfCONSENT = dfCONSENT_expanded,
    dfIE = dfIE_expanded,
    dfSTUDCOMP = dfSTUDCOMP_expanded,
    dfSDRGCOMP = dfSDRGCOMP_expanded,
    dfLB = dfLB_expanded
  )
  expect_error(Make_Snapshot(lMeta = lMeta, lData = lData_edited, lMapping = lMapping, lAssessments = lAssessments))


  lMapping_edited <- lMapping
  lMapping_edited$dfSUBJ$strSiteCol <- "cupcakes"
  expect_error(Make_Snapshot(lMeta = lMeta, lData = lData, lMapping = lMapping_edited, lAssessments = lAssessments))

  lAssessments_edited <- list(
    yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
    yaml::read_yaml(system.file("mappings", "mapping_adam.yaml", package = "gsm"))
  )

  expect_error(
    expect_warning(
      Make_Snapshot(lMeta = lMeta, lData = lData, lMapping = lMapping, lAssessments = lAssessments_edited)
      )
  )

})

################################################################################################################

test_that("Custom lAssessments and lMapping works together as intended", {
  lAssessments_edited <- MakeWorkflowList()
  lAssessments_edited$kri0001 <- list(steps = list(
    list(
      name = "FilterDomain",
      inputs = "dfAE",
      output = "dfAE",
      params = list(
        strDomain = "dfAE",
        strColParam = "strTreatmentEmergentCol",
        strValParam = "strTreatmentEmergentVal"
      )
    ),
    list(
      name = "FilterDomain",
      inputs = "dfAE",
      output = "dfAE",
      params = list(
        strDomain = "dfAE",
        strColParam = "strSeriousCol",
        strValParam = "strNonSeriousVal"
      )
    ),
    list(
      name = "FilterDomain",
      inputs = "dfAE",
      output = "dfAE",
      params = list(
        strDomain = "dfAE",
        strColParam = "strModerateCol",
        strValParam = "strModerateVal"
      )
    ),
    list(
      name = "AE_Map_Raw",
      inputs = c("dfAE", "dfSUBJ"),
      output = "dfInput"
    ),
    list(
      name = "AE_Assess",
      inputs = "dfInput",
      output = "lResults",
      params = list(
        strGroup = "Site",
        vThreshold = NULL,
        strMethod = "Poisson"
      )
    )
  ))
  lAssessments_edited$kri0001$name <- "aetoxgr"
  lAssessments_edited$kri0001$path <- file.path(system.file("/testpath/ae_assessment_moderate.yaml", package = "gsm"))

  lMapping_edited <- c(
    yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
    yaml::read_yaml(system.file("mappings", "mapping_ctms.yaml", package = "gsm"))
  )
  lMapping_edited$dfAE$strGradeCol <- "MODERATE"

  expect_snapshot(snapshot <- Make_Snapshot(lMeta = lMeta, lData = lData, lMapping = lMapping_edited, lAssessments = lAssessments_edited))
})



################################################################################################################

test_that("Make_Snapshot() runs with non-essential missing datasets/metadata", {
  ### Removed dfAE
  lData_edited <- list(
    dfSUBJ = dfSUBJ_expanded,
    dfPD = dfPD_expanded
  )

  ### Removed meta_params
  lMeta_edited <- list(
    config_param = gsm::config_param,
    config_schedule = clindata::config_schedule,
    config_workflow = gsm::config_workflow,
    meta_site = clindata::ctms_site,
    meta_study = clindata::ctms_study,
    meta_workflow = gsm::meta_workflow
  )

  expect_silent(
    Make_Snapshot(
      lMeta = lMeta_edited,
      lData = lData_edited,
      lMapping = lMapping,
      lAssessments = lAssessments
    )
  )
})

################################################################################################################

test_that("bQuiet works as intended", {
  expect_snapshot(
    out <- Make_Snapshot(
      lData = lData,
      lAssessments = MakeWorkflowList(strNames = c("cou0001")),
      bQuiet = FALSE
    )
  )
})

################################################################################################################

test_that("valid gsm_analysis_date is passed to output", {
  result <- Make_Snapshot(
    lData = lData,
    lAssessments = MakeWorkflowList(strNames = c("kri0001", "kri0004")),
    strAnalysisDate = "2023-02-15"
  )

  expect_equal(
    unique(result$lSnapshot$results_summary$gsm_analysis_date),
    as.Date("2023-02-15")
  )
})

test_that("invalid date input returns the current date", {
  result <- Make_Snapshot(
    lData = lData,
    lAssessments = MakeWorkflowList(strNames = c("kri0001", "kri0004")),
    strAnalysisDate = "not a date"
  )

  expect_equal(
    unique(result$lSnapshot$results_summary$gsm_analysis_date),
    Sys.Date()
  )
})

test_that("NULL date input returns the current date", {
  result <- Make_Snapshot(
    lData = lData,
    lAssessments = MakeWorkflowList(strNames = c("kri0001", "kri0004"))
  )

  expect_equal(
    unique(result$lSnapshot$results_summary$gsm_analysis_date),
    Sys.Date()
  )
})
