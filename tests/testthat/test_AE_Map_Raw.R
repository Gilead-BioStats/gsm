
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

test_that("output is correct given example input",{
  
  dfAE <- data.frame(SUBJID = c(1,1,1,1,2,2))
  
  dfExposure <- data.frame(
    SubjectID = c(1,2,3),
    SiteID = c(1,1,1),
    Exposure = c(10, NA, 30)
  )
  
  dfInput <- data.frame(
    SubjectID = c(1,2,3),
    SiteID = c(1,1,1),
    Count = c(4,2,0),
    Exposure = c(10, NA, 30),
    Rate = c(0.4, NA, 0)
  )
  
  expect_equal(dfInput,  AE_Map_Raw(dfAE = dfAE, dfExposure = dfExposure))
  
  dfAE2 <- data.frame(SUBJID = c(1,1,1,1,2,2,4,4))
  
  dfExposure2 <- data.frame(
    SubjectID = c(1,2,3,4),
    SiteID = c(1,1,1,2),
    Exposure = c(10, NA, 30, 50)
  )
  
  
  
  dfInput2 <- data.frame(
    SubjectID = c(1,2,3,4),
    SiteID = c(1,1,1,2),
    Count = c(4,2,0,2),
    Exposure = c(10, NA, 30, 50),
    Rate = c(0.4, NA, 0, .04)
  )
  
  
  expect_equal(dfInput2,  as.data.frame(ungroup(AE_Map_Raw(dfAE = dfAE2, dfExposure = dfExposure2))))
  
  
  
})

test_that("NA values in input data are handled",{
  
  dfAE3 <- data.frame(SUBJID = c(1,1,1,1,2,2,4,4))
  
  dfExposure3 <- data.frame(
    SubjectID = c(NA,2,3,4),
    SiteID = c(1,1,NA,2),
    Exposure = c(10, NA, 30, 50)
  )
  
  
  dfInput3 <- data.frame(
    SubjectID = c(NA,2,3,4),
    SiteID = c(1,1,NA,2),
    Count = c(NA,2,0,2),
    Exposure = c(10, NA, 30, 50),
    Rate = c(NA, NA, 0, .04)
  )
  
  expect_equal(dfInput3,  as.data.frame(ungroup(AE_Map_Raw(dfAE = dfAE3, dfExposure = dfExposure3))))
  
  dfAE4 <- data.frame(SUBJID = c(1,1,NA,2,2,2,4,4))
  
  dfExposure4 <- data.frame(
    SubjectID = c(NA,2,3,4),
    SiteID = c(1,1,NA,2),
    Exposure = c(10, NA, 30, 50)
  )
  
  
  expect_warning(AE_Map_Raw(dfAE = dfAE4, dfExposure = dfExposure4))
  
  
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
      ungroup(dfExposure)  %>% select(-SubjectID)
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
  
  # renaming or dropping non-required cols is fine
  expect_silent(
    AE_Map_Raw( 
      clindata::raw_ae  %>% select(-PROJECT), 
      dfExposure
    )
  )
})


