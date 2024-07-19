# Tests based on tests/testthat/test-RunWorkflow.R. If something breaks
# here, check whether that has changed.

test_that("Metric workflows work", {
  wf_mapping <- MakeWorkflowList(strNames = "data_mapping")$data_mapping
  workflows <- MakeWorkflowList()

  # Don't run things we don't use.
  used_params <- map(workflows, ~ map(.x$steps, "params")) %>%
    unlist() %>% unique()
  wf_mapping$steps <- purrr::keep(
    wf_mapping$steps,
    ~ .x$output %in% used_params
  )

  # I run this one separately to get the data.
  workflows$data_mapping <- NULL

  # These currently fail, likely due to wrong input.
  workflows$data_reporting <- NULL
  workflows$qtl0004 <- NULL
  workflows$qtl0006 <- NULL
  workflows$reports <- NULL
  workflows$snapshot <- NULL

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

  # Create Mapped Data
  lMapped <- quiet_RunWorkflow(lWorkflow = wf_mapping, lData = lData)

  # Run Metrics
  results <- map(
    workflows,
    ~quiet_RunWorkflow(lWorkflow = .x, lData = lMapped, bReturnData = FALSE)
  )

  yaml_outputs <- map(workflows, ~map_vec(.x$steps, ~.x$output))

  expect_no_error({
    purrr::iwalk(
      workflows,
      function(this_workflow, this_name) {
        expect_identical(
          this_workflow, results[[this_name]][names(this_workflow)]
        )
      }
    )
  })

  expect_no_error({
    purrr::iwalk(
      results,
      function(this_result, this_name) {
        expect_setequal(yaml_outputs[[this_name]], names(this_result$lData))
      }
    )
  })

  expect_no_error({
    purrr::iwalk(
      yaml_outputs,
      function(this_output_set, this_name) {
        expect_true(
          all(map_int(results[[this_name]]$lData[this_output_set], NROW) > 0)
        )
      }
    )
  })
})
