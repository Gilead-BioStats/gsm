load(testthat::test_path("testdata/StudyStandard.RData"))

table_interactive <- Overview_Table(StudyStandard)
table <- Overview_Table(StudyStandard, bInteractive = FALSE)

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

