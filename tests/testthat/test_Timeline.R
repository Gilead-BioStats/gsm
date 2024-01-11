# Install and load the `testthat` package
source(testthat::test_path("testdata/data.R"))

test_that("Make_Timeline function works as expected", {
  lMeta = gsm::UseClindata(
    list(
      "config_param" = "gsm::config_param",
      "config_workflow" = "gsm::config_workflow",
      "meta_params" = "gsm::meta_param",
      "meta_site" = "clindata::ctms_site",
      "meta_study" = "clindata::ctms_study",
      "meta_workflow" = "gsm::meta_workflow"
    )
  )

  lData = gsm::UseClindata(
    list(
      "dfSUBJ" = "clindata::rawplus_dm"
    )
  )

  lMapping = Read_Mapping()

  lAssessments = MakeWorkflowList(lMeta = lMeta)

  # map ctms data -----------------------------------------------------------
  status_study <- Study_Map_Raw(
    dfs = list(
      dfSTUDY = lMeta$meta_study,
      dfSUBJ = lData$dfSUBJ
    ),
    lMapping = lMapping,
    dfConfig = lMeta$config_param
  )

  # Test the function
  plot <- suppressWarnings(Make_Timeline(status_study, n_breaks = 5, bInteractive = TRUE))

  expect_true(is.list(plot))
  expect_true(plot$x$uid == "timeline")

})



