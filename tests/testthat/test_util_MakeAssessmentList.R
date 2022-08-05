
# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  assessment_list <- MakeAssessmentList()

  expect_equal(names(assessment_list),
               c(
                 "ae",
                 "aeGrade",
                 "aeQTL",
                 "consent",
                 "dispStudy",
                 "dispStudyWithdrew",
                 "dispTreatment",
                 "ie",
                 "importantpd",
                 "lb",
                 "lbCategory",
                 "pd",
                 "pdCategory",
                 "sae"
               )
               )
  expect_type(assessment_list, "list")
  expect_true(all(map_lgl(assessment_list, ~ all(names(.) %in% c("label", "tags", "group","workflow", "path", "name")))))
})
