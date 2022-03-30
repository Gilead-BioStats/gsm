# lAssessments <- list(
#     ae = read_yaml("./inst/assessments/ae.yaml"),
#     sae = read_yaml("./inst/assessments/sae.yaml")
# )

# lData <- list(
#     subj= clindata::rawplus_rdsl,
#     ae=clindata::rawplus_ae,
#     pd=clindata::rawplus_pd,
#     consent=clindata::rawplus_consent,
#     ie=clindata::rawplus_ie
# )

#lMapping <- yaml::read_yaml("../clindata/inst/mapping/rawplus.yaml")
devtools::load_all()
def <- Study_Assess(lMapping=lMapping)

test_that("lPopFlags filters subject ID as expected",{
    oneSite <- Study_Assess(lPopFlags=list(strSiteCol="X010X"),bReturnInputs=TRUE)
    expect_equal(oneSite$lData$Subj%>%nrow, 28)
})

test_that("Assessment data filtered as expected",{
    te_ae<- clindata::rawplus_ae %>% filter(.data$AE_TEFLAG==TRUE)
    expect_equal( def$ae$lRaw$ae %>% nrow, te_ae %>% nrow)
    
    serious_te_ae <- te_ae %>% filter(.data$AE_Serious=="YES")
    expect_equal( def$sae$lRaw$ae %>% nrow, serious_te_ae %>% nrow)
})