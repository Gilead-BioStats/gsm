source(testthat::test_path("testdata/data.R"))

mapping <- list(
  dfAE= list(strIDCol="SUBJID",
             strTreatmentEmergentCol = "AE_TE_FLAG "),
  dfSUBJ=list(strIDCol="SubjectID",
              strSiteCol="SiteID",
              strTimeOnTreatmentCol="TimeOnTreatment")
)

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  data <- AE_Map_Raw(dfAE, dfSUBJ)
  expect_true(is.data.frame(data))
  expect_equal(names(data), c("SubjectID", "SiteID", "Count", "Exposure", "Rate"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_snapshot_error(AE_Map_Raw(list(), list()))
  expect_snapshot_error(AE_Map_Raw(dfAE, list()))
  expect_snapshot_error(AE_Map_Raw(list(), dfSUBJ))
  expect_snapshot_error(AE_Map_Raw("Hi", "Mom"))
  expect_snapshot_error(AE_Map_Raw(dfAE, dfSUBJ, mapping = list()))
  expect_snapshot_error(AE_Map_Raw(dfAE %>% select(-SubjectID), dfSUBJ))
  expect_snapshot_error(AE_Map_Raw(dfAE %>% select(-AE_TE_FLAG), dfSUBJ))
  expect_snapshot_error(AE_Map_Raw(dfAE, dfSUBJ %>% select(-SiteID)))
  expect_snapshot_error(AE_Map_Raw(dfAE, dfSUBJ %>% select(-SubjectID)))
  expect_snapshot_error(AE_Map_Raw(dfAE, dfSUBJ %>% select(-TimeOnTreatment)))
  expect_snapshot_error(AE_Map_Raw(dfAE, bind_rows(dfSUBJ, head(dfSUBJ, 1))))
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors",{

  expect_snapshot_error(AE_Map_Raw(dfAE, dfSUBJ, mapping = list(
    dfAE= list(strIDCol="not an id"),
    dfSUBJ=list(strIDCol="SubjectID",
                strSiteCol="SiteID",
                strTimeOnTreatmentCol="TimeOnTreatment"))))

  expect_snapshot_error(AE_Map_Raw(dfAE, dfSUBJ, mapping = list(
    dfAE= list(strIDCol="SUBJID"),
    dfSUBJ=list(strIDCol="not an id",
                strSiteCol="SiteID",
                strTimeOnTreatmentCol="TimeOnTreatment"))))

})

# custom tests ------------------------------------------------------------
test_that("NA values in input data are handled",{

  dfAE1 <- tibble::tribble(~SubjectID, 1,1,1,1,2,2,4,4)

  dfExposure1 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, NA,
    3,   NA, 30,
    4,   2, 50
  )

  dfAE2 <- tibble::tribble(~SubjectID, 1,NA,1,1,2,2,4,4)

  dfExposure2 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, 20,
    3,   3, 30,
    4,   2, 50
  )

  dfAE3 <- tibble::tribble(~SubjectID, 1,1,1,1,2,2,4,4)

  dfExposure3 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    NA,   1, 10,
    2,   1, 20,
    3,   2, 30,
    4,   2, 50
  )


  expect_snapshot_error(AE_Map_Raw(dfAE = dfAE1, dfSUBJ = dfExposure1))

  expect_snapshot_error(AE_Map_Raw(dfAE = dfAE2, dfSUBJ = dfExposure2))

  expect_snapshot_error(AE_Map_Raw(dfAE = dfAE3, dfSUBJ = dfExposure3))

})

test_that("custom mapping runs without errors", {

  custom_mapping <- list(
    dfAE= list(strIDCol="SubjectID",
               strTreatmentEmergentCol = "AE_TE_FLAG"),
    dfSUBJ=list(strIDCol="custom_id",
                strSiteCol="custom_site_id",
                strTimeOnTreatmentCol="trtmnt")
  )

  custom_subj <- dfSUBJ %>%
    mutate(trtmnt = TimeOnTreatment * 2.025) %>%
    rename(custom_id = SubjectID,
           custom_site_id = SiteID)

  expect_silent(AE_Map_Raw(dfAE, custom_subj, mapping = custom_mapping))

})

