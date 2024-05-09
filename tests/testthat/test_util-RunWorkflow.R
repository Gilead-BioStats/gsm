# Valid Assessment Input
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

workflows <- MakeWorkflowList(strNames = sprintf("kri%04d", 1:12))
result <- map(workflows, ~RunWorkflow(., lData))

test_that("RunWorkflow preserves inputs", {
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
               yaml_outputs[[name]] %in% names(kri$lData) &
                 any("lCharts" %in% names(kri))
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
              c("lData", "lCharts") %in% names(result[[name]])
             }
        ),
        all
      )
    )
  )
})

