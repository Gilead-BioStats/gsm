wf_mapping <- MakeWorkflowList(strNames="data_mapping")$data_mapping
workflows <- MakeWorkflowList(strNames=paste0("kri",sprintf("%04d", 1:4)))

# Pull Raw Data - this will overwrite the previous data pull
lData <- gsm::UseClindata(
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
lMapped <- RunWorkflow(lWorkflow = wf_mapping, lData = lData)

# Run Metrics
result <-map(workflows, ~RunWorkflow(lWorkflow = .x, lData = lMapped, bReturnData = FALSE))

test_that("RunWorkflow preserves inputs when bReturnData = FALSE", {
  expect_true(
    all(
      map_lgl(
        imap(workflows,
             function(kri, name){
               names(kri) %in% names(result[[name]])
             }
             ),
        all
      )
    )
  )
})

test_that("RunWorkflow contains all outputs from yaml steps", {
  yaml_outputs <- map(map(workflows, ~map_vec(.x$step, ~.x$output)), ~.x[!grepl("lCharts", .x)])
  expect_true(
    all(
      map_lgl(
        imap(result,
             function(kri, name){
               yaml_outputs[[name]] %in% names(kri$lData)
             }
        ),
        all
      )
    )
  )
})

test_that("RunWorkflow contains all outputs from yaml steps with populated fields (contains rows of data)", {
  yaml_outputs <- map(map(workflows, ~map(.x$steps, ~.x$output)), ~.x[!grepl("lCharts", .x)])
  rows <- vector()
  for(kri in names(yaml_outputs)){
    for(df in yaml_outputs[[kri]]){
      rows <- c(rows,dim(result[[kri]]$lData[[df]])[1])
    }
  }
  expect_true(
    all(rows > 0)
  )
})

test_that("RunWorkflow updates workflow object correctly", {
  # check for lData and lCharts in output
  expect_true(
    all(
      map_lgl(
        imap(workflows,
             function(kri, name){
              "lData" %in% names(result[[name]])
             }
        ),
        all
      )
    )
  )
})

