test_that("output created as expected and has correct structure", {

  dfInput <- Disp_Map(
    dfDisp = safetyData::adam_adsl,
    strCol = "DCREASCD",
    strReason = "Adverse Event"
  )

  df <- Transform_EventCount(
    dfInput,
    strCountCol = 'Count'
  )

  output <- Analyze_Fisher(df)

  expect_true(
    is.data.frame(df)
  )

  expect_equal(
    names(output),
    c("SiteID", "TotalCount", "TotalCount_Other", "N", "N_Other", "Prop", "Prop_Other", "Estimate", "PValue")
  )

  expect_type(
    df$SiteID,
    "character"
  )

  expect_type(
    df$N,
    "integer"
  )

  expect_type(
    df$TotalCount,
    "double"
  )

  expect_equal(
    df$SiteID,
    structure(c("701", "702", "703", "704", "705", "706", "707",
                "708", "709", "710", "711", "713", "714", "715", "716", "717",
                "718"), label = "Study Site Identifier")
  )

})

test_that("incorrect inputs throw errors", {

  dfInput <- Disp_Map(
    dfDisp = safetyData::adam_adsl,
    strCol = "DCREASCD",
    strReason = "Adverse Event"
  )

  df <- Transform_EventCount(
    dfInput,
    strCountCol = 'Count'
  )

  expect_error(
    Analyze_Fisher(list())
  )

  expect_error(
    Analyze_Fisher("Hi")
  )

  expect_error(
    Analyze_Fisher(df, strOutcome = data.frame())
  )

  expect_error(
    Analyze_Fisher(df, strOutcome = ":(")
  )

})


test_that("error given if required column not found", {

  dfInput <- Disp_Map(
    dfDisp = safetyData::adam_adsl,
    strCol = "DCREASCD",
    strReason = "Adverse Event"
  )

  df <- Transform_EventCount(
    dfInput,
    strCountCol = 'Count'
  )

  expect_error(
    Analyze_Fisher(
      df %>% select(-SiteID)
    )
  )

  expect_error(
    Analyze_Fisher(
      df %>% select(-N)
    )
  )

  expect_error(
    Analyze_Fisher(
      df %>% select(-TotalCount)
    )
  )

})

test_that("NAs are handled correctly", {

  dfInput <- Disp_Map(
    dfDisp = safetyData::adam_adsl,
    strCol = "DCREASCD",
    strReason = "Adverse Event"
  )

  df <- Transform_EventCount(
    dfInput,
    strCountCol = 'Count'
  )

  createNA <- function(data, variable) {

    data[[variable]][[1]] <- NA

    return(Analyze_Fisher(data))

  }

  expect_error(
    createNA(
      data = df,
      variable = "SiteID"
      )
  )

  expect_error(
    createNA(
      data = df,
      variable = "N"
      )
  )

  expect_error(
    createNA(
      data = df,
      variable = "TotalCount"
      )
  )

})
