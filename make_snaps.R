library(glue)
library(cli)
library(stringr)
library(dplyr)
library(purrr)
setwd("~/gsm/inst/dev_snapshots")
devtools::source_url("https://raw.githubusercontent.com/Gilead-BioStats/clindata/fix-snapshot-function/inst/snapshot/snapshot.R")
devtools::source_url("https://raw.githubusercontent.com/Gilead-BioStats/clindata/main/inst/simulation/utils-helpers.R")
devtools::source_url("https://raw.githubusercontent.com/Gilead-BioStats/clindata/main/inst/utils-check.R")

snap_meta <- list(
  list(
    snapshot_date = "2016-12-01",
    workflow_ids = c("kri0001", "qtl0004")
  ),
  list(
    snapshot_date = "2017-12-01",
    workflow_ids = c("kri0001", "kri0002", "qtl0004")
  ),
  list(
    snapshot_date = "2018-12-01",
    workflow_ids = c("kri0002", "qtl0004")
  )
)


make_snaps <- function(snap_meta) {

  metadata <- list(
    meta_workflow = gsm::meta_workflow,
    config_workflow = clindata::config_workflow %>%
      mutate(
        active = workflowid %in% snap_meta$workflow_ids
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
    lData = snapshot_all(snap_meta$snapshot_date),
    lAssessments = gsm::MakeWorkflowList(snap_meta$workflow_ids),
    strAnalysisDate = snap_meta$snapshot_date,
    bUpdateParams = TRUE,
    bQuiet = TRUE
  )

  # ----
  # Correct CTMS data.

  rbm_data_spec <- gsm::rbm_data_spec %>%
    dplyr::filter(System == 'Gismo') %>%
    dplyr::arrange(Table, Order)

  # Reorder study columns.
  study_cols <- rbm_data_spec %>%
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
    dplyr::select(tidyselect::all_of(site_cols))

  # ----
  # Save snapshot.

  out_path <- paste0(as.character(snap_meta$snapshot_date), '/')
  if (!file.exists(out_path))
    dir.create(out_path)

  Save_Snapshot(
    lSnapshot = snapshot,
    cPath = out_path
  )

  # ----
  # Check data.

  status_study <- read.csv(glue::glue('{snap_meta$snapshot_date}/status_study.csv'))
  if (any(is.na(as.integer(status_study$enrolled_participants))))
    cli::cli_alert_danger(
      'NA values detected in [ status_study$enrolled_participants ].'
    )

  status_site <- read.csv(glue::glue('{snap_meta$snapshot_date}/status_site.csv'))
  if (any(is.na(as.integer(status_site$enrolled_participants))))
    cli::cli_alert_danger(
      'NA values detected in [ status_site$enrolled_participants ].'
    )

  purrr::walk(
    list.files(snap_meta$snapshot_date, '\\.csv$', T, T, T),
    function(file) {
      table <- stringr::word(file, -2, sep = '/|\\.')
      cli::cli_alert_info(
        'Checking [ {table} ] for data issues.'
      )
      data <- read.csv(file)
      expected_columns <- rbm_data_spec %>%
        dplyr::filter(
          Table == table
        ) %>%
        dplyr::pull(Column)

      # Check columns.
      if (!all(names(data) == expected_columns))
        cli::cli_alert_danger(
          'Invalid column order in [ {table} ].'
        )

      # Check date.
      expected_date <- stringr::word(file, -2, sep = '/')
      actual_date <- unique(data$gsm_analysis_date)
      if (actual_date != expected_date)
        cli::cli_alert_danger(
          '[ {file} ] contains an invalid date: [ {actual_date} ].'
        )
    }
  )

}


purrr::walk(snap_meta, ~ make_snaps(.))
