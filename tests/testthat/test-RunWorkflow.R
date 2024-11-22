wf_mapping <- MakeWorkflowList(strPath = "workflow/1_mappings")
workflows <- MakeWorkflowList(strNames = paste0("kri", sprintf("%04d", 1:2)))

# Don't run things we don't use.
used_params <- map(workflows, ~ map(.x$steps, "params")) %>%
  unlist() %>%
  unique()
wf_mapping$steps <- purrr::keep(
  wf_mapping$steps,
  ~ .x$output %in% used_params
)
# Source Data
lSource <- list(
  Source_SUBJ = clindata::rawplus_dm,
  Source_AE = clindata::rawplus_ae,
  Source_PD = clindata::ctms_protdev,
  Source_LB = clindata::rawplus_lb,
  Source_STUDCOMP = clindata::rawplus_studcomp,
  Source_SDRGCOMP = clindata::rawplus_sdrgcomp %>% dplyr::filter(.data$phase == "Blinded Study Drug Completion"),
  Source_DATACHG = clindata::edc_data_points,
  Source_DATAENT = clindata::edc_data_pages,
  Source_QUERY = clindata::edc_queries,
  Source_ENROLL = clindata::rawplus_enroll,
  Source_SITE = clindata::ctms_site,
  Source_STUDY = clindata::ctms_study
)

# Step 0 - Data Ingestion - standardize tables/columns names
lRaw <- list(
  Raw_SUBJ = lSource$Source_SUBJ,
  Raw_AE = lSource$Source_AE,
  Raw_PD = lSource$Source_PD %>%
    rename(subjid = subjectenrollmentnumber),
  Raw_LB = lSource$Source_LB,
  Raw_STUDCOMP = lSource$Source_STUDCOMP,
  Raw_SDRGCOMP = lSource$Source_SDRGCOMP,
  Raw_DATACHG = lSource$Source_DATACHG %>%
    rename(subject_nsv = subjectname),
  Raw_DATAENT = lSource$Source_DATAENT %>%
    rename(subject_nsv = subjectname),
  Raw_QUERY = lSource$Source_QUERY %>%
    rename(subject_nsv = subjectname),
  Raw_ENROLL = lSource$Source_ENROLL,
  Raw_SITE = lSource$Source_SITE %>%
    rename(studyid = protocol) %>%
    rename(invid = pi_number) %>%
    rename(InvestigatorFirstName = pi_first_name) %>%
    rename(InvestigatorLastName = pi_last_name) %>%
    rename(City = city) %>%
    rename(State = state) %>%
    rename(Country = country),
  Raw_STUDY = lSource$Source_STUDY %>%
    rename(studyid = protocol_number) %>%
    rename(Status = status)
)

# Create Mapped Data
lMapped <- quiet_RunWorkflows(lWorkflows = wf_mapping, lData = lRaw)

# Run Metrics
results <- map(
  workflows,
  ~ quiet_RunWorkflow(lWorkflow = .x, lData = lMapped, bReturnResult = FALSE, bKeepInputData = FALSE)
)

yaml_outputs <- map(
  map(workflows, ~ map_vec(.x$steps, ~ .x$output)),
  ~ .x[!grepl("lCharts", .x)]
)

test_that("RunWorkflow preserves all steps when bReturnResult = FALSE", {
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

#test_that('RunWorkflow loads data with configuration object.', {
#    expect_no_error({
#        lConfig <- list(
#            LoadData = function(lWorkflow, lConfig) {
#                lData <- list(
#                    Raw_SUBJ = clindata::rawplus_dm,
#                    Raw_AE = clindata::rawplus_ae,
#                    Raw_PD = clindata::ctms_protdev,
#                    Raw_LB = clindata::rawplus_lb,
#                    Raw_STUDCOMP = clindata::rawplus_studcomp,
#                    Raw_SDRGCOMP = clindata::rawplus_sdrgcomp %>% dplyr::filter(.data$phase == "Blinded Study Drug Completion"),
#                    Raw_DATACHG = clindata::edc_data_points,
#                    Raw_DATAENT = clindata::edc_data_pages,
#                    Raw_QUERY = clindata::edc_queries,
#                    Raw_ENROLL = clindata::rawplus_enroll,
#                    Raw_SITE = clindata::ctms_site,
#                    Raw_STUDY = clindata::ctms_study
#                )
#
#                return(lData)
#            }
#        )
#
#        lMapped <- quiet_RunWorkflows(
#            lWorkflows = wf_mapping,
#            lData = NULL,
#            lConfig = lConfig
#        )
#    })
#})
