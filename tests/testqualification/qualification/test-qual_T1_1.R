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

test_that("mappings now done by individual domain, test that inputs and outputs of priority 2 mappings are completed as expected", {
  priority2 <- c("DATACHG.yaml", "DATAENT.yaml", "QUERY.yaml")

  mapped_p2_yaml <- map(priority2, ~ read_yaml(
    system.file("tests", "testqualification", "qualification", "qual_workflows", "1_mappings", .x, package = "gsm")
  ))

  iwalk(mapped_p2_yaml, ~ expect_true(all(names(.x$spec) %in% c(names(lData), "Mapped_SUBJ"))))

  iwalk(mapped_p2_yaml, ~ expect_true(flatten(.x$steps)$output %in% c(names(mapped_data), "Temp_SubjectLookup")))

  iwalk(mapped_p2_yaml, ~ expect_true(all(names(flatten(.x$spec)) %in% c(names(lData[names(.x$spec)][[1]]), names(lData["Raw_SUBJ"][[1]])))))
})

# Priority 3 Mappings

test_that("mappings now done by individual domain, test that inputs and outputs of priority 3 mappings are completed as expected", {
  priority3 <- c("COUNTRY.yaml", "SITE.yaml", "STUDY.yaml")

  mapped_p3_yaml <- map(priority3, ~ read_yaml(
    system.file("tests", "testqualification", "qualification", "qual_workflows", "1_mappings", .x, package = "gsm")
  ))

  iwalk(mapped_p3_yaml, ~ expect_true(all(names(.x$spec) %in% c(names(lData), "Mapped_SUBJ"))))

  temp_objs <- c(
    "Temp_CountryCountsWide",
    "Temp_CTMSSiteWide", "Temp_CTMSSite", "Temp_SiteCountsWide", "Temp_SiteCounts",
    "Temp_CTMSStudyWide", "Temp_CTMSStudy", "Temp_StudyCountsWide", "Temp_StudyCounts"
  )

  iwalk(mapped_p3_yaml, ~ expect_true(flatten(.x$steps)$output %in% c(names(mapped_data), temp_objs)))

  iwalk(mapped_p3_yaml, ~ expect_true(all(names(flatten(.x$spec)) %in% c(names(lData[names(.x$spec)][[1]]), names(lData["Raw_SUBJ"][[1]])))))
})
