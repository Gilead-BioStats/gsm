source(testthat::test_path("testdata/data.R"))

df <- RunQTL("qtl0003", lData = lData)

test_that("incorrect file path returns message", {
  expect_snapshot(SaveQTL(df, strPath = "wxyz"))
})

test_that("qtl with bStatus == FALSE returns message", {
  df_error <- RunQTL("qtl0003", lData = list())

  expect_snapshot(SaveQTL(df_error))
})
