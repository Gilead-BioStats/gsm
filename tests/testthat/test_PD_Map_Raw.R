source(testthat::test_path("testdata/data.R"))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  data <- PD_Map_Raw(dfPD, dfSUBJ)
  expect_true(is.data.frame(data))
  expect_equal(names(data), c("SubjectID","SiteID","Exposure","Count","Rate"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_snapshot_error(PD_Map_Raw(list(), list()))
  expect_snapshot_error(PD_Map_Raw(dfPD, list()))
  expect_snapshot_error(PD_Map_Raw(list(), dfSUBJ))
  expect_snapshot_error(PD_Map_Raw("Hi","Mom"))
  expect_snapshot_error(PD_Map_Raw(dfPD, dfSUBJ, mapping = list()))
  expect_snapshot_error(PD_Map_Raw(dfPD %>% select(-SubjectID), dfSUBJ))
  expect_snapshot_error(PD_Map_Raw(dfPD, dfSUBJ %>% select(-SubjectID)))
  expect_snapshot_error(PD_Map_Raw(dfPD, dfSUBJ %>% select(-SiteID)))
  expect_snapshot_error(PD_Map_Raw(dfPD, dfSUBJ %>% select(-TimeOnStudy)))
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors",{

  expect_snapshot_error(PD_Map_Raw(dfPD, dfSUBJ, mapping = list(
    dfPD = list(strIDCol="not an id"),
    dfSUBJ = list(strIDCol="SubjectID",
                  strSiteCol="SiteID",
                  strTimeOnStudyCol = "TimeOnStudy"))))

  expect_snapshot_error(PD_Map_Raw(dfPD, dfSUBJ, mapping = list(
    dfPD = list(strIDCol="SubjectID"),
    dfSUBJ = list(strIDCol="not an id",
                  strSiteCol="SiteID",
                  strTimeOnStudyCol = "TimeOnStudy"))))

})


# custom tests ------------------------------------------------------------
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

  expect_snapshot_error(PD_Map_Raw(dfPD = dfPD, dfSUBJ = dfTos))
  expect_snapshot_error(PD_Map_Raw(dfPD = dfPD2, dfSUBJ = dfTos2))
})

test_that("duplicate SubjectID values are caught in RDSL", {

  dfPD <- tribble(~SubjectID, 1,2)

  dfSUBJ <- tribble(
    ~SubjectID, ~SiteID, ~TimeOnStudy,
    1,   1, 10,
    1,   1, 30
  )

  expect_snapshot_error(PD_Map_Raw(dfPD, dfSUBJ))
})

test_that("custom mapping creates expected output", {

  custom_mapping <- list(
    dfPD = list(strIDCol="eye_dee"),
    dfSUBJ = list(strIDCol="custom_id", strSiteCol="custom_site_id", strTimeOnStudyCol = "TimeOnStudy")
  )

  custom_pd <- dfPD %>%
    rename(eye_dee = SubjectID)

  custom_rdsl <- dfSUBJ %>%
    rename(custom_id = SubjectID, custom_site_id = SiteID)

  expect_true(is.data.frame(PD_Map_Raw(custom_pd, custom_rdsl,mapping = custom_mapping)))
})



