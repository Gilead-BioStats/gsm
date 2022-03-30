dfRDSL <- clindata::rawplus_rdsl %>% dplyr::filter(!is.na(TimeOnTreatment))


dfLab <-  clindata::rawplus_covlab_hema[1:10000,] %>%
  filter(SUBJID != "")


mapping <- list(
  dfLab= list(strIDCol="SUBJID"),
  dfRDSL=list(strIDCol="SubjectID", strSiteCol="SiteID", strExposureCol="TimeOnTreatment")
)

test_that("output created as expected and has correct structure",{
  lab_input <- LabAbnorm_Map_Raw(dfLab = dfLab, dfRDSL = dfRDSL)
  expect_true(is.data.frame(lab_input))
  expect_equal(
  names(lab_input),
  c("SubjectID","SiteID","Count","Exposure","Rate"))
})

test_that("all data is mapped and summarized correctly",{
  Lab_counts <- clindata::rawplus_covlab_hema[1:10000,] %>%
    filter(SUBJID != "") %>%
    group_by(SUBJID) %>%
    summarize("Count" = n()) %>%
    ungroup() %>%
    select(SUBJID, Count)

  Lab_mapped <- clindata::rawplus_rdsl %>%
    filter(!is.na(TimeOnTreatment)) %>%
    left_join(Lab_counts, by = c("SubjectID" = "SUBJID")) %>%
    mutate(Count = as.integer(replace(Count, is.na(Count), 0))) %>%
    rename(Exposure = TimeOnTreatment) %>%
    mutate(Rate = Count / Exposure) %>%
    select(SubjectID, SiteID, Count, Exposure, Rate)

  expect_identical(LabAbnorm_Map_Raw(dfLab, dfRDSL),
                   Lab_mapped)
})

test_that("incorrect inputs throw errors",{
  expect_error(LabAbnorm_Map_Raw(list(), list()))
  expect_error(LabAbnorm_Map_Raw(dfLab, list()))
  expect_error(LabAbnorm_Map_Raw(list(), dfRDSL))
  expect_error(LabAbnorm_Map_Raw("Hi", "Mom"))
  expect_error(LabAbnorm_Map_Raw(dfLab, dfRDSL,strTypeCol = c("A", "B") ))
  expect_error(LabAbnorm_Map_Raw(dfLab, dfRDSL,strTypeCol = 123.4 ))
  expect_error(LabAbnorm_Map_Raw(dfLab, dfRDSL,strTypeCol = 123.4 ))
  expect_error(LabAbnorm_Map_Raw(dfLab, dfRDSL,strTypeCol = 123.4 ))
  expect_error(LabAbnorm_Map_Raw(dfLab, dfRDSL,strTypeCol = 123.4 ))
  
})

test_that("incomplete or invalid filter parameters throw warnings",{
  dfLab <-  clindata::rawplus_covlab_hema[1:10000,] %>%
    filter(SUBJID != "")
  
  expect_warning( LabAbnorm_Map_Raw(dfLab = dfLab, dfRDSL = dfRDSL, strTypeCol = 'LBTEST',strTypeValue =  NULL, strFlagCol = 'TOXFLG', strFlagValue = 1 ))
  expect_warning( LabAbnorm_Map_Raw(dfLab = dfLab, dfRDSL = dfRDSL, strTypeCol = NULL,strTypeValue =   "ALT (SGPT)", strFlagCol = 'TOXFLG', strFlagValue = 1 ))
  expect_warning( LabAbnorm_Map_Raw(dfLab = dfLab, dfRDSL = dfRDSL, strTypeCol = 'Col not found',strTypeValue =   "ALT (SGPT)", strFlagCol = 'TOXFLG', strFlagValue = 1 ))
  expect_warning( LabAbnorm_Map_Raw(dfLab = dfLab, dfRDSL = dfRDSL, strTypeCol = 'LBTEST',strTypeValue =   "Value not found", strFlagCol = 'TOXFLG', strFlagValue = 1 ))
  expect_warning( LabAbnorm_Map_Raw(dfLab = dfLab, dfRDSL = dfRDSL, strTypeCol = 'LBTEST',strTypeValue =   "ALT (SGPT)", strFlagCol = NULL, strFlagValue = 1 ))
  expect_warning( LabAbnorm_Map_Raw(dfLab = dfLab, dfRDSL = dfRDSL, strTypeCol = 'LBTEST',strTypeValue =   "ALT (SGPT)", strFlagCol = 'Flag not found', strFlagValue = 1 ))
  expect_warning( LabAbnorm_Map_Raw(dfLab = dfLab, dfRDSL = dfRDSL, strTypeCol = 'LBTEST',strTypeValue =   "ALT (SGPT)", strFlagCol = 'TOXFLG', strFlagValue = "Flagvalue not found" ))
  expect_warning( LabAbnorm_Map_Raw(dfLab = dfLab, dfRDSL = dfRDSL, strTypeCol = 'LBTEST',strTypeValue =  NULL, strFlagCol = NULL, strFlagValue = NULL ) )
  
})


test_that("error given if required column not found",{
  expect_error(
    LabAbnorm_Map_Raw(
      dfLab %>% rename(ID = SUBJID),
      dfRDSL
    )
  )

  expect_error(
    LabAbnorm_Map_Raw(
      dfLab,
      dfRDSL %>% select(-SiteID)
    )
  )

  expect_error(
    LabAbnorm_Map_Raw(
      dfLab,
      dfRDSL %>% select(-SubjectID)
    )
  )

  expect_error(
    LabAbnorm_Map_Raw(
      dfLab,
      dfRDSL %>% select(-TimeOnTreatment)
    )
  )

  expect_error(
    LabAbnorm_Map_Raw(
      dfLab,
      dfRDSL %>% select(-SiteID)
    )
  )

 
})




test_that("NA values in input data are handled",{

  dfLab3 <- tibble::tribble(~SUBJID, 1,1,1,1,2,2,4,4)

  dfExposure3<-tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, NA,
    3,   NA, 30,
    4,   2, 50
  )


  expect_error(LabAbnorm_Map_Raw(dfLab = dfLab3, dfRDSL = dfExposure3))


})


test_that("dfLab$SUBJID NA value throws error",{
  dfLab4 <- tibble::tribble(~SUBJID, 1,NA,1,1,2,2,4,4)

  dfExposure4<-tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, 20,
    3,   3, 30,
    4,   2, 50
  )


  expect_error(LabAbnorm_Map_Raw(dfLab = dfLab4, dfRDSL = dfExposure4))
})

test_that("dfRDSL$SubjectID NA value throws error",{
  dfLab4 <- tibble::tribble(~SUBJID, 1,1,1,1,2,2,4,4)

  dfExposure4<-tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    NA,   1, 10,
    2,   1, 20,
    3,   2, 30,
    4,   2, 50
  )


  expect_error(LabAbnorm_Map_Raw(dfLab = dfLab4, dfRDSL = dfExposure4))
})


test_that("custom mapping runs without errors", {
  custom_mapping <- list(
    dfLab= list(strIDCol="SUBJID"),
    dfRDSL=list(strIDCol="custom_id", strSiteCol="custom_site_id", strExposureCol="trtmnt")
  )
  
  
  custom_rdsl <- dfRDSL %>%
    mutate(trtmnt = TimeOnTreatment * 2.025) %>%
    rename(custom_id = SubjectID,
           custom_site_id = SiteID)
  
  expect_message(LabAbnorm_Map_Raw(dfLab, custom_rdsl, mapping = custom_mapping))
})



