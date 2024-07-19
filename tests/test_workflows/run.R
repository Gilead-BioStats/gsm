devtools::load_all()

wf_mapping <- MakeWorkflowList(strNames = "data_mapping")$data_mapping
workflows <- MakeWorkflowList()

# I run this one separately to get the data.
workflows$data_mapping <- NULL

# These currently fail.
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

# yaml_outputs <- purrr::map(
#   map(workflows, ~map_vec(.x$steps, ~.x$output)),
#   ~.x[!grepl("lCharts", .x)]
# )

# All of the `metrics` reports have the same outputs.
yaml_outputs <- c(
  "vThreshold",
  "dfInput",
  "dfTransformed",
  "dfAnalyzed",
  "dfFlagged",
  "dfSummary"
)
