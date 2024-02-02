# Write tests for Study_Report function
test_that("Study_Report function works as expected", {
  # Data setup ----------------------------------------------------------
  expect_no_error(
    lMeta <- gsm::UseClindata(
      list(
        "config_param" = "gsm::config_param",
        "config_workflow" = "gsm::config_workflow",
        "meta_params" = "gsm::meta_param",
        "meta_site" = "clindata::ctms_site",
        "meta_study" = "clindata::ctms_study",
        "meta_workflow" = "gsm::meta_workflow"
      )
    )
  )

  expect_no_error(
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
        filter(.data$phase == 'Blinded Study Drug Completion')",
        "dfDATACHG" = "clindata::edc_data_points",
        "dfDATAENT" = "clindata::edc_data_pages",
        "dfQUERY" = "clindata::edc_queries",
        "dfENROLL" = "clindata::rawplus_enroll"
      )
    )
  )

  # Testing
  expect_snapshot(lData)
  expect_snapshot(lMeta)
  expect_error(
    gsm::UseClindata(
      list(
        "dfSUBJ" = "rawplus_dm"
      )
    )
  )
})
