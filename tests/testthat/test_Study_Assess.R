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
    expect_equal(names(def$ae$lResults), c("strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed",
                   "dfAnalyzed", "dfFlagged", "dfSummary", "chart"))
})

# metadata is returned as expected ----------------------------------------
test_that("metadata is returned as expected", {
    ae <- def$ae
    expect_equal(ae$label, "Treatment-Emergent Adverse Events")
    expect_equal(ae$tags, list(Assessment = "Safety", Label = "AEs"))
    expect_equal(ae$lResults$strFunctionName, "AE_Assess()")
    expect_equal(ae$lSteps$AE_Map_Raw$spec, list(dfAE = list(requiredParams = "strIDCol"),
                                                  dfSUBJ = list(requiredParams = c("strIDCol", "strSiteCol", "strTimeOnTreatmentCol"))))
    expect_equal(ae$lSteps$FilterDomain$spec, list(dfAE = list(requiredParams = "strTreatmentEmergentCol")))
    expect_equal(ae$name, "ae")
    expect_true(ae$bStatus)
})


# incorrect inputs return bStatus == FALSE --------------------------------
test_that("incorrect inputs return bStatus == FALSE", {

  data <- Study_Assess(lData=data.frame(), bQuiet = TRUE) %>%
    map(~.x %>% pluck('lSteps')) %>%
    flatten() %>%
    map(~ .x[['status']])

    expect_true(all(map_lgl(data, ~.x == FALSE)))
})

