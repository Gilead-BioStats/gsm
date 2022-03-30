input1 <- clindata::raw_ae %>%
  filter(!SUBJID %in% c("", "1163", "1194"))

input2 <- clindata::rawplus_rdsl %>%
  filter(!is.na(TimeOnTreatment))

mapping <- list(
  dfAE= list(strIDCol="SUBJID"),
  dfRDSL=list(strIDCol="SubjectID",
              strSiteCol="SiteID",
              strExposureCol="TimeOnTreatment")
)

test_that("output created as expected and has correct structure",{
  data <- AE_Map_Raw(
    dfAE = input1,
    dfRDSL = input2
    )

  expect_true(
    is.data.frame(
      data
    )
  )

  expect_equal(
    names(data),
    c("SubjectID", "SiteID", "Count", "Exposure", "Rate")
  )

})



test_that("incorrect inputs throw errors",{
  expect_snapshot_error(
    AE_Map_Raw(
      list(), list()
    )
  )

  expect_snapshot_error(
    AE_Map_Raw(
      input1, list()
    )
  )

  expect_snapshot_error(
    AE_Map_Raw(
      list(), input2
    )
  )

  expect_snapshot_error(
    AE_Map_Raw(
      "Hi", "Mom"
    )
  )

  expect_snapshot_error(
    AE_Map_Raw(
      input1, input2, mapping = list()
    )
  )
})


test_that("error given if required column not found",{

  expect_snapshot_error(
    AE_Map_Raw(
      input1 %>% select(-SUBJID),
      input2
    )
  )

  expect_snapshot_error(
    AE_Map_Raw(
      input1,
      input2 %>% select(-SiteID)
    )
  )

  expect_snapshot_error(
    AE_Map_Raw(
      input1,
      input2 %>% select(-SubjectID)
    )
  )

  expect_snapshot_error(
    AE_Map_Raw(
      input1,
      input2 %>% select(-TimeOnTreatment)
    )
  )

  expect_snapshot_error(
    AE_Map_Raw(
      input1,
      input2,
      mapping = list(
        dfAE= list(strIDCol="not an id"),
        dfRDSL=list(strIDCol="SubjectID",
                    strSiteCol="SiteID",
                    strExposureCol="TimeOnTreatment")
      )
    )
  )

  expect_snapshot_error(
    AE_Map_Raw(
      input1,
      input2,
      mapping = list(
        dfAE= list(strIDCol="SUBJID"),
        dfRDSL=list(strIDCol="not an id",
                    strSiteCol="SiteID",
                    strExposureCol="TimeOnTreatment")
      )
    )
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
    mutate(Count = replace(Count, is.na(Count), 0),
           Rate = Count / TimeOnTreatment) %>%
    select(SubjectID, SiteID, Exposure = TimeOnTreatment, Count, Rate)

  expect_equal(
    AE_Map_Raw(input1, input2),
    AE_mapped
    )

})

test_that("NA values in input data are handled",{

  dfAE1 <- tibble::tribble(~SUBJID, 1,1,1,1,2,2,4,4)

  dfExposure1 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, NA,
    3,   NA, 30,
    4,   2, 50
  )

  dfAE2 <- tibble::tribble(~SUBJID, 1,NA,1,1,2,2,4,4)

  dfExposure2 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, 20,
    3,   3, 30,
    4,   2, 50
  )

  dfAE3 <- tibble::tribble(~SUBJID, 1,1,1,1,2,2,4,4)

  dfExposure3 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    NA,   1, 10,
    2,   1, 20,
    3,   2, 30,
    4,   2, 50
  )


  expect_snapshot_error(
    AE_Map_Raw(
      dfAE = dfAE1,
      dfRDSL = dfExposure1
      )
    )

  expect_snapshot_error(
    AE_Map_Raw(
      dfAE = dfAE2,
      dfRDSL = dfExposure2
    )
  )

  expect_snapshot_error(
    AE_Map_Raw(
      dfAE = dfAE3,
      dfRDSL = dfExposure3
    )
  )

})

test_that("custom mapping runs without errors", {

  custom_mapping <- list(
    dfAE= list(strIDCol="SUBJID"),
    dfRDSL=list(strIDCol="custom_id",
                strSiteCol="custom_site_id",
                strExposureCol="trtmnt")
  )


  custom_rdsl <- input2 %>%
    mutate(trtmnt = TimeOnTreatment * 2.025) %>%
    rename(custom_id = SubjectID,
           custom_site_id = SiteID)

  expect_message(
    AE_Map_Raw(
      input1,
      custom_rdsl,
      mapping = custom_mapping
      )
    )
})

