source(testthat::test_path("testdata/data.R"))

mapping_rdsl <- list(strIDCol = "SubjectID",
                strSiteCol = "SiteID",
                strExposureCol = "TimeOnTreatment")

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  df <- is_mapping_valid(
    df = dfSUBJ,
    mapping = mapping_rdsl,
    spec=list(vRequired = c("strIDCol", "strSiteCol", "strExposureCol"))
  )

  expect_type(df, "list")
  expect_equal(names(df), c("status", "tests_if"))

  expect_equal(names(df$tests_if), c("is_data_frame", "has_required_params", "spec_is_list","mapping_is_list",
                                     "mappings_are_character", "has_expected_columns", "columns_have_na",
                                     "columns_have_empty_values", "cols_are_unique"))

})


test_that("NA values are caught", {

  dfSUBJ$TimeOnTreatment[1] <- NA
  devtools::load_all()
  df <- is_mapping_valid(
    dfSUBJ,
    mapping = mapping_rdsl,
    spec=list(vRequired = c("strIDCol", "strSiteCol", "strExposureCol"))
  )

  expect_equal("1 NA values found in column: TimeOnTreatment", df$tests_if$columns_have_na$warning)
  expect_equal(FALSE, df$tests_if$columns_have_na$status)
})

test_that("NA values are ignored when specified in vNACols", {
  df <- is_mapping_valid(
    df = dfSUBJ,
    mapping = mapping_rdsl,
    spec=list(
      vNACols = "strExposureCol",
      vRequired = c("strIDCol", "strSiteCol", "strExposureCol")
    )
  )

  expect_equal(TRUE, df$tests_if$columns_have_na$status)
  expect_equal(NA, df$tests_if$columns_have_na$warning)
})

test_that("vUniqueCols are caught", {
  dfSUBJ <- bind_rows(dfSUBJ[1,], dfSUBJ)
  expect_message(
    is_mapping_valid(
      dfSUBJ,
      mapping = mapping_rdsl,
      spec=list(
        vUniqueCols = "strIDCol",
        vRequired = c("strIDCol")
      ),
      bQuiet = F
    )
  )
})

test_that("empty string values are caught", {
  input <- dfSUBJ
  input$SubjectID[1] <- ""
  df <- is_mapping_valid(
    df = input,
    mapping = mapping_rdsl,
    spec=list(
      vNACols = "strExposureCol",
      vRequired = c("strIDCol", "strSiteCol", "strExposureCol")
    )
  )

  expect_equal(FALSE, df$tests_if$columns_have_empty_values$status)
  expect_equal("1 empty string values found in column: SubjectID", df$tests_if$columns_have_empty_values$warning)
  expect_equal(FALSE, df$status)
})


test_that("bQuiet works as intended", {
  expect_message(is_mapping_valid(df = dfSUBJ, mapping = mapping_rdsl, bQuiet = FALSE, spec=list(vRequired = "notACol")))
})



