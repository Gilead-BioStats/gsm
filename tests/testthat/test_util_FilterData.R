source(testthat::test_path("testdata/data.R"))

lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

test_that("basic filter works", {
  ae_test <- FilterData(
    dfAE,
    "treatmentemergent",
    "Y"
  )
  expect_equal(
    ae_test,
    dfAE %>% dplyr::filter(treatmentemergent == "Y")
  )
})


test_that("invalid column throws an error", {
  expect_error(ae_test <- FilterData(
    dfAE,
    "strWhateverEmergentCol",
    "strWhateverEmergentVal"
  ))
})

test_that("filter to 0 rows throws a warning", {
  dfAE <- dfAE %>%
    dplyr::filter(treatmentemergent == "Y")

  expect_equal(
    suppressWarnings(
      FilterData(
        dfAE,
        "treatmentemergent",
        "N"
      )
    ) %>%
      nrow(),
    0
  )
})


test_that("bQuiet works as intended", {
  expect_snapshot(FilterData(dfAE,
    "treatmentemergent",
    "Y",
    bQuiet = FALSE
  ))
})

test_that("error when 'val' and 'col' are switched", {
  expect_error(FilterData(
    dfAE,
    "Y",
    "treatmentemergent"
  ))
})
