source(testthat::test_path("testdata/data.R"))

dfInput <- Disp_Map_Raw(
  dfs = list(
    dfSDRGCOMP = dfSDRGCOMP,
    dfSTUDCOMP = dfSTUDCOMP,
    dfSUBJ = dfSUBJ
  )
)

test_that("output created as expected and has correct structure", {
  df <- Transform_Rate(
    dfInput = dfInput,
    strGroupCol = "SiteID",
    strNumeratorCol = "Count",
    strDenominatorCol = "Total"
  )

  output <- Analyze_Fisher(df)

  expect_true(is.data.frame(df))
  expect_equal(names(output), c(
    "GroupID", "Numerator", "Numerator_Other", "Denominator",
    "Denominator_Other", "Prop", "Prop_Other", "Metric", "Estimate",
    "Score"
  ))
  expect_type(df$GroupID, "character")
  expect_equal(df$GroupID, c("166", "76", "86"))
})

test_that("incorrect inputs throw errors", {
  dfInput <- Disp_Map_Raw(
    dfs = list(
      dfSDRGCOMP = dfSDRGCOMP,
      dfSTUDCOMP = dfSTUDCOMP,
      dfSUBJ = dfSUBJ
    )
  )

  df <- Transform_Rate(
    dfInput = dfInput,
    strGroupCol = "SiteID",
    strNumeratorCol = "Count",
    strDenominatorCol = "Total"
  )

  expect_error(Analyze_Fisher(list()))
  expect_error(Analyze_Fisher("Hi"))
  expect_error(Analyze_Fisher(df, strOutcome = data.frame()))
  expect_error(Analyze_Fisher(df, strOutcome = ":("))
})


test_that("error given if required column not found", {
  dfInput <- Disp_Map_Raw(
    dfs = list(
      dfSDRGCOMP = dfSDRGCOMP,
      dfSTUDCOMP = dfSTUDCOMP,
      dfSUBJ = dfSUBJ
    )
  )

  df <- Transform_Rate(
    dfInput = dfInput,
    strGroupCol = "SiteID",
    strNumeratorCol = "Count",
    strDenominatorCol = "Total"
  )

  expect_error(Analyze_Fisher(df %>% select(-GroupID)))
  expect_error(Analyze_Fisher(df %>% select(-Numerator)))
  expect_error(Analyze_Fisher(df %>% select(-Denominator)))
})

test_that("NAs are handled correctly", {
  dfInput <- Disp_Map_Raw(
    dfs = list(
      dfSDRGCOMP = dfSDRGCOMP,
      dfSTUDCOMP = dfSTUDCOMP,
      dfSUBJ = dfSUBJ
    )
  )

  df <- Transform_Rate(
    dfInput = dfInput,
    strGroupCol = "SiteID",
    strNumeratorCol = "Count",
    strDenominatorCol = "Total"
  )

  createNA <- function(data, variable) {
    data[[variable]][[1]] <- NA

    return(Analyze_Fisher(data))
  }

  expect_error(createNA(data = df, variable = "GroupID"))
})
