source(testthat::test_path("testdata/data.R"))

lMapping <- yaml::read_yaml(system.file('mapping','rawplus.yaml', package = 'clindata'))

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
                                bQuiet = F))
})
