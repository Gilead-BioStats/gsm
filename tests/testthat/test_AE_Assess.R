
ae_input <- AE_Map_Adam(
    safetyData::adam_adsl,
    safetyData::adam_adae
)

test_that("summary df created as expected and has correct structure",{
    ae_assessment <- AE_Assess(ae_input, vThreshold = c(-5.1, 5.1))
    expect_true(is.list(ae_assessment))
    expect_equal(names(ae_assessment),c("strFunctionName", "lParams", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary", "vTags"))
    expect_true("data.frame" %in% class(ae_assessment$dfInput))
    expect_true("data.frame" %in% class(ae_assessment$dfTransformed))
    expect_true("data.frame" %in% class(ae_assessment$dfAnalyzed))
    expect_true("data.frame" %in% class(ae_assessment$dfFlagged))
    expect_true("data.frame" %in% class(ae_assessment$dfSummary))
    expect_type(ae_assessment$strFunctionName, "character")
    expect_type(ae_assessment$lParams, "list")

})


test_that("incorrect inputs throw errors",{
    expect_error(AE_Assess(list()))
    expect_error(AE_Assess("Hi"))
    expect_error(AE_Assess(ae_input, strLabel=123))
    expect_error(AE_Assess(ae_input, strMethod="abacus"))
    expect_error(AE_Assess(ae_input %>% select(-SubjectID)))
    expect_error(AE_Assess(ae_input %>% select(-SiteID)))
    expect_error(AE_Assess(ae_input %>% select(-Count)))
    expect_error(AE_Assess(ae_input %>% select(-Exposure)))
    expect_error(AE_Assess(ae_input %>% select(-Rate)))
    expect_error(AE_Assess(ae_input, strMethod=c("wilcoxon", "poisson")))
})


test_that("correct function and params are returned", {
    ae_assessment <- AE_Assess(ae_input, vThreshold = c(-5.1, 5.1))
    expect_equal("AE_Assess()", ae_assessment$strFunctionName)
    expect_equal(ae_assessment$lParams$dfInput, "ae_input")
    expect_equal(ae_assessment$lParams$vThreshold[2], "-5.1")
    expect_equal(ae_assessment$lParams$vThreshold[3], "5.1")
})

test_that("invalid lTags throw errors",{
    expect_error(AE_Assess(ae_input, vThreshold = c(-5.1, 5.1), lTags="hi mom"))
    expect_error(AE_Assess(ae_input, vThreshold = c(-5.1, 5.1), lTags=list("hi","mom")))
    expect_error(AE_Assess(ae_input, vThreshold = c(-5.1, 5.1), lTags=list(greeting="hi","mom")))
    expect_silent(AE_Assess(ae_input, vThreshold = c(-5.1, 5.1), lTags=list(greeting="hi",person="mom")))
})