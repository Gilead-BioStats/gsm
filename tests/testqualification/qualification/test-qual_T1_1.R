source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))
# priority1_names <- c("AE", "ENROLL", "LB", "PD", "SDRGCOMP", "STUDCOMP", "SUBJ")
# mapping_p1 <- MakeWorkflowList(priority1_names)
lData_mapped <- RunWorkflows(mappings_wf, lData)

priority2_names <- c("DATACHG", "DATAENT", "QUERY", "SUBJ")
mapping_p2 <- MakeWorkflowList(priority2_names)
lData_mapped2 <- RunWorkflows(mapping_p2, lData)

# Priority 1 mappings
test_that("mappings now done by individual domain, test that inputs and outputs of AE are completed as expected", {

  # For AE.yaml
  mapped_ae_yaml <- read_yaml(
    system.file("tests", "testqualification", "qualification", "qual_workflows", "1_mappings", "AE.yaml", package = "gsm")
  )

  # Requried raw data is in data source
  expect_true(all(names(mapped_ae_yaml$spec) %in% names(lData)))

  # Output from yaml is in the mapped data object
  expect_true(flatten(mapped_ae_yaml$steps)$output %in% names(lData_mapped))

  # Needed columns of raw data are actually in raw data and retained in final data
  expect_true(all(names(flatten(mapped_ae_yaml$spec)) %in% names(lData[names(mapped_ae_yaml$spec)][[1]])))
  expect_true(all(names(flatten(mapped_ae_yaml$spec)) %in% names(lData_mapped[[flatten(mapped_ae_yaml$steps)$output]])))
})

test_that("mappings now done by individual domain, test that inputs and outputs of ENROLL are completed as expected", {

  # For ENROLL.yaml
  mapped_enroll_yaml <- read_yaml(
    system.file("tests", "testqualification", "qualification", "qual_workflows", "1_mappings", "ENROLL.yaml", package = "gsm")
  )

  # Requried raw data is in data source
  expect_true(all(names(mapped_enroll_yaml$spec) %in% names(lData)))

  # Output from yaml is in the mapped data object
  expect_true(flatten(mapped_enroll_yaml$steps)$output %in% names(lData_mapped))

  # Needed columns of raw data are actually in raw data and retained in final data
  expect_true(all(names(flatten(mapped_enroll_yaml$spec)) %in% names(lData[names(mapped_enroll_yaml$spec)][[1]])))
  expect_true(all(names(flatten(mapped_enroll_yaml$spec)) %in% names(lData_mapped[[flatten(mapped_enroll_yaml$steps)$output]])))
})

test_that("mappings now done by individual domain, test that inputs and outputs of LB are completed as expected", {

  # For LB.yaml
  mapped_lb_yaml <- read_yaml(
    system.file("tests", "testqualification", "qualification", "qual_workflows", "1_mappings", "LB.yaml", package = "gsm")
  )

  # Requried raw data is in data source
  expect_true(all(names(mapped_lb_yaml$spec) %in% names(lData)))

  # Output from yaml is in the mapped data object
  expect_true(flatten(mapped_lb_yaml$steps)$output %in% names(lData_mapped))

  # Needed columns of raw data are actually in raw data and retained in final data
  expect_true(all(names(flatten(mapped_lb_yaml$spec)) %in% names(lData[names(mapped_lb_yaml$spec)][[1]])))
  expect_true(all(names(flatten(mapped_lb_yaml$spec)) %in% names(lData_mapped[[flatten(mapped_lb_yaml$steps)$output]])))
})

