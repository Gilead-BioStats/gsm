source(testthat::test_path("testdata/data.R"))

dfInput <- Disp_Map(
  dfDisp,
  strCol = "DCREASCD",
  strReason = "Adverse Event"
  ) %>%
  mutate(GroupLabel = "SiteID") # this is a temp fix and will be updated in branch fix-387

df <- Transform_EventCount(
  dfInput,
  strCountCol = "Count",
  strKRILabel = "test label",
  strGroupCol = "SiteID"
  )

test_that("output created as expected and has correct structure", {


  output <- Analyze_Fisher(df)

  expect_true(is.data.frame(df))
  expect_equal(names(output), c("GroupID", "TotalCount", "TotalCount_Other", "N", "N_Other", "Prop", "Prop_Other", "Estimate", "PValue"))
  expect_type(df$GroupID, "character")
  expect_type(df$N, "integer")
  expect_type(df$TotalCount, "double")
  expect_equal(df$GroupID, c("701", "702"))
})

test_that("incorrect inputs throw errors", {
  dfInput <- Disp_Map(
    dfDisp,
    strCol = "DCREASCD",
    strReason = "Adverse Event"
  ) %>%
    mutate(GroupLabel = "SiteID")

  df <- Transform_EventCount(
    dfInput,
    strCountCol = "Count",
    strKRILabel = "test label",
    strGroupCol = "SiteID"
  )

  expect_error(Analyze_Fisher(list()))
  expect_error(Analyze_Fisher("Hi"))
  expect_error(Analyze_Fisher(df, strOutcome = data.frame()))
  expect_error(Analyze_Fisher(df, strOutcome = ":("))
})


test_that("error given if required column not found", {
  dfInput <- Disp_Map(
    dfDisp,
    strCol = "DCREASCD",
    strReason = "Adverse Event"
  ) %>%
    mutate(GroupLabel = "SiteID")

  df <- Transform_EventCount(
    dfInput,
    strCountCol = "Count",
    strKRILabel = "test label",
    strGroupCol = "SiteID"
  )

  expect_error(Analyze_Fisher(df %>% select(-GroupID)))
  expect_error(Analyze_Fisher(df %>% select(-N)))
  expect_error(Analyze_Fisher(df %>% select(-TotalCount)))
})

test_that("NAs are handled correctly", {
  dfInput <- Disp_Map(
    dfDisp,
    strCol = "DCREASCD",
    strReason = "Adverse Event"
  ) %>%
    mutate(GroupLabel = "SiteID")

  df <- Transform_EventCount(
    dfInput,
    strCountCol = "Count",
    strKRILabel = "test label",
    strGroupCol = "SiteID"
  )

  createNA <- function(data, variable) {
    data[[variable]][[1]] <- NA

    return(Analyze_Fisher(data))
  }

  expect_error(createNA(data = df, variable = "GroupID"))
  expect_error(createNA(data = df, variable = "N"))
  expect_error(createNA(data = df, variable = "TotalCount"))
})
