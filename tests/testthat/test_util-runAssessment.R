source(testthat::test_path("testdata/data.R"))
sae_meta <- yaml::read_yaml(system.file("workflow/experimental/sae.yaml", package = "gsm"))
rawDataMap <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

dfAE <- dfAE %>%
  tidyr::expand(dfAE, ae_serious = dfAE$aeser)

dfAE <- dfAE %>%
  tidyr::expand(dfAE, ae_te_flag = dfAE$ae_te) %>%
  select(-c(ae_serious, ae_te_flag))

# Valid Assessment Input
aeData <- list(dfSUBJ = dfSUBJ, dfAE = dfAE)
sae <- RunWorkflow(sae_meta, lData = aeData, lMapping = rawDataMap, bQuiet = TRUE) %>%
  suppressWarnings()

# Invalid Assessment Input
aeData_inv <- list(dfSUBJ = dfSUBJ, dfAE = dfAE)
aeData_inv$dfAE$subjid <- NA


sae_inv <- RunWorkflow(sae_meta, lData = aeData_inv, lMapping = rawDataMap, bQuiet = TRUE) %>%
  suppressWarnings()


test_that("Assessment data filtered as expected", {
  te_ae <- dfAE %>%
    filter(.data$ae_te == "Y" & .data$aeser == "Y")

  expect_equal(sae$lData$dfAE %>% nrow(), te_ae %>% nrow())
})

test_that("Assessment correctly labeled as valid", {
  expect_true(sae$bStatus)
  expect_false(sae_inv$bStatus)
})

test_that("workflow with multiple FilterDomain steps is reported correctly", {
  dfAE <- data.frame(
    stringsAsFactors = FALSE,
    subjid = c("1234", "1234", "5678", "5678"),
    aeser = c("Yes", "Yes", "Yes", "Yes"),
    ae_te = c(TRUE, TRUE, FALSE, TRUE),
    aetoxgr = c(1, 3, 1, 4)
  )

  dfSUBJ <- data.frame(
    stringsAsFactors = FALSE,
    subjid = c("1234", "5678", "9876"),
    siteid = c("X010X", "X102X", "X999X"),
    timeontreatment = c(3455, 1745, 1233),
    timeonstudy = c(1234, 2345, 4567),
    rfpen_dt = c("2012-09-02", "2017-05-08", "2018-05-20")
  )

  lAssessments <- MakeWorkflowList(bRecursive = TRUE, strNames = "sae")

  lData <- list(
    dfAE = dfAE,
    dfSUBJ = dfSUBJ
  )

  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))



  sae_assessment <- RunWorkflow(lAssessments$sae, lData = lData, lMapping = lMapping,  bQuiet = TRUE)


  expect_equal(names(sae_assessment$lChecks), c("FilterDomain", "FilterDomain", "AE_Map_Raw", "AE_Assess", "flowchart"))
})
