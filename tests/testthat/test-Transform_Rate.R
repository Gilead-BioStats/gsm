input <- tibble::tribble(
  ~SubjectID, ~GroupID, ~GroupLevel, ~StudyID, ~CountryID, ~CustomGroupID, ~Exposure, ~Count, ~Rate,
  "0496", "5", "site", "AA-AA-000-0000", "US", "0X167", 730, 5, 5/720,
  "1350", "78", "site", "AA-AA-000-0000", "US", "0X002", 50, 2, 2/50,
  "0539", "139", "site", "AA-AA-000-0000", "US", "0X052", 901, 5, 5/901,
  "0329", "162", "site", "AA-AA-000-0000", "US", "0X049", 370, 3, 3/370,
  "0429", "29", "site", "AA-AA-000-0000", "Japan", "0X116", 450, 2, 2/450,
  "1218", "143", "site", "AA-AA-000-0000", "US", "0X153", 170, 3, 3/170,
  "0808", "173", "site", "AA-AA-000-0000", "US", "0X124", 680, 6, 6/680,
  "1314", "189", "site", "AA-AA-000-0000", "US", "0X093", 815, 4, 4/815,
  "1236", "58", "site", "AA-AA-000-0000", "China", "0X091", 225, 1, 1/225,
  "0163", "167", "site", "AA-AA-000-0000", "US", "0X059", 360, 3, 3/360
  )

test_that("output is created as expected", {
  dfTransformed <- Transform_Rate(
    dfInput = input,
    strNumeratorCol = "Count",
    strDenominatorCol = "Exposure"
  )

  expect_true(is.data.frame(dfTransformed))
  expect_equal(names(dfTransformed), c("GroupID", "GroupLevel", "Numerator", "Denominator", "Metric"))
  expect_equal(sort(unique(input$GroupID)), sort(dfTransformed$GroupID))
  expect_equal(length(unique(input$GroupID)), length(unique(dfTransformed$GroupID)))
  expect_equal(length(unique(input$GroupID)), nrow(dfTransformed))
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
      dfInput = input %>% mutate(Exposure = as.character(Exposure)),
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
      dfInput = input %>% select(-GroupID),
      strNumeratorCol = "Count",
      strDenominatorCol = "Exposure"
    ),
    "Required columns not found in input data"
  )
})

test_that("rows with a denominator of 0 are removed", {
  testInput <- input %>%
    group_by(GroupID) %>%
    mutate(
      Exposure = ifelse(
        GroupID == input$GroupID[1],
        0,
        Exposure
      ),
      Rate = ifelse(
        GroupID == input$GroupID[1],
        NaN,
        Rate
      )
    ) %>%
    ungroup()

  # TODO: use expect_snapshot here?
  expect_message(
    Transform_Rate(
      dfInput = testInput,
      strNumeratorCol = "Count",
      strDenominatorCol = "Exposure"
    )
  )
})

test_that("yaml workflow produces same table as R function", {
  source(test_path("testdata", "create_double_data.R"), local = TRUE)
  expect_equal(dfTransformed$Metric, lResults$dfTransformed$Metric)
  expect_equal(dim(dfTransformed), dim(lResults$dfTransformed))
})
