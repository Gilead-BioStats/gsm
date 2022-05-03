source(testthat::test_path("testdata/data.R"))

lMapping <- clindata::mapping_rawplus

test_that("basic filter works", {

  ae_test <- FilterDomain(dfAE,
                          lMapping = lMapping,
                          strDomain = "dfAE",
                          strColParam = "strTreatmentEmergentCol",
                          strValParam = "strTreatmentEmergentVal")
    expect_equal(
        ae_test,
        dfAE%>%filter(AE_TE_FLAG==TRUE))
})


test_that("invalid column throws an error", {

    expect_snapshot(ae_test <- FilterDomain(dfAE,
                                           lMapping = lMapping,
                                           strDomain = "dfAE",
                                           strColParam = "strWhateverEmergentCol",
                                           strValParam = "strWhateverEmergentVal",
                                           bQuiet = F))
})

test_that("filter to 0 rows throws a warning", {

  dfAE <- dfAE %>%
    filter(AE_TE_FLAG == FALSE)

    expect_equal(FilterDomain(dfAE,
                                         lMapping = lMapping,
                                         strDomain = "dfAE",
                                         strColParam = "strTreatmentEmergentCol",
                                         strValParam = "strTreatmentEmergentVal") %>%
                   nrow(),
        0
    )
    expect_snapshot(FilterDomain(dfAE,
                                lMapping = lMapping,
                                strDomain = "dfAE",
                                strColParam = "strTreatmentEmergentCol",
                                strValParam = "strTreatmentEmergentVal",
                                bQuiet = FALSE))
})

test_that("invalid mapping is caught", {
  FilterDomain(dfAE,
               lMapping = list(this_is = "my mapping"),
               strDomain = "dfAE",
               strColParam = "strTreatmentEmergentCol",
               strValParam = "strTreatmentEmergentVal",
               bQuiet = FALSE)
})

test_that("invalid strDomain is caught", {
  expect_snapshot(FilterDomain(dfAE,
               lMapping = lMapping,
               strDomain = "dfABCD",
               strColParam = "strTreatmentEmergentCol",
               strValParam = "strTreatmentEmergentVal",
               bQuiet = FALSE))

})

test_that("bQuiet works as intended", {
  expect_silent(FilterDomain(dfAE,
                             lMapping = lMapping,
                             strDomain = "dfAE",
                             strColParam = "strTreatmentEmergentCol",
                             strValParam = "strTreatmentEmergentVal",
                             bQuiet = FALSE))

  expect_snapshot(FilterDomain(dfAE,
                          lMapping = lMapping,
                          strDomain = "dfAE",
                          strColParam = "strTreatmentEmergentCol",
                          strValParam = "strTreatmentEmergentVal",
                          bQuiet = FALSE))
})

test_that("error when 'val' and 'col' are switched", {
  expect_error(FilterDomain(dfAE,
               lMapping = lMapping,
               strDomain = "dfAE",
               strColParam = "strTreatmentEmergentVal",
               strValParam = "strTreatmentEmergentCol",
               bQuiet = FALSE))
})
