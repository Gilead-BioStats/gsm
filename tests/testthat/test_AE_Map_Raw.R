source(testthat::test_path("testdata/data.R"))

mapping <- list(
  dfAE= list(strIDCol="SUBJID"),
  dfSubj=list(strIDCol="SubjectID",
              strSiteCol="SiteID",
              strExposureCol="TimeOnTreatment")
)

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  data <- AE_Map_Raw(dfAE, dfSubj)
  expect_true(is.data.frame(data))
  expect_equal(names(data), c("SubjectID", "SiteID", "Count", "Exposure", "Rate"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_snapshot_error(AE_Map_Raw(list(), list()))
  expect_snapshot_error(AE_Map_Raw(dfAE, list()))
  expect_snapshot_error(AE_Map_Raw(list(), dfSubj))
  expect_snapshot_error(AE_Map_Raw("Hi", "Mom"))
  expect_snapshot_error(AE_Map_Raw(dfAE, dfSubj, mapping = list()))
  expect_snapshot_error(AE_Map_Raw(dfAE %>% select(-SUBJID), dfSubj))
  expect_snapshot_error(AE_Map_Raw(dfAE, dfSubj %>% select(-SiteID)))
  expect_snapshot_error(AE_Map_Raw(dfAE, dfSubj %>% select(-SubjectID)))
  expect_snapshot_error(AE_Map_Raw(dfAE, dfSubj %>% select(-TimeOnTreatment)))
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors",{

  expect_snapshot_error(AE_Map_Raw(dfAE, dfSubj, mapping = list(
    dfAE= list(strIDCol="not an id"),
    dfSubj=list(strIDCol="SubjectID",
                strSiteCol="SiteID",
                strExposureCol="TimeOnTreatment"))))

  expect_snapshot_error(AE_Map_Raw(dfAE, dfSubj, mapping = list(
    dfAE= list(strIDCol="SUBJID"),
    dfSubj=list(strIDCol="not an id",
                strSiteCol="SiteID",
                strExposureCol="TimeOnTreatment"))))

})

# custom tests ------------------------------------------------------------
test_that("NA values in input data are handled",{

  dfAE1 <- tibble::tribble(~SUBJID, 1,1,1,1,2,2,4,4)

  dfExposure1 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, NA,
    3,   NA, 30,
    4,   2, 50
  )

  dfAE2 <- tibble::tribble(~SUBJID, 1,NA,1,1,2,2,4,4)

  dfExposure2 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, 20,
    3,   3, 30,
    4,   2, 50
  )

  dfAE3 <- tibble::tribble(~SUBJID, 1,1,1,1,2,2,4,4)

  dfExposure3 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    NA,   1, 10,
    2,   1, 20,
    3,   2, 30,
    4,   2, 50
  )


  expect_snapshot_error(AE_Map_Raw(dfAE = dfAE1, dfSubj = dfExposure1))

  expect_snapshot_error(AE_Map_Raw(dfAE = dfAE2, dfSubj = dfExposure2))

  expect_snapshot_error(AE_Map_Raw(dfAE = dfAE3, dfSubj = dfExposure3))

})

test_that("custom mapping runs without errors", {

  custom_mapping <- list(
    dfAE= list(strIDCol="SUBJID"),
    dfSubj=list(strIDCol="custom_id",
                strSiteCol="custom_site_id",
                strExposureCol="trtmnt")
  )

  custom_subj <- dfSubj %>%
    mutate(trtmnt = TimeOnTreatment * 2.025) %>%
    rename(custom_id = SubjectID,
           custom_site_id = SiteID)

  expect_message(AE_Map_Raw(dfAE, custom_subj, mapping = custom_mapping))

})

