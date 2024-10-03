source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

# Priority 1 mappings
test_that("mappings now done by individual domain, test that inputs and outputs of priority 1 mappings are completed as expected", {
  priority1 <- c("AE.yaml", "ENROLL.yaml", "LB.yaml", "PD.yaml", "SDRGCOMP.yaml", "STUDCOMP.yaml", "SUBJ.yaml")

  mapped_p1_yaml <- map(priority1, ~ read_yaml(
    system.file("tests", "testqualification", "qualification", "qual_workflows", "1_mappings", .x, package = "gsm")
  ))

  # Requried raw data is in data source
  iwalk(mapped_p1_yaml, ~ expect_true(all(names(.x$spec) %in% names(lData))))

  # Output from yaml is in the mapped data object
  iwalk(mapped_p1_yaml, ~ expect_true(flatten(.x$steps)$output %in% names(mapped_data)))

  # Needed columns of raw data are actually in raw data and retained in final data
  iwalk(mapped_p1_yaml, ~ expect_true(all(names(flatten(.x$spec)) %in% names(lData[names(.x$spec)][[1]]))))
  iwalk(mapped_p1_yaml, ~ expect_true(all(names(flatten(.x$spec)) %in% names(mapped_data[[flatten(.x$steps)$output]]))))
})


# Priority 2 Mappings

test_that("mappings now done by individual domain, test that inputs and outputs of SUBJ are completed as expected", {
  priority2 <- c("DATACHG.yaml", "DATAENT.yaml", "QUERY.yaml", "SUBJ.yaml")
  # p2workflows <- MakeWorkflowList(c("DATACHG", "DATAENT", "QUERY", "SUBJ"), yaml_path_custom_mappings)
  # test <- map(p2workflows ~ robust_runworkflow(.x, lData))
  mapped_p2_yaml <- map(priority2, ~ read_yaml(
    system.file("tests", "testqualification", "qualification", "qual_workflows", "1_mappings", .x, package = "gsm")
  ))


})
