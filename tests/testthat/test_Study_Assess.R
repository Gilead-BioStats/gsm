source(testthat::test_path("testdata/data.R"))

lData <- list(
    dfSUBJ = dfSUBJ,
    dfAE = dfAE,
    dfPD = dfPD,
    dfCONSENT = dfCONSENT,
    dfIE = dfIE
)

def <- Study_Assess(lData=lData, bQuiet=TRUE)

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
    expect_equal(6, length(def))
    expect_equal(c("ae", "consent", "ie", "importantpd", "pd", "sae"), names(def))

})


test_that("lPopFlags filters subject ID as expected",{
    oneSite <- Study_Assess(lSubjFilters=list(strSiteCol="X010X")) %>% suppressWarnings
    expect_equal(oneSite$ae$lRaw$dfSUBJ%>%nrow, 28)
})


test_that("invalid lPopFlag throws error",{
    expect_error(Study_Assess(lSubjFilters=list(notACol="X010X")))
})
