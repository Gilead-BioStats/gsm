
ae_input <- AE_Map_Adam(
    safetyData::adam_adsl,
    safetyData::adam_adae
)

test_that("summary df created as expected and has correct structure",{
    ae_assessment <- AE_Assess(ae_input)
    expect_true(is.list(ae_assessment))
    expect_equal(names(ae_assessment),c("functionName", "params", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary"))
    expect_true("data.frame" %in% class(ae_assessment$dfInput))
    expect_true("data.frame" %in% class(ae_assessment$dfTransformed))
    expect_true("data.frame" %in% class(ae_assessment$dfAnalyzed))
    expect_true("data.frame" %in% class(ae_assessment$dfFlagged))
    expect_true("data.frame" %in% class(ae_assessment$dfSummary))
    expect_type(ae_assessment$functionName, "character")
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
  ae_assessment <- AE_Assess(ae_input, strMethod = "wilcoxon")
  expect_equal("AE_Assess()", ae_assessment$functionName)
  expect_equal("AE_Assess(ae_input, strMethod = \"wilcoxon\")", ae_assessment$params)
})

