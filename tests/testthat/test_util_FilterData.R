source(testthat::test_path("testdata/data.R"))

lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

test_that("basic filter works", {
  ae_test <- FilterData(dfAE,
                          "AE_TE_FLAG",
                          TRUE
  )
  expect_equal(
    ae_test,
    dfAE %>% filter(AE_TE_FLAG == TRUE)
  )
})


test_that("invalid column throws an error", {
  expect_error(ae_test <- FilterData(dfAE,
                                          "strWhateverEmergentCol",
                                          "strWhateverEmergentVal"
  ))
})

test_that("filter to 0 rows throws a warning", {
  dfAE <- dfAE %>%
    filter(AE_TE_FLAG == FALSE)

  expect_equal(suppressWarnings(
    FilterData(
      dfAE,
      "AE_TE_FLAG",
      TRUE
    )
  ) %>%
    nrow(),
  0)
  expect_snapshot(FilterData(dfAE,
    "AE_TE_FLAG",
    TRUE,
    bQuiet = FALSE
  ))
})


test_that("bQuiet works as intended", {
  expect_snapshot(FilterData(dfAE,
                               "AE_TE_FLAG",
                               TRUE,
                               bQuiet = FALSE
  ))
})

test_that("error when 'val' and 'col' are switched", {
  expect_error(FilterData(dfAE,
                            TRUE,
                            "AE_TE_FLAG"
  ))
})

