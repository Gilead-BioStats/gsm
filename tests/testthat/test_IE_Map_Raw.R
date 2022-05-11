source(testthat::test_path("testdata/data.R"))

# output is created as expected -------------------------------------------
test_that("output created as expected", {
  data <- IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ))
  expect_true(is.data.frame(data))
  expect_equal(names(data), c("SubjectID", "SiteID", "Count"))
  expect_type(data$SubjectID, "character")
  expect_type(data$SiteID, "character")
  expect_true(class(data$Count) %in% c("double", "integer", "numeric"))
})



# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_snapshot(IE_Map_Raw(dfs = list(dfIE = list(), dfSUBJ = list), bQuiet = F))
  expect_snapshot(IE_Map_Raw(dfs = list(dfIE = "Hi", dfSUBJ = "Mom"), bQuiet = F))
  expect_snapshot(IE_Map_Raw(dfs = list(dfIE = dfIE %>% select(-SubjectID), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(IE_Map_Raw(dfs = list(dfIE = dfIE %>% select(-IE_CATEGORY), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(IE_Map_Raw(dfs = list(dfIE = dfIE %>% select(-IE_VALUE), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = bind_rows(dfSUBJ, head(dfSUBJ, 1))), bQuiet = F))
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors", {
  expect_snapshot(IE_Map_Raw(
    dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ),
    lMapping = list(
      dfIE = list(
        strIDCol = "not an id",
        strCategoryCol = "IE_CATEGORY",
        strValueCol = "IE_VALUE"
      ),
      dfSUBJ = list(
        strIDCol = "SubjectID",
        strSiteCol = "SiteID"
      )
    ),
    bQuiet = F
  ))

  expect_snapshot(IE_Map_Raw(
    dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ),
    lMapping = list(
      dfIE = list(
        strIDCol = "SubjectID",
        strCategoryCol = "IE_CATEGORY",
        strValueCol = "IE_VALUE"
      ),
      dfSUBJ = list(
        strIDCol = "not an id",
        strSiteCol = "SiteID"
      )
    ),
    bQuiet = F
  ))
})

# custom tests ------------------------------------------------------------
