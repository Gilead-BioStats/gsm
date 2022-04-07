lData <- list(
    dfSUBJ= clindata::rawplus_subj,
    dfAE=clindata::rawplus_ae,
    dfPD=clindata::rawplus_pd,
    dfCONSENT=clindata::rawplus_consent,
    dfIE=clindata::rawplus_ie
)

def <- Study_Assess(lData=lData, bQuiet=TRUE)

test_that("lPopFlags filters subject ID as expected",{
    oneSite <- Study_Assess(lSubjFilters=list(strSiteCol="X010X"),bQuiet=TRUE) %>% suppressWarnings
    expect_equal(oneSite$ae$lRaw$dfSUBJ%>%nrow, 28)
})


test_that("invalid lPopFlag throws error",{
    expect_error(Study_Assess(lSubjFilters=list(notACol="X010X"), bQuiet=TRUE))
})