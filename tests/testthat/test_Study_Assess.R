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
    expect_true(all(map_chr(def, ~class(.)) == "list"))
    expect_equal(names(def$ae$result), c("strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed",
                   "dfAnalyzed", "dfFlagged", "dfSummary", "chart"))
})

# metadata is returned as expected ----------------------------------------
test_that("metadata is returned as expected", {
    ae <- def$ae
    expect_equal(ae$label, "Treatment-Emergent Adverse Events")
    expect_equal(ae$tags, list(Assessment = "Safety", Label = "AEs"))
    expect_equal(ae$mapping, list(functionName = "AE_Map_Raw", params = NULL))
    expect_equal(ae$assessment, list(functionName = "AE_Assess", params = NULL))
    expect_equal(ae$requiredParameters, list(dfAE = c("strIDCol", "strTreatmentEmergentCol"),
                                             dfSUBJ = c("strIDCol", "strSiteCol", "strTimeOnTreatmentCol")))
    expect_equal(ae$filters, list(dfAE = list(strTreatmentEmergentCol = TRUE)))
    expect_equal(ae$name, "ae")
    expect_true(ae$valid)
    expect_true(ae$rawValid)
    expect_equal(ae$result$lParams, list(dfInput = c("c(\"1234\", \"5678\", \"9876\")", "c(\"X010X\", \"X102X\", \"X999X\")",
                                                     "c(2, 0, 0)", "c(3455, 1745, 1233)", "c(0.000578871201157742, 0, 0)"),
                                         lTags = c("myStudy", "Safety", "AEs"), bChart = "TRUE"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
    # expect_snapshot_error(Study_Assess(lData=lData, bQuiet=1))
    # expect_snapshot_error(Study_Assess(lData=lData, lSubjFilters = 1))
    # expect_snapshot_error(Study_Assess(lData=lData, lTags = list(custom = data.frame(a = "hi"))))
    # expect_error(Study_Assess(lData=lData, lAssessments = 1))
    expect_error(Study_Assess(lData=lData, lMapping = data.frame()))
    expect_error(Study_Assess(lSubjFilters=list(notACol="X010X"), bQuiet=TRUE))
})


test_that("lPopFlags filters subject ID as expected",{
    oneSite <- Study_Assess(lSubjFilters=list(strSiteCol="X010X")) %>% suppressWarnings
    expect_equal(oneSite$ae$lRaw$dfSUBJ%>%nrow, 28)
})