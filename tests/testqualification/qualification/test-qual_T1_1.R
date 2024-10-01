source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))
lData_mapped <- RunWorkflows(mappings_wf, lData)

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
