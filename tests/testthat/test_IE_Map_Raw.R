source(testthat::test_path("testdata/data.R"))

# output is created as expected -------------------------------------------
test_that("output created as expected", {
  data <- IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ))
  expect_true(is.data.frame(data))
  expect_equal(names(data), c("SubjectID","SiteID","Count"))
  expect_type(data$SubjectID, "character")
  expect_type(data$SiteID, "character")
  expect_true(class(data$Count) %in% c("double", "integer", "numeric"))
})



# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors",{
  expect_snapshot(IE_Map_Raw(dfs = list(dfIE = list(), dfSUBJ = list), bQuiet = F))
  expect_snapshot(IE_Map_Raw(dfs = list(dfIE = "Hi", dfSUBJ = "Mom"), bQuiet = F))
  expect_snapshot(IE_Map_Raw(dfs = list(dfIE = dfIE %>% select(-SubjectID), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(IE_Map_Raw(dfs = list(dfIE = dfIE %>% select(-IE_CATEGORY), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(IE_Map_Raw(dfs = list(dfIE = dfIE %>% select(-IE_VALUE), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = bind_rows(dfSUBJ, head(dfSUBJ, 1))), bQuiet = F))
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors",{
    expect_snapshot(IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ),
                               lMapping = list(
                                 dfIE = list(strIDCol="not an id",
                                             strCategoryCol = "IE_CATEGORY",
                                             strValueCol = "IE_VALUE"),
                                 dfSUBJ = list(strIDCol="SubjectID",
                                               strSiteCol="SiteID")
                                 ),
                               bQuiet = F
                      )
                    )

  expect_snapshot(IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ),
                             lMapping = list(
                               dfIE = list(strIDCol="SubjectID",
                                           strCategoryCol = "IE_CATEGORY",
                                           strValueCol = "IE_VALUE"),
                               dfSUBJ = list(strIDCol="not an id",
                                             strSiteCol="SiteID")
                             ),
                             bQuiet = F
  )
  )
})

# custom tests ------------------------------------------------------------
test_that("NA values in input data are handled",{
  # NA SiteID and TimeOnTreatment.
  dfIE1 <- tibble::tribble(
    ~SubjectID, 1,1,1,1,2,2,4,4
  )
  dfExposure1 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1, 1, 10,
    2, 1, NA,
    3, NA, 30,
    4, 2, 50
  )
  mapped1 <- IE_Map_Raw(
    list(dfIE = dfIE1, dfSUBJ = dfExposure1)
  )
  expect_null(mapped1)

  # NA SubjectID in IE domain.
  dfIE2 <- tibble::tribble(
    ~SubjectID, 1,NA,1,1,2,2,4,4
  )
  dfExposure2 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1, 1, 10,
    2, 1, 20,
    3, 3, 30,
    4, 2, 50
  )
  mapped2 <- IE_Map_Raw(
    list(dfIE = dfIE2, dfSUBJ = dfExposure2)
  )
  expect_null(mapped2)

  # NA SubjectID in SUBJ domain.
  dfIE3 <- tibble::tribble(
    ~SubjectID, 1,1,1,1,2,2,4,4
  )
  dfExposure3 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    NA, 1, 10,
    2, 1, 20,
    3, 2, 30,
    4, 2, 50
  )
  mapped3 <- IE_Map_Raw(
    list(dfIE = dfIE3, dfSUBJ = dfExposure3)
  )
  expect_null(mapped3)
})

test_that("bQuiet works as intended", {
  expect_message(
    IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ), bQuiet = FALSE)
  )
})

test_that("bReturnChecks works as intended", {
  expect_true(
    all(names(IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ), bReturnChecks = TRUE)) == c('df', 'lChecks'))
  )
})
