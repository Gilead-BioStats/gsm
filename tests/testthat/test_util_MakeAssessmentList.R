
# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  assessment_list <- MakeAssessmentList()

  expect_equal(names(assessment_list), c("ae", "consent", "ie", "importantpd", "pd", "sae"))
  expect_type(assessment_list, "list")
  expect_true(all(map_lgl(assessment_list, ~ all(names(.) %in% c("label", "tags", "workflow", "path", "name")))))
})
