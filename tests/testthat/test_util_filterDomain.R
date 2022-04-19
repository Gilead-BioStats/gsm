source(testthat::test_path("testdata/data.R"))

test_that("basic filter works", {
    ae_test<-FilterDomain(dfAE, "AE_TE_FLAG", TRUE)
    expect_equal(
        ae_test,
        dfAE%>%filter(AE_TE_FLAG==TRUE)
    )
})

test_that("can filter on multiple values", {
    ae_test2<-FilterDomain(dfAE, "AE_GRADE", c(1,3))
    expect_equal(
        ae_test2,
        dfAE%>%filter(AE_GRADE %in% c(1,3))
    )
})

test_that("invalid column throws an error", {
    expect_error(FilterDomain(dfAE, "AE_NotACol", c(1,3)))
})

test_that("filter to 0 rows throws a warning", {
    expect_equal(
        nrow(FilterDomain(dfAE, "AE_GRADE", c(6,7))),
        0
    )
    expect_message(FilterDomain(dfAE, "AE_GRADE", c(6,7),bQuiet=FALSE))
})
