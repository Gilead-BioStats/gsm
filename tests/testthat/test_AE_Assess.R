
ae_input <- AE_Map_Adam(
    safetyData::adam_adsl,
    safetyData::adam_adae
)

test_that("summary df created as expected and has correct structure",{
    ae_assessment <- AE_Assess(ae_input, strLabel = "test label!", vThreshold = c(-5.1, 5.1))
    expect_true(is.list(ae_assessment))
    expect_equal(names(ae_assessment),c("strFunctionName", "lParams", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary"))
    expect_true("data.frame" %in% class(ae_assessment$dfInput))
    expect_true("data.frame" %in% class(ae_assessment$dfTransformed))
    expect_true("data.frame" %in% class(ae_assessment$dfAnalyzed))
    expect_true("data.frame" %in% class(ae_assessment$dfFlagged))
    expect_true("data.frame" %in% class(ae_assessment$dfSummary))
    expect_type(ae_assessment$strFunctionName, "character")
    expect_type(ae_assessment$lParams, "list")

})


test_that("incorrect inputs throw errors",{
    expect_error(AE_Assess(list()),"dfInput is not a data.frame")
    expect_error(AE_Assess("Hi"),"dfInput is not a data.frame")
    expect_error(AE_Assess(ae_input, strLabel=123),"strLabel is not character")
    expect_error(AE_Assess(ae_input, strMethod="abacus"),"strMethod is not 'poisson' or 'wilcoxon'")
    expect_error(AE_Assess(ae_input %>% select(-SubjectID)),"One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput")
    expect_error(AE_Assess(ae_input %>% select(-SiteID)),"One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput")
    expect_error(AE_Assess(ae_input %>% select(-Count)),"One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput")
    expect_error(AE_Assess(ae_input %>% select(-Exposure)),"One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput")
    expect_error(AE_Assess(ae_input %>% select(-Rate)),"One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput")
    expect_error(AE_Assess(ae_input, strMethod=c("wilcoxon", "poisson")),"strMethod must be length 1")
})


test_that("correct function and params are returned", {
  ae_assessment <- AE_Assess(ae_input, strLabel = "test label!", vThreshold = c(-5.1, 5.1))
  expect_equal("AE_Assess()", ae_assessment$strFunctionName)
  expect_equal(ae_assessment$lParams$dfInput, "ae_input")
  expect_equal(ae_assessment$lParams$vThreshold[2], "-5.1")
  expect_equal(ae_assessment$lParams$vThreshold[3], "5.1")
  expect_equal(ae_assessment$lParams$strLabel, "test label!")
})

