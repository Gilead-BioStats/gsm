source(testthat::test_path("testdata/data.R"))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {

  # single df for AE_Assess
  dfInput <- AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ))

  checks <- CheckInputs(
    context = "AE_Assess",
    dfs = list(dfInput = dfInput),
    bQuiet = TRUE
  )

  expect_true(checks$status)
  expect_true(checks$dfInput$status)
  expect_equal(names(checks), c("dfInput", "status", "mapping"))
  expect_type(checks$dfInput, "list")
  expect_type(checks$status, "logical")
  expect_true(all(map_lgl(checks$dfInput$tests_if, pluck("status"))))
  expect_equal(
    names(checks$dfInput$tests_if),
    c(
      "is_data_frame", "has_required_params", "spec_is_list", "mapping_is_list",
      "mappings_are_character", "has_expected_columns", "columns_have_na",
      "columns_have_empty_values", "cols_are_unique"
    )
  )

  # multiple dfs for IE_Map_Raw()
  checks <- CheckInputs(
    context = "IE_Map_Raw",
    dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ),
    mapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
    bQuiet = TRUE
  )

  expect_true(checks$status)
  expect_true(checks$dfIE$status)
  expect_true(checks$dfSUBJ$status)
  expect_equal(names(checks), c("dfIE", "dfSUBJ", "status", "mapping"))
  expect_type(checks$dfIE, "list")
  expect_type(checks$dfSUBJ, "list")
  expect_type(checks$status, "logical")
  expect_true(all(map_lgl(checks$dfIE$tests_if, pluck("status"))))
  expect_true(all(map_lgl(checks$dfSUBJ$tests_if, pluck("status"))))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_error(CheckInputs(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ)))
  expect_error(CheckInputs(context = "AE_Assess"))
  expect_error(CheckInputs(context = "AE_Assess", dfs = AE_Map_Raw(), bQuiet = "no"))
  expect_false(CheckInputs(context = "IE_Assess", dfs = list(clindata::rawplus_ae, clindata::rawplus_subj))[["status"]])
})


# common errors are caught ------------------------------------------------
test_that("common errors are caught", {
  dfInput <- AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ))
  dfInput$SubjectID[1] <- NA
  check_na <- CheckInputs(context = "AE_Assess", dfs = list(dfInput = dfInput))
  expect_false(check_na$status)
  expect_false(check_na$dfInput$status)
  expect_equal(
    check_na$dfInput$tests_if$columns_have_na$warning,
    "1 NA values found in column: SubjectID"
  )
})

test_that("more than 2 data.frames are mapped accordingly", {
  dfInputThree <- AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ, dfOTHER = dfIE))
  dfInput <- AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ))

  expect_equal(dfInput, dfInputThree)
  expect_equal(class(dfInput), "data.frame")
  expect_equal(class(dfInputThree), "data.frame")
})

test_that("unnamed list objects return FALSE", {
  dfInput <- CheckInputs(context = "IE_Assess", dfs = list(dfAE, dfSUBJ))

  expect_type(dfInput, "list")
  expect_false(dfInput$status)
  expect_false(dfInput$dfInput$status)
})

test_that("mismatched (context + dfs) returns FALSE", {
  dfInput <- CheckInputs(context = "IE_Assess", dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ))

  expect_type(dfInput, "list")
  expect_false(dfInput$status)
  expect_false(dfInput$dfInput$status)
})
