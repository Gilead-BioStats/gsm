dfRDSL <- clindata::rawplus_rdsl

mapping_rdsl <- list(id_col = "SubjectID",
                site_col = "SiteID",
                exposure_col = "TimeOnTreatment")

test_that("correct structure is returned", {
  df <- is_mapping_valid(df = dfRDSL, mapping = mapping_rdsl)

  expect_type(df, "list")

  expect_equal(
    names(df),
    c("status", "tests_if")
    )

  expect_equal(
    names(df$tests_if),
    c("is_data_frame", "has_rows", "mapping_is_list", "mappings_are_character",
      "has_expected_columns", "columns_have_na", "cols_are_unique")
  )


})


test_that("NA values are caught", {
  df <- is_mapping_valid(df = dfRDSL, mapping = mapping_rdsl)

  expect_equal(
    df$tests_if$columns_have_na$warning,
    "3 NA values found in column: TimeOnTreatment"
    )

  expect_equal(
    df$tests_if$columns_have_na$status,
    FALSE
    )

})

test_that("NA values are ignored when specified in na_cols", {
  df <- is_mapping_valid(df = dfRDSL, mapping = mapping_rdsl, na_cols = "TimeOnTreatment")

  expect_equal(
    df$tests_if$columns_have_na$status,
    TRUE
  )

  expect_null(
    df$tests_if$columns_have_na$warning
  )

})


test_that("bQuiet works as intended", {

  expect_warning(is_mapping_valid(df = dfRDSL, mapping = mapping_rdsl, bQuiet = FALSE))

})
