source(testthat::test_path("testdata/data.R"))

dfInput <- Disp_Map_Raw(
  dfs = list(dfDISP = dfDISP,
             dfSUBJ = dfSUBJ)
  )

test_that("output created as expected and has correct structure", {
  df <- Transform_EventCount(dfInput, strCountCol = "Count", strKRILabel = "test label")

  output <- Analyze_Fisher(df)

  expect_true(is.data.frame(df))
  expect_equal(names(output), c("SiteID", "TotalCount", "TotalCount_Other", "N", "N_Other", "Prop", "Prop_Other", "Estimate", "PValue"))
  expect_type(df$SiteID, "character")
  expect_type(df$N, "integer")
  expect_type(df$TotalCount, "double")
  expect_equal(df$SiteID, c("X010X", "X102X", "X999X"))
})

test_that("incorrect inputs throw errors", {
  dfInput <- Disp_Map_Raw(
    dfs = list(dfDISP = dfDISP,
               dfSUBJ = dfSUBJ)
  )

  df <- Transform_EventCount(
    dfInput,
    strCountCol = "Count",
    strKRILabel = "testing label"
  )

  expect_error(Analyze_Fisher(list()))
  expect_error(Analyze_Fisher("Hi"))
  expect_error(Analyze_Fisher(df, strOutcome = data.frame()))
  expect_error(Analyze_Fisher(df, strOutcome = ":("))
})


test_that("error given if required column not found", {
  dfInput <- Disp_Map_Raw(
    dfs = list(dfDISP = dfDISP,
               dfSUBJ = dfSUBJ)
  )

  df <- Transform_EventCount(
    dfInput,
    strCountCol = "Count",
    strKRILabel = "testing label"
  )

  expect_error(Analyze_Fisher(df %>% select(-SiteID)))
  expect_error(Analyze_Fisher(df %>% select(-N)))
  expect_error(Analyze_Fisher(df %>% select(-TotalCount)))
})

test_that("NAs are handled correctly", {
  dfInput <- Disp_Map_Raw(
    dfs = list(dfDISP = dfDISP,
               dfSUBJ = dfSUBJ)
  )

  df <- Transform_EventCount(
    dfInput,
    strCountCol = "Count",
    strKRILabel = "testing label"
  )

  createNA <- function(data, variable) {
    data[[variable]][[1]] <- NA

    return(Analyze_Fisher(data))
  }

  expect_error(createNA(data = df, variable = "SiteID"))
  expect_error(createNA(data = df, variable = "N"))
  expect_error(createNA(data = df, variable = "TotalCount"))
})
