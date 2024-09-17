wf_mapping <- MakeWorkflowList(strNames = "2_map")[[1]]
workflows <- MakeWorkflowList(strNames = paste0("kri", sprintf("%04d", 1:2)))

# Don't run things we don't use.
used_params <- map(workflows, ~ map(.x$steps, "params")) %>%
  unlist() %>%
  unique()
wf_mapping$steps <- purrr::keep(
  wf_mapping$steps,
  ~ .x$output %in% used_params
)

# Pull Raw Data - this will overwrite the previous data pull
lData <- UseClindata(
  list(
    "Raw_SUBJ" = "clindata::rawplus_dm",
    "Raw_AE" = "clindata::rawplus_ae",
    "Raw_PD" = "clindata::ctms_protdev",
    "Raw_CONSENT" = "clindata::rawplus_consent",
    "Raw_IE" = "clindata::rawplus_ie",
    "Raw_LB" = "clindata::rawplus_lb",
    "Raw_STUDCOMP" = "clindata::rawplus_studcomp",
    "Raw_SDRGCOMP" = "clindata::rawplus_sdrgcomp %>%
            dplyr::filter(.data$phase == 'Blinded Study Drug Completion')",
    "Raw_DATACHG" = "clindata::edc_data_points",
    "Raw_DATAENT" = "clindata::edc_data_pages",
    "Raw_QUERY" = "clindata::edc_queries",
    "Raw_ENROLL" = "clindata::rawplus_enroll",
    "Raw_STUDY" = "clindata::ctms_study",
    "Raw_SITE" = "clindata::ctms_site"
  )
)

# Create Mapped Data
lMapped <- quiet_RunWorkflow(lWorkflow = wf_mapping, lData = lData)

# Run Metrics
results <- map(
  workflows,
  ~ quiet_RunWorkflow(lWorkflow = .x, lData = lMapped, bReturnData = FALSE)
)

yaml_outputs <- map(
  map(workflows, ~ map_vec(.x$steps, ~ .x$output)),
  ~ .x[!grepl("lCharts", .x)]
)

test_that("RunWorkflow preserves inputs when bReturnData = FALSE", {
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
})

test_that("RunWorkflow contains all outputs from yaml steps", {
  expect_no_error({
    purrr::iwalk(
      results,
      function(this_result, this_name) {
        expect_setequal(yaml_outputs[[this_name]], names(this_result$lData))
      }
    )
  })
})

test_that("RunWorkflow contains all outputs from yaml steps with populated fields (contains rows of data)", {
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
