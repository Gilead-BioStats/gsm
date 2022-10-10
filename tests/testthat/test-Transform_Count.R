source(testthat::test_path("testdata/data.R"))

input <- Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ))

test_that("output is created as expected", {
  dfTransformed <- Transform_Count(
    dfInput = input,
    strGroupCol = "SiteID",
    strCountCol = "Count"
  )

  expect_true(is.data.frame(dfTransformed))
  expect_equal(names(dfTransformed), c("GroupID", "TotalCount", "Metric"))
  expect_equal(sort(unique(input$SiteID)), sort(dfTransformed$GroupID))
})


test_that("incorrect inputs throw errors", {
  expect_error(Transform_Count(list()))

  expect_error(
    Transform_Count(
      dfInput = input %>% select(-Count),
      strGroupCol = "SiteID",
      strCountCol = "Count"
    ),
    "strCountCol not found in input data"
  )

  expect_error(
    Transform_Count(
      dfInput = input %>% mutate(Count = as.character(Count)),
      strGroupCol = "SiteID",
      strCountCol = "Count"
    ),
    "strCountCol is not numeric or logical"
  )

  expect_error(
    Transform_Count(
      dfInput = input %>% mutate(Count = ifelse(row_number() == 1, NA, Count)),
      strGroupCol = "SiteID",
      strCountCol = "Count"
    ),
    "NA's found in strCountCol"
  )
})
