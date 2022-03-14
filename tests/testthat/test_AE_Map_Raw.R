dfAE <- clindata::raw_ae
dfRDSL <- clindata::rawplus_rdsl %>% filter(!is.na(TimeOnTreatment))

mapping <- list(
  dfAE= list(id_col="SUBJID"),
  dfRDSL=list(strIDCol="SubjectID", strSiteCol="SiteID", strExposureCol="TimeOnTreatment")
)


test_that("output created as expected and has correct structure",{
  ae_input <- AE_Map_Raw(dfAE = dfAE, dfRDSL = dfRDSL)
  expect_true(is.data.frame(ae_input))
  expect_equal(
  names(ae_input),
  c("SubjectID","SiteID","Count","Exposure","Rate"))
})

test_that("all data is mapped and summarized correctly",{
  AE_counts <- clindata::raw_ae %>%
    filter(SUBJID != "") %>%
    group_by(SUBJID) %>%
    summarize("Count" = n()) %>%
    ungroup() %>%
    select(SUBJID, Count)

  AE_mapped <- clindata::rawplus_rdsl %>%
    filter(!is.na(TimeOnTreatment)) %>%
    left_join(AE_counts, by = c("SubjectID" = "SUBJID")) %>%
    mutate(Count = as.integer(replace(Count, is.na(Count), 0))) %>%
    rename(Exposure = TimeOnTreatment) %>%
    mutate(Rate = Count / Exposure) %>%
    select(SubjectID, SiteID, Count, Exposure, Rate)

  expect_identical(AE_Map_Raw(dfAE, dfRDSL),
                   AE_mapped)
})

test_that("incorrect inputs throw errors",{
  expect_error(AE_Map_Raw(list(), list()))
  expect_error(AE_Map_Raw(dfAE, list()))
  expect_error(AE_Map_Raw(list(), dfRDSL))
  expect_error(AE_Map_Raw("Hi", "Mom"))
  expect_error(AE_Map_Raw(dfAE, dfRDSL, mapping = list()))
})


test_that("error given if required column not found",{
  expect_error(
    AE_Map_Raw(
      dfAE %>% rename(ID = SUBJID),
      dfRDSL
    )
  )

  expect_error(
    AE_Map_Raw(
      dfAE,
      dfRDSL %>% select(-SiteID)
    )
  )

  expect_error(
    AE_Map_Raw(
      dfAE,
      dfRDSL %>% select(-SubjectID)
    )
  )

  expect_error(
    AE_Map_Raw(
      dfAE,
      dfRDSL %>% select(-TimeOnTreatment)
    )
  )


# update mapping
  expect_error(
    AE_Map_Raw(
      dfAE,
      dfRDSL,
      mapping = list(
        dfAE= list(id_col="not an id column"),
        dfRDSL=list(strIDCol="SubjectID", strSiteCol="SiteID", strExposureCol="TimeOnTreatment")
      )
    )
  )

  expect_error(
    AE_Map_Raw(
      dfAE,
      dfRDSL %>% select(-SiteID)
    )
  )


  expect_silent(
    AE_Map_Raw(
      dfAE %>% select(-PROJECT),
      dfRDSL
    )
  )
})


test_that("output is correct given example input",{


  dfAE_test <- tibble::tribble(~SUBJID, 1,1,1,1,2,2)

  dfRDSL_test <-tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, NA,
    3,   1, 30
  )


  dfInput_test <-tibble::tribble(
      ~SubjectID, ~SiteID, ~Count, ~Exposure,~Rate,
      1,   1, 4, 10, 0.4,
      2,   1, 2, NA, NA,
      3,   1, 0, 30, 0
  )


  expect_equal(dfInput,  AE_Map_Raw(dfAE_test, dfRDSL_test ))

  dfAE2 <- tibble::tribble(~SUBJID, 1,1,1,1,2,2,4,4)

  dfExposure2<-tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, NA,
    3,   1, 30,
    4,   2, 50
  )


  dfInput2 <-tibble::tribble(
    ~SubjectID, ~SiteID, ~Count, ~Exposure,~Rate,
    1,   1, 4, 10, 0.4,
    2,   1, 2, NA, NA,
    3,   1, 0, 30, 0 ,
    4,   2, 2, 50, .04
  )



  expect_equal(dfInput2,  AE_Map_Raw(dfAE = dfAE2, dfRDSL = dfExposure2))



})

test_that("NA values in input data are handled",{

  dfAE3 <- tibble::tribble(~SUBJID, 1,1,1,1,2,2,4,4)

  dfExposure3<-tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, NA,
    3,   NA, 30,
    4,   2, 50
  )


  dfInput3 <-tibble::tribble(
    ~SubjectID, ~SiteID, ~Count, ~Exposure,~Rate,
    1,   1, 4, 10, 0.4,
    2,    1,  2, NA, NA,
    3,   NA,  0, 30, 0 ,
    4,    2,  2, 50, .04
  )

  expect_error(AE_Map_Raw(dfAE = dfAE3, dfRDSL = dfExposure3))


})


test_that("dfAE$SUBJID NA value throws error",{
  dfAE4 <- tibble::tribble(~SUBJID, 1,NA,1,1,2,2,4,4)

  dfExposure4<-tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, 20,
    3,   3, 30,
    4,   2, 50
  )


  expect_error(AE_Map_Raw(dfAE = dfAE4, dfRDSL = dfExposure4))
})

test_that("dfRDSL$SubjectID NA value throws error",{
  dfAE4 <- tibble::tribble(~SUBJID, 1,1,1,1,2,2,4,4)

  dfExposure4<-tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    NA,   1, 10,
    2,   1, 20,
    3,   2, 30,
    4,   2, 50
  )


  expect_error(AE_Map_Raw(dfAE = dfAE4, dfRDSL = dfExposure4))
})

