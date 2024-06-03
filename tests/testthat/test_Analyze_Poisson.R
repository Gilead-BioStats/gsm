ae_input <- tibble::tibble(
  SubjectID = c("01-701-1015", "01-701-1023", "01-701-1028", "01-701-1033"),
  GroupID    = c("701", "701", "702", "703"),
  GroupLevel  = c("site", "site", "site", "site"),
  Count     = c(2, 3, 1, 3),
  Exposure  = c(182, 28, 180, 14),
  Rate      = c(0.0109, 0.1071, 0.0055, 0.2142)
)

test_that("output created as expected and has correct structure", {
  ae_prep <- Transform_Rate(
    dfInput = ae_input,
    strNumeratorCol = "Count",
    strDenominatorCol = "Exposure"
  )
  ae_anly <- Analyze_Poisson(ae_prep)
  expect_true(is.data.frame(ae_anly))
  expect_equal(sort(unique(ae_input$GroupID)), sort(ae_anly$GroupID))
  expect_equal(names(ae_anly), c("GroupID", "Numerator", "Denominator", "Metric", "Score", "PredictedCount"))
})

test_that("incorrect inputs throw errors", {
  expect_error(Analyze_Poisson(list()))
  expect_error(Analyze_Poisson("Hi"))
})


test_that("error given if required column not found", {
  ae_prep <- Transform_Rate(
    dfInput = ae_input,
    strNumeratorCol = "Count",
    strDenominatorCol = "Exposure"
  )
  expect_error(Analyze_Poisson(ae_prep %>% select(-GroupID)))
  expect_error(Analyze_Poisson(ae_prep %>% select(-N)))
  expect_error(Analyze_Poisson(ae_prep %>% select(-Numerator)))
  expect_error(Analyze_Poisson(ae_prep %>% select(-Denominator)))
  expect_error(Analyze_Poisson(ae_prep %>% select(-Metric)))
})

test_that("NA values are caught", {
  createNA <- function(x) {
    df <- ae_input %>%
      Transform_Rate(
        strNumeratorCol = "Count",
        strDenominatorCol = "Exposure"
      )

    df[[x]][1] <- NA

    Analyze_Poisson(df)
  }

  expect_error(createNA("GroupID"))
})
