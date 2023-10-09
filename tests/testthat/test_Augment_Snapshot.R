## TODO: use this as temporary test fixture instead of living in `inst/snapshots`:


# start -------------------------------------------------------------------

devtools::source_url("https://raw.githubusercontent.com/Gilead-BioStats/clindata/dev-v0.15.1/inst/snapshot/snapshot.R")
devtools::source_url("https://raw.githubusercontent.com/Gilead-BioStats/clindata/dev-v0.15.1/inst/utils-check.R")
devtools::source_url("https://raw.githubusercontent.com/Gilead-BioStats/clindata/dev-v0.15.1/inst/simulation/utils-helpers.R")


snapshot_date <- "2016-11-01"
workflow_ids <- c("kri0001", "kri0002", "cou0005", "qtl0004")

create_test_snapshots <- function(snapshot_date, workflow_ids) {

  # ----
  # Define metadata.

  metadata <- list(
    meta_workflow = gsm::meta_workflow,
    config_workflow = clindata::config_workflow %>%
      mutate(
        active = workflowid %in% workflow_ids
      ),

    meta_params = gsm::meta_param,
    config_param = clindata::config_param,

    meta_site = clindata::ctms_site,
    meta_study = clindata::ctms_study
  )

  # ----
  # Generate snapshot.
  snapshot <- Make_Snapshot(
    lMeta = metadata,
    lData = snapshot_all(snapshot_date),
    lAssessments = gsm::MakeWorkflowList(workflow_ids),
    strAnalysisDate = snapshot_date,
    bUpdateParams = TRUE,
    bQuiet = TRUE
  )

  # ----
  # Correct CTMS data.

  rbm_data_spec <- gsm::rbm_data_spec %>%
    dplyr::filter(System == 'Gismo') %>%
    dplyr::arrange(Table, Order)

  # Reorder study columns.
  study_cols <- gsm::rbm_data_spec %>%
    dplyr::filter(Table == 'status_study') %>%
    dplyr::arrange(Order) %>%
    dplyr::pull(Column)

  snapshot$lSnapshot$status_study <- snapshot$lSnapshot$status_study %>%
    dplyr::select(all_of(study_cols))

  # replace NA values with 0s
  snapshot$lSnapshot$status_site$enrolled_participants <- coalesce(
    snapshot$lSnapshot$status_site$enrolled_participants, 0
  )

  # Reorder site columns.
  site_cols <- rbm_data_spec %>%
    dplyr::filter(Table == 'status_site') %>%
    dplyr::arrange(Order) %>%
    dplyr::pull(Column)

  snapshot$lSnapshot$status_site <- snapshot$lSnapshot$status_site %>%
    dplyr::select(dplyr::all_of(site_cols))

  # ----
  # Save snapshot.

  out_path <- paste0(as.character(snapshot_date), '/')
  if (!file.exists(out_path))
    dir.create(out_path)

  Save_Snapshot(
    lSnapshot = snapshot,
    cPath = out_path
  )

}



# end ---------------------------------------------------------------------




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


test_that("Augment_Snapshot runs without error when correct data is provided", {
  expect_message(augment <- Augment_Snapshot(snapshot, cPath = system.file("snapshots", "AA-AA-000-0000", package = "gsm")))

  contains_timeseries <- augment$lStudyAssessResults %>%
    map_lgl(~ {
      "timeSeriesContinuousJS" %in% names(.x$lResults$lCharts)
    })

  contains_longitudinal_dataset <- augment$lStudyAssessResults %>%
    map_lgl(~ {
      "dfSummaryLongitudinal" %in% names(.x$lResults$lData)
    })

  expect_true(all(contains_timeseries))
  expect_true(all(contains_longitudinal_dataset))
})


test_that("Augment_Snapshot correctly subsets folders specified in vFolderNames", {
  augment <- Augment_Snapshot(
    lSnapshot = snapshot,
    cPath = system.file("snapshots", "AA-AA-000-0000", package = "gsm"), vFolderNames = c("2016-12-01", "2018-12-01")
  )

  dates_used_in_augment <- map(augment$lStackedSnapshots, ~ {
    .x$snapshot_date %>% unique()
  }) %>%
    {
      do.call("c", .)
    } %>%
    unique()

  expect_true(all(as.Date(c("2016-12-01", "2018-12-01")) %in% dates_used_in_augment))
  expect_true(all(!as.Date(c("2015-12-01", "2017-12-01", "2019-12-01")) %in% dates_used_in_augment))
})
