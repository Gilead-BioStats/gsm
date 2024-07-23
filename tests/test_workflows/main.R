# Run all tests in this directory. Also includes scripts for standardized tests.
devtools::load_all()

get_workflow_data <- function(strNames) {
  workflows <- MakeWorkflowList(strNames = strNames)
  lMapped <- get_mapped_data(workflows)
  results <- map(
    workflows,
    function(this_workflow) {
      quiet_RunWorkflow(
        lWorkflow = this_workflow,
        lData = lMapped,
        bReturnData = FALSE
      )
    }
  )
  yaml_outputs <- map(workflows, ~ map_vec(.x$steps, ~ .x$output))
  return(
    list(
      workflows = workflows,
      yaml_outputs = yaml_outputs,
      results = results
    )
  )
}

get_mapped_data <- function(workflows) {
  wf_mapping <- MakeWorkflowList(strNames = "data_mapping")$data_mapping

  # Don't run things we don't use.
  used_params <- map(workflows, ~ map(.x$steps, "params")) %>%
    unlist() %>%
    unique()
  wf_mapping$steps <- purrr::keep(
    wf_mapping$steps,
    ~ .x$output %in% used_params
  )
  lData <- UseClindata(
    list(
      "dfSUBJ" = "clindata::rawplus_dm",
      "dfAE" = "clindata::rawplus_ae",
      "dfPD" = "clindata::ctms_protdev",
      "dfCONSENT" = "clindata::rawplus_consent",
      "dfIE" = "clindata::rawplus_ie",
      "dfLB" = "clindata::rawplus_lb",
      "dfSTUDCOMP" = "clindata::rawplus_studcomp",
      "dfSDRGCOMP" = "clindata::rawplus_sdrgcomp %>%
            dplyr::filter(.data$phase == 'Blinded Study Drug Completion')",
      "dfDATACHG" = "clindata::edc_data_points",
      "dfDATAENT" = "clindata::edc_data_pages",
      "dfQUERY" = "clindata::edc_queries",
      "dfENROLL" = "clindata::rawplus_enroll"
    )
  )
  lMapped <- quiet_RunWorkflow(lWorkflow = wf_mapping, lData = lData)
  return(lMapped)
}

workflow_test_dir <- "tests/test_workflows"
workflow_test_files <- grep(
  "^test",
  dir(workflow_test_dir),
  value = TRUE
)
workflow_test_paths <- paste(workflow_test_dir, workflow_test_files, sep = "/")

purrr::walk(
  workflow_test_paths,
  function(this_path) {
    test_file(
      this_path,
      reporter = check_reporter()
    )
  }
)
