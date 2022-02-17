test_that("output created as expected and has correct structure",{
  ae_input <- AE_Map_Raw(dfAE = clindata::raw_ae, dfRDSL = clindata::rawplus_rdsl )
  expect_true(is.data.frame(ae_input))
  expect_equal(
  names(ae_input),
  c("SubjectID","SiteID","Count","Exposure","Rate"))
})

test_that("incorrect inputs throw errors",{
  expect_error(AE_Map_Raw(list(), list()))
  expect_error(AE_Map_Raw( clindata::raw_ae, list()))
  expect_error(AE_Map_Raw(list(),  clindata::rawplus_rdsl))
  expect_error(AE_Map_Raw("Hi","Mom"))
})


test_that("error given if required column not found",{
  expect_error(
    AE_Map_Raw( 
      clindata::raw_ae %>% rename(ID = SUBJID), 
      clindata::rawplus_rdsl
    )
  )
  
  expect_error(
    AE_Map_Raw(
      clindata::raw_ae ,
      clindata::rawplus_rdsl  %>% select(-SiteID)
    )
  )
  
  expect_error(
    AE_Map_Raw( 
      clindata::raw_ae , 
      clindata::rawplus_rdsl   %>% select(-SubjectID)
    )
  )
  
  
  
  expect_error(
    AE_Map_Raw( 
      clindata::raw_ae , 
      clindata::rawplus_rdsl ,
      strExposureCol="Exposure"
    )
  )
  
  expect_error(
    AE_Map_Raw( 
      clindata::raw_ae , 
      clindata::rawplus_rdsl   %>% select(-SiteID)
    )
  )
  
  
  expect_silent(
    AE_Map_Raw( 
      clindata::raw_ae  %>% select(-PROJECT), 
      clindata::rawplus_rdsl 
    )
  )
})


test_that("output is correct given example input",{
  

  dfAE <- tibble::tribble(~SUBJID, 1,1,1,1,2,2)
  
  dfRDSL<-tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, NA,
    3,   1, 30
  )

  
  dfInput <-tibble::tribble(
      ~SubjectID, ~SiteID, ~Count, ~Exposure,~Rate,
      1,   1, 4, 10, 0.4,
      2,   1, 2, NA, NA,
      3,   1, 0, 30, 0 
  )
  

  expect_equal(dfInput,  AE_Map_Raw(dfAE, dfRDSL ))
  
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
    NA,   1, 10,
    2,   1, NA,
    3,   NA, 30,
    4,   2, 50
  )
  
  
  dfInput3 <-tibble::tribble(
    ~SubjectID, ~SiteID, ~Count, ~Exposure,~Rate,
    NA,   1, 0, 10, 0,
    2,    1,  2, NA, NA,
    3,   NA,  0, 30, 0 ,
    4,    2,  2, 50, .04
  )
  
  expect_equal(dfInput3, AE_Map_Raw(dfAE = dfAE3, dfRDSL = dfExposure3))
  
  dfAE4 <- tibble::tribble(~SUBJID, 1,NA,1,1,2,2,4,4)
  
  dfExposure4<-tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    NA,   1, 10,
    2,   1, NA,
    3,   NA, 30,
    4,   2, 50
  )
  
  
  dfInput4 <-tibble::tribble(
    ~SubjectID, ~SiteID, ~Count, ~Exposure,~Rate,
    NA,   1, 0, 10, 0,
    2,    1,  2, NA, NA,
    3,   NA,  0, 30, 0 ,
    4,    2,  2, 50, .04
  )
  
  expect_equal(dfInput4, AE_Map_Raw(dfAE = dfAE4, dfRDSL = dfExposure4))
  
  
})



