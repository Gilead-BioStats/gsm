source(testthat::test_path("testdata/data.R"))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  data <- AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ))
  expect_true(is.data.frame(data))
  expect_equal(names(data), c("SubjectID", "SiteID", "Count", "Exposure", "Rate"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = list(), dfSUBJ = list()), bQuiet = F))
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = list()), bQuiet = F))
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = list(), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = "Hi", dfSUBJ = "Mom"), bQuiet = F))
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE %>% select(-SubjectID), dfSUBJ = dfSUBJ), bQuiet = F))
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ %>% select(-SiteID)), bQuiet = F))
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ %>% select(-SubjectID)), bQuiet = F))
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ %>% select(-TimeOnTreatment)), bQuiet = F))
  expect_snapshot(AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = bind_rows(dfSUBJ, head(dfSUBJ, 1))), bQuiet = F))
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors",{

  expect_snapshot(
    AE_Map_Raw(
      dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ),
      lMapping = list(dfAE = list(strIDCol="not an id"),
                      dfSUBJ=list(strIDCol="SubjectID",
                      strSiteCol="SiteID",
                      strTimeOnTreatmentCol="TimeOnTreatment")),
      bQuiet = F
      )
    )

  expect_snapshot(
    AE_Map_Raw(
      dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ),
      lMapping = list(dfAE = list(strIDCol="SubjectID"),
                      dfSUBJ=list(strIDCol="not an id",
                                  strSiteCol="SiteID",
                                  strTimeOnTreatmentCol="TimeOnTreatment")),
      bQuiet = F
    )
  )

})

# custom tests ------------------------------------------------------------
test_that("NA values in input data are handled",{
  # NA SiteID and TimeOnTreatment.
  dfExposure1 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1, 1, 10,
    2, 1, NA,
    3, NA, 30,
    4, 2, 50
  )
  dfAE1 <- tibble::tribble(
    ~SubjectID, 1,1,1,1,2,2,4,4
  )
  mapped1 <- AE_Map_Raw(
    list(dfAE = dfAE1, dfSUBJ = dfExposure1)
  )
  expect_null(mapped1)

  # NA SubjectID in AE domain.
  dfExposure2 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    1,   1, 10,
    2,   1, 20,
    3,   3, 30,
    4,   2, 50
  )
  dfAE2 <- tibble::tribble(
    ~SubjectID, 1,NA,1,1,2,2,4,4
  )
  mapped2 <- AE_Map_Raw(
    list(dfAE = dfAE2, dfSUBJ = dfExposure2)
  )
  expect_null(mapped2)

  # NA SubjectID in SUBJ domain.
  dfAE3 <- tibble::tribble(~SubjectID, 1,1,1,1,2,2,4,4)
  dfExposure3 <- tibble::tribble(
    ~SubjectID, ~SiteID, ~TimeOnTreatment,
    NA,   1, 10,
    2,   1, 20,
    3,   2, 30,
    4,   2, 50
  )
  mapped3 <- AE_Map_Raw(
    list(dfAE = dfAE3, dfSUBJ = dfExposure3)
  )
  expect_null(mapped2)

  #expect_snapshot_error(AE_Map_Raw(dfAE = dfAE1, dfSUBJ = dfExposure1))
  #expect_snapshot_error(AE_Map_Raw(dfAE = dfAE2, dfSUBJ = dfExposure2))
  #expect_snapshot_error(AE_Map_Raw(dfAE = dfAE3, dfSUBJ = dfExposure3))
})
#
# test_that("custom mapping runs without errors", {
#
#   custom_mapping <- list(
#     dfAE= list(strIDCol="SubjectID",
#                strTreatmentEmergentCol = "AE_TE_FLAG"),
#     dfSUBJ=list(strIDCol="custom_id",
#                 strSiteCol="custom_site_id",
#                 strTimeOnTreatmentCol="trtmnt")
#   )
#
#   custom_subj <- dfSUBJ %>%
#     mutate(trtmnt = TimeOnTreatment * 2.025) %>%
#     rename(custom_id = SubjectID,
#            custom_site_id = SiteID)
#
#   expect_silent(AE_Map_Raw(dfAE, custom_subj, mapping = custom_mapping))
#
# })

