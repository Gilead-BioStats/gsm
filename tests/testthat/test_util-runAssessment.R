source(testthat::test_path("testdata/data.R"))
sae_meta <- yaml::read_yaml(system.file("assessments/sae.yaml", package = "gsm"))
rawDataMap <- clindata::mapping_rawplus

dfAE <- dfAE %>%
  expand(dfAE, ae_serious = dfAE$AE_SERIOUS)

dfAE <- dfAE %>%
  expand(dfAE, ae_te_flag = dfAE$AE_TE_FLAG) %>%
  select(-c(AE_SERIOUS, AE_TE_FLAG)) %>%
  rename(
    AE_SERIOUS = ae_serious,
    AE_TE_FLAG = ae_te_flag
  )

# Valid Assessment Input
aeData <- list(dfSUBJ = dfSUBJ, dfAE = dfAE)
sae <- RunAssessment(sae_meta, lData = aeData, lMapping = rawDataMap, bQuiet = TRUE)

# Invalid Assessment Input
aeData_inv <- list(dfSUBJ = dfSUBJ, dfAE = dfAE)
aeData_inv$dfAE$SubjectID[1:15] <- NA


sae_inv <- RunAssessment(sae_meta, lData = aeData_inv, lMapping = rawDataMap, bQuiet = TRUE)


test_that("Assessment data filtered as expected", {
  te_ae <- dfAE %>%
    filter(.data$AE_TE_FLAG == TRUE & .data$AE_SERIOUS == "Yes")

  expect_equal(sae$lData$dfAE %>% nrow(), te_ae %>% nrow())
})

test_that("Assessment correctly labeled as valid", {
  expect_true(sae$bStatus)
  expect_false(sae_inv$bStatus)
})

test_that("workflow with multiple FilterDomain steps is reported correctly", {


  dfAE <- data.frame(
    stringsAsFactors = FALSE,
    SubjectID = c("1234", "1234", "5678", "5678"),
    AE_SERIOUS = c("Yes", "Yes", "Yes", "Yes"),
    AE_TE_FLAG = c(TRUE, TRUE, FALSE, TRUE),
    AE_GRADE = c(1, 3, 1, 4)
  )

  dfSUBJ <- data.frame(
    stringsAsFactors = FALSE,
    SubjectID = c("1234", "5678", "9876"),
    SiteID = c("X010X", "X102X", "X999X"),
    TimeOnTreatment = c(3455, 1745, 1233),
    TimeOnStudy = c(1234, 2345, 4567),
    RandDate = c("2012-09-02", "2017-05-08", "2018-05-20")
  )

  lAssessments <- MakeAssessmentList()

  lData <- list(
    dfAE = dfAE,
    dfSUBJ = dfSUBJ
  )
  lTags <- list(
    Study = "myStudy"
  )
  lMapping <- clindata::mapping_rawplus


  sae_assessment <- RunAssessment(lAssessments$sae, lData = lData, lMapping = lMapping, lTags = lTags)

  expect_equal(names(sae_assessment$checks), c("FilterDomain", "FilterDomain", "AE_Map_Raw", "AE_Assess"))
})
