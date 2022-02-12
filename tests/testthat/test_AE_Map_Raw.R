
dfExposure <- TreatmentExposure(  dfEx = clindata::raw_ex,  dfSdrg = NULL, dtSnapshot = NULL)

test_that("output created as expected and has correct structure",{
  ae_input <- AE_Map_Raw(dfAE = clindata::raw_ae,dfExposure = dfExposure )
   expect_true(is.data.frame(ae_input))
  
   expect_equal(
   names(ae_input),
   c("SubjectID","SiteID","Count","Exposure","Rate"))
 })

test_that("incorrect inputs throw errors",{
    expect_error(AE_Map_Raw(list(), list()))
    expect_error(AE_Map_Raw("Hi","Mom"))
})


test_that("incorrect inputs throw errors",{
 
  expect_error(AE_Map_Raw(list(), list()))
  expect_error(AE_Map_Raw( clindata::raw_ae, list()))
  expect_error(AE_Map_Raw(list(),  dfExposure))
  expect_error(AE_Map_Raw("Hi","Mom"))
})


test_that("error given if required column not found",{
  expect_error(
    AE_Map_Raw( 
      clindata::raw_ae %>% rename(ID = SUBJID), 
      dfExposure
    )
  )
  
  expect_error(
    AE_Map_Raw(
      clindata::raw_ae ,
      dfExposure  %>% select(-SiteID)
    )
  )
  
  expect_error(
    AE_Map_Raw( 
      clindata::raw_ae , 
      dfExposure  %>% select(-SubjectID)
    )
  )
  
  
  
  expect_error(
    AE_Map_Raw( 
      clindata::raw_ae , 
      dfExposure  %>% select(-Exposure)
    )
  )
  
  expect_error(
    AE_Map_Raw( 
      clindata::raw_ae , 
      dfExposure  %>% select(-SiteID)
    )
  )
  
  
  expect_silent(
    AE_Map_Raw( 
      clindata::raw_ae  %>% select(-PROJECT), 
      dfExposure
    )
  )
})


test_that("output is correct given example input",{
  

  dfAE <- tibble::tribble(~SUBJID, 1,1,1,1,2,2)
  
  dfExposure<-tibble::tribble(
    ~SubjectID, ~SiteID, ~Exposure,
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
  

  expect_equal(dfInput,  AE_Map_Raw(dfAE = dfAE, dfExposure = dfExposure))
  
  dfAE2 <- tibble::tribble(~SUBJID, 1,1,1,1,2,2,4,4)
  
  dfExposure2<-tibble::tribble(
    ~SubjectID, ~SiteID, ~Exposure,
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
  
  
  
  expect_equal(dfInput2,  AE_Map_Raw(dfAE = dfAE2, dfExposure = dfExposure2))
  
  
  
})

test_that("NA values in input data are handled",{
  
  dfAE3 <- tibble::tribble(~SUBJID, 1,1,1,1,2,2,4,4)
  
  dfExposure3<-tibble::tribble(
    ~SubjectID, ~SiteID, ~Exposure,
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
  
  expect_equal(dfInput3, AE_Map_Raw(dfAE = dfAE3, dfExposure = dfExposure3))
  
  dfAE4 <- tibble::tribble(~SUBJID, 1,NA,1,1,2,2,4,4)
  
  dfExposure4<-tibble::tribble(
    ~SubjectID, ~SiteID, ~Exposure,
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
  
  expect_equal(dfInput4, AE_Map_Raw(dfAE = dfAE4, dfExposure = dfExposure4))
  
  
})



