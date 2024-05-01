wfs <- MakeWorkflowList(strNames="kri0001")
result <- Study_Assess(lAssessments=wfs)
dfSummary <- result %>% imap_dfr(~.x$lData$dfSummary %>% mutate(MetricID = .y))
df <- dfSummary[1:3,]

test_that("output created as expected and has correct structure", {

  output <- Analyze_Fisher(df)

  expect_true(is.data.frame(df))
  expect_equal(names(output), c(
    "GroupID", "Numerator", "Numerator_Other", "Denominator",
    "Denominator_Other", "Prop", "Prop_Other", "Metric", "Estimate",
    "Score"
  ))
  expect_type(df$GroupID, "character")
  expect_equal(df$GroupID, c("83", "43", "75"))
})

test_that("incorrect inputs throw errors", {
  expect_error(Analyze_Fisher(list()))
  expect_error(Analyze_Fisher("Hi"))
  expect_error(Analyze_Fisher(df, strOutcome = data.frame()))
  expect_error(Analyze_Fisher(df, strOutcome = ":("))
})


test_that("error given if required column not found", {
  expect_error(Analyze_Fisher(df %>% select(-GroupID)))
  expect_error(Analyze_Fisher(df %>% select(-Numerator)))
  expect_error(Analyze_Fisher(df %>% select(-Denominator)))
})

test_that("NAs are handled correctly", {
  createNA <- function(data, variable) {
    data[[variable]][[1]] <- NA

    return(Analyze_Fisher(data))
  }

  expect_error(createNA(data = df, variable = "GroupID"))
})
