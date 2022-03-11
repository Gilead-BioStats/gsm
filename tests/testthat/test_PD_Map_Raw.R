test_that("output created as expected and has correct structure",{
  pd_input <- PD_Map_Raw(dfPD = clindata::raw_protdev,dfRDSL = clindata::rawplus_rdsl )
  expect_true(is.data.frame(pd_input))
  expect_equal(
    names(pd_input),
    c("SubjectID","SiteID","Count","Exposure","Rate"))
})

test_that("incorrect inputs throw errors",{

  expect_error(PD_Map_Raw(list(), list()))
  expect_error(PD_Map_Raw( clindata::raw_protdev, list()))
  expect_error(PD_Map_Raw(list(), clindata::rawplus_rdsl ))
  expect_error(PD_Map_Raw("Hi","Mom"))
})


test_that("error given if required column not found",{
  expect_error(
    PD_Map_Raw(
      clindata::raw_protdev %>% rename(ID = SUBJID),
      clindata::rawplus_rdsl
    )
  )

  expect_error(
    PD_Map_Raw(
      clindata::raw_protdev ,
      clindata::rawplus_rdsl   %>% select(-SiteID)
    )
  )

  expect_error(
    PD_Map_Raw(
      clindata::raw_protdev ,
      clindata::rawplus_rdsl  %>% select(-SubjectID)
    )
  )



  expect_error(
    PD_Map_Raw(
      clindata::raw_protdev ,
      clindata::rawplus_rdsl,
      strExposureCol="Exposure"
    )
  )

  expect_error(
    PD_Map_Raw(
      clindata::raw_protdev ,
      clindata::rawplus_rdsl  %>% select(-SiteID)
    )
  )


  expect_silent(
    PD_Map_Raw(
      clindata::raw_protdev  %>% select(-COUNTRY),
      clindata::rawplus_rdsl
    )
  )
})


test_that("output is correct given example input",{


  dfPD <- tribble(~SUBJID, 1,1,1,1,2,2)

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


  expect_equal(dfInput,  PD_Map_Raw(dfPD = dfPD, dfRDSL = dfTos))

  dfPD2 <- tribble(~SUBJID, 1,1,1,1,2,2,4,4)

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



  expect_equal(dfInput2,  PD_Map_Raw(dfPD = dfPD2, dfRDSL = dfTos2))



})

test_that("NA values in input data are handled",{

  dfPD3 <- tribble(~SUBJID, 1,1,1,1,2,2,4,4)

  dfTos3<-tribble(
    ~SubjectID, ~SiteID, ~TimeOnStudy,
    NA,   1, 10,
    2,   1, NA,
    3,   NA, 30,
    4,   2, 50
  )


  dfInput3 <-tribble(
    ~SubjectID, ~SiteID, ~Count, ~Exposure,~Rate,
    NA,   1, 0, 10, 0,
    2,    1,  2, NA, NA,
    3,   NA,  0, 30, 0 ,
    4,    2,  2, 50, .04
  )

  expect_equal(dfInput3, PD_Map_Raw(dfPD = dfPD3, dfRDSL = dfTos3))

  dfPD4 <- tribble(~SUBJID, 1,NA,1,1,2,2,4,4)

  dfTos4<-tribble(
    ~SubjectID, ~SiteID, ~TimeOnStudy,
    NA,   1, 10,
    2,   1, NA,
    3,   NA, 30,
    4,   2, 50
  )


  dfInput4 <-tribble(
    ~SubjectID, ~SiteID, ~Count, ~Exposure,~Rate,
    NA,   1, 0, 10, 0,
    2,    1,  2, NA, NA,
    3,   NA,  0, 30, 0 ,
    4,    2,  2, 50, .04
  )

  expect_equal(dfInput4, PD_Map_Raw(dfPD = dfPD4, dfRDSL = dfTos4))


})

test_that("strExposure user input error is handled correctly", {
  expect_error(
    PD_Map_Raw(clindata::raw_protdev,clindata::rawplus_rdsl, strExposureCol = 123)
  )
  
  expect_error(
    PD_Map_Raw(clindata::raw_protdev,clindata::rawplus_rdsl, strExposureCol = c("A", "B"))
  )
})

test_that("Non-default value for strExposureCol is handled correctly",{
  dfPD4 <- tribble(~SUBJID, 1,NA,1,1,2,2,4,4)
  
  dfTos4<-tribble(
    ~SubjectID, ~SiteID, ~TimeInOurClinicalTrial,
    NA,   1, 10,
    2,   1, NA,
    3,   NA, 30,
    4,   2, 50
  )
  
  
  dfInput4 <-tribble(
    ~SubjectID, ~SiteID, ~Count, ~Exposure,~Rate,
    NA,   1, 0, 10, 0,
    2,    1,  2, NA, NA,
    3,   NA,  0, 30, 0 ,
    4,    2,  2, 50, .04
  )
  
  expect_equal(dfInput4, PD_Map_Raw(dfPD = dfPD4, dfRDSL = dfTos4, strExposureCol = 'TimeInOurClinicalTrial'))
  expect_error( PD_Map_Raw(dfPD = dfPD4, dfRDSL = dfTos4, strExposureCol = 'IncorrectColumnName'))
  expect_error( PD_Map_Raw(dfPD = dfPD4, dfRDSL = dfTos4))
})




