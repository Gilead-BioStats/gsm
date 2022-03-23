dfPD <- clindata::raw_protdev %>%
  filter(SUBJID != "")

dfRDSL <- clindata::rawplus_rdsl %>%
  filter(RandFlag == "Y")

pd_input <- PD_Map_Raw(dfPD, dfRDSL) %>% suppressWarnings

test_that("output is created as expected",{
  pd_assessment <- PD_Assess(pd_input)
  expect_true(is.list(pd_assessment))
  expect_equal(names(pd_assessment),c("strFunctionName", "lParams","lTags", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary"))
  expect_true("data.frame" %in% class(pd_assessment$dfInput))
  expect_true("data.frame" %in% class(pd_assessment$dfTransformed))
  expect_true("data.frame" %in% class(pd_assessment$dfAnalyzed))
  expect_true("data.frame" %in% class(pd_assessment$dfFlagged))
  expect_true("data.frame" %in% class(pd_assessment$dfSummary))
  expect_type(pd_assessment$strFunctionName, "character")
  expect_type(pd_assessment$lParams, "list")
  expect_type(pd_assessment$lTags, "list")
})

test_that("strMethod = 'wilcoxon' does not throw error",{
  expect_silent(PD_Assess(pd_input, strMethod = "wilcoxon"))
})

test_that("correct function and params are returned", {
  pd_assessment <- PD_Assess(pd_input, vThreshold = c(-5,5), strMethod = "poisson")
  expect_equal("PD_Assess()", pd_assessment$strFunctionName)
  expect_equal("-5", pd_assessment$lParams$vThreshold[2])
  expect_equal("5", pd_assessment$lParams$vThreshold[3])
})

test_that("incorrect inputs throw errors",{
  expect_error(PD_Assess(list()))
  expect_error(PD_Assess("Hi"))
  expect_error(PD_Assess(pd_input, strLabel=123))
  expect_error(PD_Assess(pd_input, strMethod="abacus"))
  expect_error(PD_Assess(pd_input %>% select(-SubjectID)))
  expect_error(PD_Assess(pd_input %>% select(-SiteID)))
  expect_error(PD_Assess(pd_input %>% select(-Count)))
  expect_error(PD_Assess(pd_input %>% select(-Exposure)))
  expect_error(PD_Assess(pd_input %>% select(-Rate)))
  expect_error(PD_Assess(pd_input, strMethod=c("wilcoxon", "poisson")))
  expect_error(PD_Assess(pd_input, vThreshold = "A"))
  expect_error(PD_Assess(pd_input, vThreshold = 1))
})

test_that("invalid lTags throw errors",{
    expect_error(PD_Assess(pd_input, vThreshold = c(-5.1, 5.1), lTags="hi mom"))
    expect_error(PD_Assess(pd_input, vThreshold = c(-5.1, 5.1), lTags=list("hi","mom")))
    expect_error(PD_Assess(pd_input, vThreshold = c(-5.1, 5.1), lTags=list(greeting="hi","mom")))
    expect_silent(PD_Assess(pd_input, vThreshold = c(-5.1, 5.1), lTags=list(greeting="hi",person="mom")))
})

test_that("NA in dfInput$Count results in Error for PD_Assess",{
  pd_input_in <- pd_input; pd_input_in[1,"Count"] = NA
  expect_error(PD_Assess(pd_input_in))
})

test_that("problematic lTags names are caught", {

  expect_error(
    PD_Assess(pd_input, lTags = list(SiteID = "")),
    "lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'"
  )

  expect_error(
    PD_Assess(pd_input, lTags = list(N = "")),
    "lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'"
  )

  expect_error(
    PD_Assess(pd_input, lTags = list(Score = "")),
    "lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'"
  )

  expect_error(
    PD_Assess(pd_input, lTags = list(Flag = "")),
    "lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'"
  )

})

