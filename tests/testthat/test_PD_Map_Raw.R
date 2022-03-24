dfPD <- clindata::raw_protdev %>%filter(SUBJID != "")
dfRDSL <- clindata::rawplus_rdsl

test_that("output created as expected and has correct structure",{
  pd_input <- PD_Map_Raw(dfPD, dfRDSL)%>%suppressWarnings
  expect_true(is.data.frame(pd_input))
  expect_equal(names(pd_input), c("SubjectID","SiteID","Exposure","Count","Rate"))
})

test_that("incorrect inputs throw errors",{

  expect_error(PD_Map_Raw(list(), list()) %>% suppressMessages, "Errors found in dfPD.")
  expect_error(PD_Map_Raw(dfPD, list()) %>% suppressMessages, "Errors found in dfRDSL.")
  expect_error(PD_Map_Raw(list(), dfRDSL) %>% suppressMessages, "Errors found in dfPD.")
  expect_error(PD_Map_Raw("Hi","Mom") %>% suppressMessages, "Errors found in dfPD.")
  expect_equal(expect_error(PD_Map_Raw(dfPD, dfRDSL, mapping = "napping") %>% suppressMessages)$message, "$ operator is invalid for atomic vectors")

})


test_that("error given if required column not found",{

  expect_error(
    PD_Map_Raw(
      dfPD %>% rename(ID = SUBJID),
      dfRDSL
    ) %>% suppressWarnings %>% suppressMessages, "Errors found in dfPD."
  )

  expect_error(
    PD_Map_Raw(
      dfPD,
      dfRDSL %>% select(-SiteID)
    ) %>% suppressWarnings %>% suppressMessages, "Errors found in dfRDSL."
  )

  expect_error(
    PD_Map_Raw(
      dfPD,
      dfRDSL %>% select(-SubjectID)
    ) %>% suppressWarnings %>% suppressMessages, "Errors found in dfRDSL."
  )


  expect_error(
    PD_Map_Raw(
      dfPD,
      dfRDSL %>% select(-SiteID)
    ) %>% suppressWarnings %>% suppressMessages, "Errors found in dfRDSL."
  )
})


test_that("NA values are caught",{

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

  expect_error(PD_Map_Raw(dfPD = dfPD, dfRDSL = dfTos)%>%suppressMessages, "Errors found in dfRDSL.")

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

  expect_error(PD_Map_Raw(dfPD = dfPD2, dfRDSL = dfTos2) %>% suppressMessages, "Errors found in dfRDSL.")

})

test_that("duplicate SubjectID values are caught in RDSL", {
  dfPD <- tribble(~SUBJID, 1,2)

  dfRDSL <- tribble(
    ~SubjectID, ~SiteID, ~TimeOnStudy,
    1,   1, 10,
    1,   1, 30
  )

  expect_error(
    PD_Map_Raw(
      dfPD,
      dfRDSL
    ) %>% suppressMessages, "Errors found in dfRDSL."
  )

})


test_that("custom mapping creates expected output", {

  custom_mapping <- list(
    dfPD = list(strIDCol="eye_dee"),
    dfRDSL = list(strIDCol="custom_id", strSiteCol="custom_site_id", strExposureCol = "TimeOnStudy")
  )

  custom_pd <- dfPD %>% rename(eye_dee = SUBJID)
  custom_rdsl <- dfRDSL %>% rename(custom_id = SubjectID,custom_site_id = SiteID)

  expect_true(
    is.data.frame(
      PD_Map_Raw(
        custom_pd,
        custom_rdsl,
        mapping = custom_mapping
      )%>%
      suppressWarnings
    )
  )
})



