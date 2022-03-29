



test_that("Warning is provided if strCol or strValue not found", {
  expect_warning(util_filter_df(clindata::rawplus_covlab, strCol = "Not a Column", strValue = 1 ))
  expect_warning(util_filter_df(clindata::rawplus_covlab, strCol = "TOXFLG", strValue = "noval" ))

})


test_that("entire dataframe returned if strCol or strValue not found or NULL", {
  expect_equal(suppressWarnings(util_filter_df(clindata::rawplus_covlab, strCol = "Not a Column", strValue = 1 )),clindata::rawplus_covlab )
  expect_equal(suppressWarnings(util_filter_df(clindata::rawplus_covlab, strCol = "TOXFLG", strValue = "noval" )),clindata::rawplus_covlab )
  expect_equal(suppressWarnings(util_filter_df(clindata::rawplus_covlab, strCol = NULL, strValue = NULL )),clindata::rawplus_covlab )
  expect_equal(suppressWarnings(util_filter_df(clindata::rawplus_covlab, strCol = "TOXFLG", strValue = NULL)),clindata::rawplus_covlab )
  expect_equal(suppressWarnings(util_filter_df(clindata::rawplus_covlab, strCol = NULL, strValue = 1)),clindata::rawplus_covlab )
})

test_that("filtered results are returned correctly", {
  
  data <- util_filter_df(covlab, strCol = "LBTEST", strValue = "Monocytes") %>% 
    pull(LBTEST)
  
  expect_true(all(data == "Monocytes"))
  
})
