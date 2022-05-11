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
