test_that("Assessment Report with all Valid assessments",{
    lAssessments <- Study_Assess(bQuiet=TRUE)
    a<-Study_AssessmentReport(lAssessments=lAssessments)
    expect_true(is.data.frame(a$dfAllChecks))
    expect_true(is.data.frame(a$dfSummary))
})


test_that("Assessment Report with an issue in dfSUBJ",{
    lData <- list(
        dfSUBJ= clindata::rawplus_subj,
        dfAE=clindata::rawplus_ae,
        dfPD=clindata::rawplus_pd,
        dfCONSENT=clindata::rawplus_consent,
        dfIE=clindata::rawplus_ie
    )
    lData$dfSUBJ[1,'SubjectID'] <- NA

    lAssessments <- Study_Assess(lData=lData, bQuiet=TRUE)
    a<-Study_AssessmentReport(lAssessments=lAssessments)
    expect_true(is.data.frame(a$dfAllChecks))
    expect_true(is.data.frame(a$dfSummary))
})

