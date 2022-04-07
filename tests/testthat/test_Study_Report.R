test_that("Study Report runs as expected",{
    lAssessments<- Study_Assess(bQuiet=TRUE)
    Study_Report(assessments=lAssessments, meta=list(Project="My Study"))
})

test_that("Study Table Report with AE issue",{
    lData <- list(
        dfSUBJ= clindata::rawplus_subj,
        dfAE=clindata::rawplus_ae,
        dfPD=clindata::rawplus_pd,
        dfCONSENT=clindata::rawplus_consent,
        dfIE=clindata::rawplus_ie
    )
    lData$dfAE[1:100,'SubjectID'] <- NA
    lAssessments <- Study_Assess(lData=lData, bQuiet=FALSE)
    Study_Report(assessments=lAssessments, meta=list(Project="AE Issues"))
})

test_that("Study Table Report with a subset of domains issue",{
    lData <- list(
        dfSUBJ= clindata::rawplus_subj,
        dfCONSENT=clindata::rawplus_consent,
        dfIE=clindata::rawplus_ie
    )
    lAssessments <- Study_Assess(lData=lData, bQuiet=FALSE)
    Study_Report(assessments=lAssessments, meta=list(Project="Consent + IE only"))
})
