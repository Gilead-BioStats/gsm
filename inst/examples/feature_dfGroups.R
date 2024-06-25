devtools::load_all()
# Raw data
lRaw <- gsm::UseClindata(
  list(
    "dfSUBJ" = "clindata::rawplus_dm",
    "dfAE" = "clindata::rawplus_ae",
    "dfPD" = "clindata::ctms_protdev",
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

# Prepare Workflows
wf_mapping <- MakeWorkflowList(strNames = "mapping")[[1]]
wf_groups <- MakeWorkflowList(strPath = '/Users/jwildfire/github/gsm/inst/workflow')[[1]]

lMapped <- RunWorkflow(lWorkflow = wf_mapping, lData = lRaw)$lData
lCounts <- RunWorkflow(lWorkflow = wf_groups, lData = lMapped)
