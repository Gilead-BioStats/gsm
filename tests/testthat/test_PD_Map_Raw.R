source(testthat::test_path("testdata/data.R"))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  data <- PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ))
  expect_true(is.data.frame(data))
  expect_equal(names(data), c("SubjectID", "SiteID", "Exposure", "Count", "Rate"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = list(), dfSUBJ = list()), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = list()), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = list(), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = "Hi", dfSUBJ = "Mom"), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ), lMapping = list(), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD %>% select(-SubjectID), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ %>% select(-SubjectID)), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ %>% select(-SiteID)), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ %>% select(-TimeOnStudy)), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = bind_rows(dfSUBJ, head(dfSUBJ, 1))), bQuiet = F))
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors", {
  expect_snapshot(PD_Map_Raw(
    dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ),
    lMapping = list(
      dfPD = list(strIDCol = "not an id"),
      dfSUBJ = list(
        strIDCol = "SubjectID",
        strSiteCol = "SiteID",
        strTimeOnStudyCol = "TimeOnStudy"
      )
    ), bQuiet = F
  ))

  expect_snapshot(PD_Map_Raw(
    dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ),
    lMapping = list(
      dfPD = list(strIDCol = "SubjectID"),
      dfSUBJ = list(
        strIDCol = "not an id",
        strSiteCol = "SiteID",
        strTimeOnStudyCol = "TimeOnStudy"
      )
    ), bQuiet = F
  ))
})


# custom tests ------------------------------------------------------------
test_that("NA values are caught", {
  dfPD <- tribble(~SubjectID, 1, 1, 1, 1, 2, 2)

  dfTos <- tribble(
    ~SubjectID, ~SiteID, ~TimeOnStudy,
    1, 1, 10,
    2, 1, NA,
    3, 1, 30
  )

  dfInput <- tribble(
    ~SubjectID, ~SiteID, ~Count, ~Exposure, ~Rate,
    1, 1, 4, 10, 0.4,
    2, 1, 2, NA, NA,
    3, 1, 0, 30, 0
  )

  dfPD2 <- tribble(~SubjectID, 1, 1, 1, 1, 2, 2, 4, 4)

  dfTos2 <- tribble(
    ~SubjectID, ~SiteID, ~TimeOnStudy,
    1, 1, 10,
    2, 1, NA,
    3, 1, 30,
    4, 2, 50
  )

  dfInput2 <- tribble(
    ~SubjectID, ~SiteID, ~Count, ~Exposure, ~Rate,
    1, 1, 4, 10, 0.4,
    2, 1, 2, NA, NA,
    3, 1, 0, 30, 0,
    4, 2, 2, 50, .04
  )

  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfTos), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD2, dfSUBJ = dfTos2), bQuiet = F))
})

test_that("duplicate SubjectID values are caught in RDSL", {
  dfPD <- tribble(~SubjectID, 1, 2)

  dfSUBJ <- tribble(
    ~SubjectID, ~SiteID, ~TimeOnStudy,
    1, 1, 10,
    1, 1, 30
  )

  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ), bQuiet = F))
})
