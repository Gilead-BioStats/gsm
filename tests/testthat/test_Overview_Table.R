source(testthat::test_path("testdata/data.R"))

study <- Study_Assess(lAssessments = MakeWorkflowList(strNames = c("kri0001", "kri0005")))

table_interactive <- Overview_Table(study)
table <- Overview_Table(study, bInteractive = FALSE)

testthat::test_that("interactive table structure is returned as expected", {
  expect_true(
    all(c("datatables", "htmlwidget") %in% class(table_interactive))
  )
})


testthat::test_that("non-interactive table structure is returned as expected", {
  expect_true(
    all(c("tbl_df", "tbl", "data.frame") %in% class(table))
  )
})
