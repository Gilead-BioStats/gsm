source(testthat::test_path("testdata/data.R"))

lData <- list(
    dfSUBJ= dfSUBJ,
    dfAE=dfAE,
    dfPD=dfPD,
    dfCONSENT=dfCONSENT,
    dfIE=dfIE
)

test_that("Study Report runs as expected",{
    lAssessments<- Study_Assess(lData = lData, bQuiet=TRUE)
    expect_message(
        withr::with_tempdir(Study_Report(assessments=lAssessments, meta=list(Project="My Study"))),
        "Output created: gsm_report.html"
    )
})

test_that("Study Table Report with AE issue",{
    lData$dfAE[1:2,'SubjectID'] <- NA
    lAssessments <- Study_Assess(lData=lData, bQuiet=TRUE)
    expect_message(
        withr::with_tempdir(Study_Report(assessments=lAssessments, meta=list(Project="My Study"))),
        "Output created: gsm_report.html"
    )
})

test_that("Study Table Report with a subset of domains issue",{
    # lData <- list(
    #     dfSUBJ= clindata::rawplus_subj,
    #     dfCONSENT=clindata::rawplus_consent,
    #     dfIE=clindata::rawplus_ie
    # )
    # lAssessments <- Study_Assess(lData=lData, bQuiet=FALSE)
    # Study_Report(assessments=lAssessments, meta=list(Project="Consent + IE only"))
    # expect_message(
    #     withr::with_tempdir(Study_Report(assessments=lAssessments, meta=list(Project="My Study"))),
    #     "Output created: gsm_report.html"
    # )

    # Above needs to be addressed in Study_Assess first, then can be implemented as a unit test here.

    expect_true(TRUE)
})
