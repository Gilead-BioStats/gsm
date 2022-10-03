source(testthat::test_path("testdata/data.R"))

input <- AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ))

test_that("output is created as expected", {

  dfTransformed <- Transform_Rate(
    dfInput = input,
    strNumeratorCol = "Count",
    strDenominatorCol = "Exposure"
    )

  expect_true(is.data.frame(dfTransformed))
  expect_equal(names(dfTransformed), c("GroupID", "Numerator", "Denominator", "Metric"))
  expect_equal(sort(unique(input$SiteID)), sort(dfTransformed$GroupID))

})

# Count / Exposure

test_that("incorrect inputs throw errors", {
  expect_error(Transform_Rate(list()))

  expect_error(
    Transform_Rate(
      dfInput = input %>% mutate(Count = as.character(Count)),
      strNumeratorCol = "Count",
      strDenominatorCol = "Exposure"
    ),
    "strNumeratorColumn is not numeric"
  )

  expect_error(
    Transform_Rate(
      dfInput = input %>% mutate(Exposure = as.character(Count)),
      strNumeratorCol = "Count",
      strDenominatorCol = "Exposure"
    ),
    "strDenominatorColumn is not numeric"
  )

  expect_error(
    Transform_Rate(
      dfInput = input %>% mutate(Count = ifelse(row_number() == 1, NA, Count)),
      strNumeratorCol = "Count",
      strDenominatorCol = "Exposure"
    ),
    "NA's found in numerator"
  )

  expect_error(
    Transform_Rate(
      dfInput = input %>% mutate(Exposure = ifelse(row_number() == 1, NA, Exposure)),
      strNumeratorCol = "Count",
      strDenominatorCol = "Exposure"
    ),
    "NA's found in denominator"
  )

  expect_error(
    Transform_Rate(
      dfInput = input %>% select(-SiteID),
      strNumeratorCol = "Count",
      strDenominatorCol = "Exposure"
    ),
    "Required columns not found in input data"
  )
})

test_that("rows with a denominator of 0 are removed", {
  testInput <- input %>%
    group_by(SiteID) %>%
    mutate(
      Exposure = ifelse(
        SiteID == input$SiteID[1],
        0,
        Exposure
      ),
      Rate = ifelse(
        SiteID == input$SiteID[1],
        NaN,
        Rate
      )
    ) %>%
    ungroup()

  expect_message(
    Transform_Rate(
      dfInput = testInput,
      strNumeratorCol = "Count",
      strDenominatorCol = "Exposure",
      bQuiet = FALSE
    )
  )
})
