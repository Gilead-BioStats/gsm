source(testthat::test_path("testdata/data.R"))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  data <- AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ))
  expect_true(is.data.frame(data))
  expect_equal(names(data), c("SubjectID", "SiteID", "Count", "Exposure", "Rate"))
  expect_type(data$SubjectID, "character")
  expect_type(data$SiteID, "character")
  expect_true(class(data$Count) %in% c("double", "integer", "numeric"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  # empty data frames
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = list(), dfSUBJ = list()), bQuiet = F))
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = list()), bQuiet = F))
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = list(), dfSUBJ = dfSUBJ), bQuiet = F))
  # mistyped data frames
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = "Hi", dfSUBJ = "Mom"), bQuiet = F))
  # empty mapping
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ), lMapping = list(), bQuiet = F))
  # missing variables
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE %>% select(-SubjectID), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ %>% select(-SiteID)), bQuiet = F))
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ %>% select(-SubjectID)), bQuiet = F))
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ %>% select(-TimeOnTreatment)), bQuiet = F))
  # duplicate subject IDs
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = bind_rows(dfSUBJ, head(dfSUBJ, 1))), bQuiet = F))
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors", {
  expect_snapshot(
    AE_Map_Raw(
      dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ),
      lMapping = list(
        dfAE = list(strIDCol = "not an id"),
        dfSUBJ = list(
          strIDCol = "SubjectID",
          strSiteCol = "SiteID",
          strTimeOnTreatmentCol = "TimeOnTreatment"
        )
      ),
      bQuiet = F
    )
  )

  expect_snapshot(
    AE_Map_Raw(
      dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ),
      lMapping = list(
        dfAE = list(strIDCol = "SubjectID"),
        dfSUBJ = list(
          strIDCol = "not an id",
          strSiteCol = "SiteID",
          strTimeOnTreatmentCol = "TimeOnTreatment"
        )
      ),
      bQuiet = F
    )
  )
})

# custom tests ------------------------------------------------------------
test_that("NA values in input data are handled", {
  # NA SiteID and TimeOnTreatment.
  dfAE1 <- tibble::tribble(
    ~SubjectID, 1, 1, 1, 1, 2, 2, 4, 4
  )
  dfSUBJ1 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1, 1, 10,
    2, 1, NA,
    3, NA, 30,
    4, 2, 50
  )
  mapped1 <- AE_Map_Raw(
    list(dfAE = dfAE1, dfSUBJ = dfSUBJ1)
  )
  expect_null(mapped1)

  # NA SubjectID in AE domain.
  dfAE2 <- tibble::tribble(
    ~SubjectID, 1, NA, 1, 1, 2, 2, 4, 4
  )
  dfSUBJ2 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1, 1, 10,
    2, 1, 20,
    3, 3, 30,
    4, 2, 50
  )
  mapped2 <- AE_Map_Raw(
    list(dfAE = dfAE2, dfSUBJ = dfSUBJ2)
  )
  expect_null(mapped2)

  # NA SubjectID in SUBJ domain.
  dfAE3 <- tibble::tribble(
    ~SubjectID, 1, 1, 1, 1, 2, 2, 4, 4
  )
  dfSUBJ3 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    NA, 1, 10,
    2, 1, 20,
    3, 2, 30,
    4, 2, 50
  )
  mapped3 <- AE_Map_Raw(
    list(dfAE = dfAE3, dfSUBJ = dfSUBJ3)
  )
  expect_null(mapped3)
})

test_that("duplicate SubjectID values are caught in dfSUBJ", {
  dfAE <- tribble(~SubjectID, 1, 2)

  dfSUBJ <- tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1, 1, 10,
    1, 1, 30
  )

  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ), bQuiet = F))
})

test_that("bQuiet works as intended", {
  expect_message(
    AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ), bQuiet = FALSE)
  )
})

test_that("bReturnChecks works as intended", {
  expect_true(
    all(names(AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ), bReturnChecks = TRUE)) == c("df", "lChecks"))
  )
})
