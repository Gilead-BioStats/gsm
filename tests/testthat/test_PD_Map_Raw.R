source(testthat::test_path("testdata/data.R"))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  data <- PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ))
  expect_true(is.data.frame(data))
  expect_equal(names(data), c("SubjectID","SiteID","Count","Exposure","Rate"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = list(), dfSUBJ = list()), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = list()), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = list(), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = "Hi",dfSUBJ = "Mom"), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ), lMapping = list(), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD %>% select(-SubjectID), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ %>% select(-SubjectID)), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ %>% select(-SiteID)), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ %>% select(-TimeOnStudy)), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = bind_rows(dfSUBJ, head(dfSUBJ, 1))), bQuiet = F))
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors",{

  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ),
                             lMapping = list(
    dfPD = list(strIDCol="not an id"),
    dfSUBJ = list(strIDCol="SubjectID",
                  strSiteCol="SiteID",
                  strTimeOnStudyCol = "TimeOnStudy")), bQuiet = F))

  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ),
                             lMapping = list(
    dfPD = list(strIDCol="SubjectID"),
    dfSUBJ = list(strIDCol="not an id",
                  strSiteCol="SiteID",
                  strTimeOnStudyCol = "TimeOnStudy")), bQuiet = F))

})


# custom tests ------------------------------------------------------------
test_that("NA values in input data are handled",{
  # NA SiteID and TimeOnTreatment.
  dfPD1 <- tibble::tribble(
    ~SubjectID, 1,1,1,1,2,2,4,4
  )
  dfExposure1 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1, 1, 10,
    2, 1, NA,
    3, NA, 30,
    4, 2, 50
  )
  mapped1 <- PD_Map_Raw(
    list(dfPD = dfPD1, dfSUBJ = dfExposure1)
  )
  expect_null(mapped1)

  # NA SubjectID in PD domain.
  dfPD2 <- tibble::tribble(
    ~SubjectID, 1,NA,1,1,2,2,4,4
  )
  dfExposure2 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1, 1, 10,
    2, 1, 20,
    3, 3, 30,
    4, 2, 50
  )
  mapped2 <- PD_Map_Raw(
    list(dfPD = dfPD2, dfSUBJ = dfExposure2)
  )
  expect_null(mapped2)

  # NA SubjectID in SUBJ domain.
  dfPD3 <- tibble::tribble(
    ~SubjectID, 1,1,1,1,2,2,4,4
  )
  dfExposure3 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    NA, 1, 10,
    2, 1, 20,
    3, 2, 30,
    4, 2, 50
  )
  mapped3 <- PD_Map_Raw(
    list(dfPD = dfPD3, dfSUBJ = dfExposure3)
  )
  expect_null(mapped3)
})

test_that("NA values are caught",{

  dfPD <- tribble(~SubjectID, 1,1,1,1,2,2)

  dfTos<-tribble(
    ~SubjectID, ~SiteID, ~TimeOnStudy,
    1,   1, 10,
    2,   1, NA,
    3,   1, 30
  )

  dfInput <-tribble(
    ~SubjectID, ~SiteID, ~Count, ~Exposure,~Rate,
    1,   1, 4, 10, 0.4,
    2,   1, 2, NA, NA,
    3,   1, 0, 30, 0
  )

  dfPD2 <- tribble(~SubjectID, 1,1,1,1,2,2,4,4)

  dfTos2<-tribble(
    ~SubjectID, ~SiteID, ~TimeOnStudy,
    1,   1, 10,
    2,   1, NA,
    3,   1, 30,
    4,   2, 50
  )

  dfInput2 <-tribble(
    ~SubjectID, ~SiteID, ~Count, ~Exposure,~Rate,
    1,   1, 4, 10, 0.4,
    2,   1, 2, NA, NA,
    3,   1, 0, 30, 0 ,
    4,   2, 2, 50, .04
  )

  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfTos), bQuiet = F))
  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD2, dfSUBJ = dfTos2), bQuiet = F))
})

test_that("duplicate SubjectID values are caught in RDSL", {

  dfPD <- tribble(~SubjectID, 1,2)

  dfSUBJ <- tribble(
    ~SubjectID, ~SiteID, ~TimeOnStudy,
    1,   1, 10,
    1,   1, 30
  )

  expect_snapshot(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ), bQuiet = F))
})

test_that("bQuiet works as intended", {
  expect_message(
    PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ), bQuiet = FALSE)
  )
})

test_that("bReturnChecks works as intended", {
  expect_true(
    all(names(PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ), bReturnChecks = TRUE)) == c('df', 'lChecks'))
  )
})
