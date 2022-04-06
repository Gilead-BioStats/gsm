lData <- list(
    subj= clindata::rawplus_subj %>% filter(!is.na(TimeOnTreatment)),
    ae=clindata::rawplus_ae,
    pd=clindata::rawplus_pd,
    consent=clindata::rawplus_consent,
    ie=clindata::rawplus_ie
)

#lMapping <- yaml::read_yaml("../clindata/inst/mapping/rawplus.yaml")
devtools::load_all()
test_pass<- Study_Assess(lData=lData)
test_fail<- Study_Assess()

def <- Study_Assess(lData=lData, bQuiet=TRUE)

test_that("lPopFlags filters subject ID as expected",{
    oneSite <- Study_Assess(lPopFlags=list(strSiteCol="X010X"),bReturnInputs=TRUE, bQuiet=TRUE)
    expect_equal(oneSite$lData$subj%>%nrow, 28)
})
