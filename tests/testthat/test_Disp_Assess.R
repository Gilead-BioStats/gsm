dispInput <- Disp_Map(dfDisp = safetyData::adam_adsl,strCol = "DCREASCD",strReason = "adverse event")


test_that("summary df created as expected and has correct structure", {
  dispAssess <- Disp_Assess(dispInput)

  expect_true(is.data.frame(dispAssess))
  expect_equal(names(dispAssess),c("Assessment", "Label", "SiteID", "N", "PValue", "Flag"))
})


test_that("list of df created when bDataList=TRUE",{
  dispAssess <- Disp_Assess(dispInput, bDataList = TRUE)
  expect_true(is.list(dispAssess))
  expect_equal(names(dispAssess),c("dfDisp", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary"))
  expect_equal(length(dispAssess), 5)
  expect_true("data.frame" %in% class(dispAssess[[1]]))
  expect_true("data.frame" %in% class(dispAssess[[2]]))
  expect_true("data.frame" %in% class(dispAssess[[3]]))
  expect_true("data.frame" %in% class(dispAssess[[4]]))
  expect_true("data.frame" %in% class(dispAssess[[5]]))
})


test_that("incorrect inputs throw errors",{
  expect_error(Disp_Assess(list()))
  expect_error(Disp_Assess("Hi"))
  expect_error(Disp_Assess(dispInput, cLabel=123))
  expect_error(Disp_Assess(dispInput, cMethod="abacus"))
  expect_error(Disp_Assess(dispInput, bDataList="Yes"))
  expect_error(Disp_Assess(dispInput, vThreshold = "something"))
  expect_error(Disp_Assess(dispInput, dfDisp = data.frame(Column1 = 1)))
  expect_error(Disp_Assess(dispInput %>% select(-SubjectID)))
  expect_error(Disp_Assess(dispInput %>% select(-SiteID)))
  expect_error(Disp_Assess(dispInput %>% select(-Count)))
})


