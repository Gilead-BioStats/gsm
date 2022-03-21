dfPD <- clindata::raw_protdev %>%
  filter(SUBJID != "")

dfRDSL <- clindata::rawplus_rdsl


test_that("output created as expected and has correct structure",{

  pd_input <- PD_Map_Raw(dfPD, dfRDSL)

  expect_true(
    is.data.frame(
      pd_input
      )
    )

  expect_equal(
    names(pd_input),
    c("SubjectID","SiteID","Count","Exposure","Rate")
    )

})

test_that("incorrect inputs throw errors",{

  expect_error(PD_Map_Raw(list(), list()) %>% suppressMessages)
  expect_error(PD_Map_Raw(dfPD, list()) %>% suppressMessages)
  expect_error(PD_Map_Raw(list(), dfRDSL) %>% suppressMessages)
  expect_error(PD_Map_Raw("Hi","Mom") %>% suppressMessages)
  expect_error(PD_Map_Raw(dfPD, dfRDSL, mapping = "napping") %>% suppressMessages)

})


test_that("error given if required column not found",{

  expect_error(
    PD_Map_Raw(
      dfPD %>% rename(ID = SUBJID),
      dfRDSL
    ) %>% suppressMessages
  )

  expect_error(
    PD_Map_Raw(
      dfPD,
      dfRDSL %>% select(-SiteID)
    ) %>% suppressMessages
  )

  expect_error(
    PD_Map_Raw(
      dfPD,
      dfRDSL %>% select(-SubjectID)
    ) %>% suppressMessages
  )

  expect_error(
    PD_Map_Raw(
      dfPD,
      dfRDSL,
      strExposureCol="Exposure"
    ) %>% suppressMessages
  )

  expect_error(
    PD_Map_Raw(
      dfPD,
      dfRDSL %>% select(-SiteID)
    ) %>% suppressMessages
  )

  expect_silent(
    PD_Map_Raw(
      dfPD %>% select(-COUNTRY),
      dfRDSL
    ) %>% suppressMessages
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

  expect_error(
    PD_Map_Raw(dfPD = dfPD, dfRDSL = dfTos) %>% suppressMessages
    )

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

  expect_error(
    PD_Map_Raw(dfPD = dfPD2, dfRDSL = dfTos2) %>% suppressMessages
    )

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
    ) %>% suppressMessages
  )

})

test_that("strExposure user input error is handled correctly", {
  expect_error(
    PD_Map_Raw(
      dfPD,
      dfRDSL,
      strExposureCol = 123
      ) %>% suppressMessages
  )

  expect_error(
    PD_Map_Raw(
      dfPD,
      dfRDSL,
      strExposureCol = c("A", "B")
      ) %>% suppressMessages
  )

})

test_that("custom mapping runs without errors", {

  custom_mapping <- list(
    dfPD = list(strIDCol="eye_dee"),
    dfRDSL = list(strIDCol="custom_id", strSiteCol="custom_site_id", strExposureCol = "TimeOnStudy")
  )

  custom_pd <- dfPD %>%
    rename(eye_dee = SUBJID)

  custom_rdsl <- dfRDSL %>%
    rename(custom_id = SubjectID,
           custom_site_id = SiteID)

  expect_message(
    PD_Map_Raw(
      custom_pd,
      custom_rdsl,
      mapping = custom_mapping)
    )
})



