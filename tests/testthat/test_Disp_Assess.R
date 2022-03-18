dispInput <- Disp_Map(
  dfDisp = safetyData::adam_adsl,
  strReason = "adverse event"
  )

test_that("summary df created as expected and has correct structure", {
  dispAssess <- Disp_Assess(dispInput)
  expect_true(is.list(dispAssess))
  expect_equal(names(dispAssess), c("strFunctionName", "lParams", "dfDisp", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary"))
  expect_true("data.frame" %in% class(dispAssess$dfDisp))
  expect_true("data.frame" %in% class(dispAssess$dfTransformed))
  expect_true("data.frame" %in% class(dispAssess$dfAnalyzed))
  expect_true("data.frame" %in% class(dispAssess$dfFlagged))
  expect_true("data.frame" %in% class(dispAssess$dfSummary))
  expect_type(dispAssess$strFunctionName, "character")
  expect_type(dispAssess$lParams, "list")
  expect_equal(length(dispAssess), 7)
})

test_that("incorrect inputs throw errors",{
  expect_error(Disp_Assess(list()))
  expect_error(Disp_Assess("Hi"))
  expect_error(Disp_Assess(dispInput, strLabel=123))
  expect_error(Disp_Assess(dispInput, strMethod="abacus"))
  expect_error(Disp_Assess(dispInput, vThreshold = "something"))
  expect_error(Disp_Assess(dispInput, vThreshold = c(1, 2, 3)))
  expect_error(Disp_Assess(dfDisp = data.frame(Column1 = 1)))
  expect_error(Disp_Assess(dispInput %>% select(-SubjectID)))
  expect_error(Disp_Assess(dispInput %>% select(-SiteID)))
  expect_error(Disp_Assess(dispInput %>% select(-Count)))
})


test_that("chisq method works as intended", {

  expect_silent(
    Disp_Assess(
      dispInput,
      strMethod = "chisquare"
    ) %>%
      suppressWarnings
  )

})

test_that("if chisq upper threshold exists, it is caught", {

  expect_error(
    Disp_Assess(
      dispInput,
      strMethod = "chisquare",
      vThreshold = c(0.0005, 0.001)
    ) %>%
      suppressWarnings
  )

})