test_that("mappings now done by individual domain, test that inputs and outputs of PD are completed as expected", {

  # For PD.yaml
  mapped_pd_yaml <- read_yaml(
    system.file("tests", "testqualification", "qualification", "qual_workflows", "1_mappings", "PD.yaml", package = "gsm")
  )

  # Requried raw data is in data source
  expect_true(all(names(mapped_pd_yaml$spec) %in% names(lData)))

  # Output from yaml is in the mapped data object
  expect_true(flatten(mapped_pd_yaml$steps)$output %in% names(lData_mapped))

  # Needed columns of raw data are actually in raw data and retained in final data
  expect_true(all(names(flatten(mapped_pd_yaml$spec)) %in% names(lData[names(mapped_pd_yaml$spec)][[1]])))
  expect_true(all(names(flatten(mapped_pd_yaml$spec)) %in% names(lData_mapped[[flatten(mapped_pd_yaml$steps)$output]])))
})

test_that("mappings now done by individual domain, test that inputs and outputs of SDRGCOMP are completed as expected", {

  # For SDRGCOMP.yaml
  mapped_sdrgcomp_yaml <- read_yaml(
    system.file("tests", "testqualification", "qualification", "qual_workflows", "1_mappings", "SDRGCOMP.yaml", package = "gsm")
  )

  # Requried raw data is in data source
  expect_true(all(names(mapped_sdrgcomp_yaml$spec) %in% names(lData)))

  # Output from yaml is in the mapped data object
  expect_true(flatten(mapped_sdrgcomp_yaml$steps)$output %in% names(lData_mapped))

  # Needed columns of raw data are actually in raw data and retained in final data
  expect_true(all(names(flatten(mapped_sdrgcomp_yaml$spec)) %in% names(lData[names(mapped_sdrgcomp_yaml$spec)][[1]])))
  expect_true(all(names(flatten(mapped_sdrgcomp_yaml$spec)) %in% names(lData_mapped[[flatten(mapped_sdrgcomp_yaml$steps)$output]])))
})

test_that("mappings now done by individual domain, test that inputs and outputs of STUDCOMP are completed as expected", {

  # For STUDCOMP.yaml
  mapped_studcomp_yaml <- read_yaml(
    system.file("tests", "testqualification", "qualification", "qual_workflows", "1_mappings", "STUDCOMP.yaml", package = "gsm")
  )

  # Requried raw data is in data source
  expect_true(all(names(mapped_studcomp_yaml$spec) %in% names(lData)))

  # Output from yaml is in the mapped data object
  expect_true(flatten(mapped_studcomp_yaml$steps)$output %in% names(lData_mapped))

  # Needed columns of raw data are actually in raw data and retained in final data
  expect_true(all(names(flatten(mapped_studcomp_yaml$spec)) %in% names(lData[names(mapped_studcomp_yaml$spec)][[1]])))
  expect_true(all(names(flatten(mapped_studcomp_yaml$spec)) %in% names(lData_mapped[[flatten(mapped_studcomp_yaml$steps)$output]])))
})

test_that("mappings now done by individual domain, test that inputs and outputs of SUBJ are completed as expected", {

  # For SUBJ.yaml
  mapped_subj_yaml <- read_yaml(
    system.file("tests", "testqualification", "qualification", "qual_workflows", "1_mappings", "SUBJ.yaml", package = "gsm")
  )

  # Requried raw data is in data source
  expect_true(all(names(mapped_subj_yaml$spec) %in% names(lData)))

  # Output from yaml is in the mapped data object
  expect_true(flatten(mapped_subj_yaml$steps)$output %in% names(lData_mapped))

  # Needed columns of raw data are actually in raw data and retained in final data
  expect_true(all(names(flatten(mapped_subj_yaml$spec)) %in% names(lData[names(mapped_subj_yaml$spec)][[1]])))
  expect_true(all(names(flatten(mapped_subj_yaml$spec)) %in% names(lData_mapped[[flatten(mapped_subj_yaml$steps)$output]])))
})

# Priority 2 Mappings

test_that("mappings now done by individual domain, test that inputs and outputs of SUBJ are completed as expected", {

  # For DATACHG.yaml
  mapped_datachg_yaml <- read_yaml(
    system.file("tests", "testqualification", "qualification", "qual_workflows", "1_mappings", "DATACHG.yaml", package = "gsm")
  )

  names(mapped_datachg_yaml$spec)
})
