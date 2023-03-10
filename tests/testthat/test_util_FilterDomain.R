source(testthat::test_path("testdata/data.R"))

lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

test_that("basic filter works", {
  ae_test <- FilterDomain(dfAE,
    lMapping = lMapping,
    strDomain = "dfAE",
    strColParam = "strTreatmentEmergentCol",
    strValParam = "strTreatmentEmergentVal",
    bQuiet = TRUE
  )
  expect_equal(
    ae_test,
    dfAE %>% dplyr::filter(treatmentemergent == "Y")
  )
})


test_that("invalid column throws an error", {
  expect_snapshot(ae_test <- FilterDomain(dfAE,
    lMapping = lMapping,
    strDomain = "dfAE",
    strColParam = "strWhateverEmergentCol",
    strValParam = "strWhateverEmergentVal",
    bQuiet = F
  ))
})

test_that("filter to 0 rows throws a warning", {
  dfAE <- dfAE %>%
    dplyr::filter(treatmentemergent == "N")

  expect_equal(
    suppressWarnings(
      FilterDomain(
        dfAE,
        lMapping = lMapping,
        strDomain = "dfAE",
        strColParam = "strTreatmentEmergentCol",
        strValParam = "strTreatmentEmergentVal",
        bQuiet = TRUE
      )
    ) %>%
      nrow(),
    0
  )

  expect_snapshot(FilterDomain(dfAE,
    lMapping = lMapping,
    strDomain = "dfAE",
    strColParam = "strTreatmentEmergentCol",
    strValParam = "strTreatmentEmergentVal",
    bQuiet = FALSE
  ))
})

test_that("invalid mapping is caught", {
  expect_snapshot(FilterDomain(dfAE,
    lMapping = list(this_is = "my mapping"),
    strDomain = "dfAE",
    strColParam = "strTreatmentEmergentCol",
    strValParam = "strTreatmentEmergentVal",
    bQuiet = FALSE
  ))
})

test_that("invalid strDomain is caught", {
  expect_snapshot(FilterDomain(dfAE,
    lMapping = lMapping,
    strDomain = "dfABCD",
    strColParam = "strTreatmentEmergentCol",
    strValParam = "strTreatmentEmergentVal",
    bQuiet = FALSE
  ))
})

test_that("bQuiet works as intended", {
  expect_snapshot(FilterDomain(dfAE,
    lMapping = lMapping,
    strDomain = "dfAE",
    strColParam = "strTreatmentEmergentCol",
    strValParam = "strTreatmentEmergentVal",
    bQuiet = TRUE
  ))

  expect_snapshot(FilterDomain(dfAE,
    lMapping = lMapping,
    strDomain = "dfAE",
    strColParam = "strTreatmentEmergentCol",
    strValParam = "strTreatmentEmergentVal",
    bQuiet = FALSE
  ))
})

test_that("error when 'val' and 'col' are switched", {
  expect_error(FilterDomain(dfAE,
    lMapping = lMapping,
    strDomain = "dfAE",
    strColParam = "strTreatmentEmergentVal",
    strValParam = "strTreatmentEmergentCol",
    bQuiet = TRUE
  ))
})
