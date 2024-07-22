test_that("output created as expected and has correct structure", {
  ae_prep <- Transform_Rate(analyticsInput)
  ae_anly <- Analyze_Poisson(ae_prep)
  expect_true(is.data.frame(ae_anly))
  expect_equal(sort(unique(analyticsInput$GroupID)), sort(ae_anly$GroupID))
  expect_equal(names(ae_anly), c("GroupID", "GroupLevel", "Numerator", "Denominator", "Metric", "Score", "PredictedCount"))
})

test_that("incorrect inputs throw errors", {
  expect_error(Analyze_Poisson(list()))
  expect_error(Analyze_Poisson("Hi"))
})


test_that("error given if required column not found", {
  ae_prep <- Transform_Rate(analyticsInput)
  expect_error(Analyze_Poisson(ae_prep %>% select(-GroupID)))
  expect_error(Analyze_Poisson(ae_prep %>% select(-N)))
  expect_error(Analyze_Poisson(ae_prep %>% select(-Numerator)))
  expect_error(Analyze_Poisson(ae_prep %>% select(-Denominator)))
  expect_error(Analyze_Poisson(ae_prep %>% select(-Metric)))
})

test_that("NA values are caught", {
  createNA <- function(x) {
    df <- analyticsInput %>%
      Transform_Rate()

    df[[x]][1] <- NA

    Analyze_Poisson(df)
  }

  expect_error(createNA("GroupID"))
})
