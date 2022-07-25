source(testthat::test_path("testdata/data.R"))


dfInput <- Disp_Map_Raw(
  dfs = list(dfDISP = dfDISP,
             dfSUBJ = dfSUBJ)
)


dfTransformed <- Transform_EventCount(
  dfInput,
  strCountCol = "Count",
  strKRILabel = "Discontinuation Reasons/Site",
  strGroupCol = "SiteID"
)

test_that("output created as expected and has correct structure", {
  chisq <- suppressWarnings(Analyze_Chisq(dfTransformed))

  expect_true(is.data.frame(chisq))

  expect_equal(
    names(chisq),
    c("GroupID", "GroupLabel", "TotalCount", "TotalCount_Other", "N", "N_Other", "Prop", "Prop_Other", "KRI", "KRILabel", "Statistic", "Score", "ScoreLabel")
  )
})


test_that("incorrect inputs throw errors", {
  expect_error(Analyze_Chisq(list()))
  expect_error(Analyze_Chisq("Hi"))
  expect_error(Analyze_Chisq(dfTransformed, strOutcome = "x"))
  expect_error(Analyze_Chisq(dfTransformed, strOutcome = TRUE))
})

test_that("error given if required column not found", {
  expect_error(Analyze_Chisq(dfTransformed %>% select(-SiteID)))
  expect_error(Analyze_Chisq(dfTransformed %>% select(-N)))
  expect_error(Analyze_Chisq(dfTransformed %>% select(-TotalCount)))
})

test_that("NAs are handled correctly", {
  createNA <- function(x) {
    df <- Disp_Map(dfDisp = safetyData::adam_adsl, strCol = "DCREASCD", strReason = "Adverse Event") %>%
      Transform_EventCount(strCountCol = "Count")

    df[[x]][1] <- NA

    Analyze_Chisq(df)
  }

  expect_error(createNA("SiteID"))
  expect_error(createNA("N"))
  expect_error(createNA("TotalCount"))
})
