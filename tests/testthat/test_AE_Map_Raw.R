dfAE <- clindata::raw_ae %>%
  filter(SUBJID != "") %>%
  filter(SUBJID !="1163") %>%
  filter(SUBJID != "1194")

dfRDSL <- clindata::rawplus_rdsl %>% filter(!is.na(TimeOnTreatment))

mapping <- list(
  dfAE= list(strIDCol="SUBJID"),
  dfRDSL=list(strIDCol="SubjectID", strSiteCol="SiteID", strExposureCol="TimeOnTreatment")
)

test_that("output created as expected and has correct structure",{
  ae_input <- AE_Map_Raw(dfAE = dfAE, dfRDSL = dfRDSL)
  expect_true(is.data.frame(ae_input))
  expect_equal(
    names(ae_input),
    c("SubjectID","SiteID","Exposure","Count","Rate")
  )
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
    mutate(Count = replace(Count, is.na(Count), 0)) %>%
    rename(Exposure = TimeOnTreatment) %>%
    mutate(Rate = Count / Exposure) %>%
    select(SubjectID, SiteID, Exposure, Count, Rate)

  expect_equal(AE_Map_Raw(dfAE, dfRDSL), AE_mapped)
})

test_that("incorrect inputs throw errors",{
  expect_error(AE_Map_Raw(list(), list())%>%suppressMessages, "Errors found in dfAE.")
  expect_error(AE_Map_Raw(dfAE, list())%>%suppressMessages, "Errors found in dfRDSL.")
  expect_error(AE_Map_Raw(list(), dfRDSL)%>%suppressMessages,"Errors found in dfAE.")
  expect_error(AE_Map_Raw("Hi", "Mom")%>%suppressMessages,"Errors found in dfAE.")
  expect_error(AE_Map_Raw(dfAE, dfRDSL, mapping = list())%>%suppressMessages,"Errors found in dfAE.")
})


test_that("error given if required column not found",{
  expect_error(
    AE_Map_Raw(
      dfAE %>% rename(ID = SUBJID),
      dfRDSL
    )%>% suppressMessages, "Errors found in dfAE."
  )

  expect_error(
    AE_Map_Raw(
      dfAE,
      dfRDSL %>% select(-SiteID)
    )%>% suppressMessages, "Errors found in dfRDSL."
  )

  expect_error(
    AE_Map_Raw(
      dfAE,
      dfRDSL %>% select(-SubjectID)
    )%>% suppressMessages,"Errors found in dfRDSL."
  )

  expect_error(
    AE_Map_Raw(
      dfAE,
      dfRDSL %>% select(-TimeOnTreatment)
    )%>% suppressMessages, "Errors found in dfRDSL."
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
    )%>% suppressMessages, "Errors found in dfAE."
  )

  expect_error(
    AE_Map_Raw(
      dfAE,
      dfRDSL %>% select(-SiteID)
    )%>% suppressMessages , "Errors found in dfRDSL."
  )

  expect_message(
      AE_Map_Raw(
      dfAE %>% select(-PROJECT),
      dfRDSL
    )
  )
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


  expect_error(AE_Map_Raw(dfAE = dfAE3, dfRDSL = dfExposure3)%>%suppressMessages,"Errors found in dfRDSL." )


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


  expect_error(AE_Map_Raw(dfAE = dfAE4, dfRDSL = dfExposure4)%>%suppressMessages,"Errors found in dfAE." )
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


  expect_error(AE_Map_Raw(dfAE = dfAE4, dfRDSL = dfExposure4)%>%suppressMessages,"Errors found in dfRDSL." )
})




test_that("custom mapping runs without errors", {
  custom_mapping <- list(
    dfAE= list(strIDCol="SUBJID"),
    dfRDSL=list(strIDCol="custom_id", strSiteCol="custom_site_id", strExposureCol="trtmnt")
  )


  custom_rdsl <- dfRDSL %>%
    mutate(trtmnt = TimeOnTreatment * 2.025) %>%
    rename(custom_id = SubjectID,
           custom_site_id = SiteID)

  expect_message(AE_Map_Raw(dfAE, custom_rdsl, mapping = custom_mapping))
})

