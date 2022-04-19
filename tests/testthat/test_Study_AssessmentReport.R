source(testthat::test_path("testdata/data.R"))

lData <- list(
    dfSUBJ = dfSUBJ,
    dfAE = dfAE,
    dfPD = dfPD,
    dfCONSENT = dfCONSENT,
    dfIE = dfIE
)

test_that("Assessment Report with all Valid assessments",{
    lAssessments <- Study_Assess(bQuiet=TRUE)
    a<-Study_AssessmentReport(lAssessments=lAssessments)
    expect_true(is.data.frame(a$dfAllChecks))
    expect_true(is.data.frame(a$dfSummary))
})


test_that("Assessment Report with an issue in dfSUBJ",{
    lData <- list(
        dfSUBJ = dfSUBJ,
        dfAE = dfAE,
        dfPD = dfPD,
        dfCONSENT = dfCONSENT,
        dfIE = dfIE
    )

    lData$dfSUBJ[1,'SubjectID'] <- NA

    lAssessments <- Study_Assess(lData=lData, bQuiet=TRUE)
    a<-Study_AssessmentReport(lAssessments=lAssessments)
    expect_true(is.data.frame(a$dfAllChecks))
    expect_true(is.data.frame(a$dfSummary))
})

test_that("Assessment Report fails with wrong input", {
    expect_error(Study_AssessmentReport(lAssessments = TRUE))
    expect_error(Study_AssessmentReport(lAssessments = list()))
})

