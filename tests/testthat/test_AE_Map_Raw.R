
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
  
  # the tibble: Adding missing grouping variables: `SubjectID`??
  # expect_error(
  #   AE_Map_Raw(
  #     clindata::raw_ae ,
  #     dfExposure  %>% select(-SubjectID)
  #   )
  # )
  
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


