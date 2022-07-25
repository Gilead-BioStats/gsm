source(testthat::test_path("testdata/data.R"))

lData <- list(
  dfSUBJ = dfSUBJ,
  dfAE = dfAE,
  dfPD = dfPD,
  dfCONSENT = dfCONSENT,
  dfIE = dfIE,
  dfDISP = dfDISP
)

lAssessments <- MakeAssessmentList()

lAssessments$aeGrade <- NULL # Drop stratified assessment

result <- Study_Assess(lData = lData, lAssessments= lAssessments, bQuiet = TRUE)

lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))


# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  expect_equal(10, length(result))
  expect_equal(c("ae", "aeQTL", "consent", "dispStudy", "dispStudyWithdrew",
                 "dispTreatment", "ie", "importantpd", "pd", "sae"), names(result))
  expect_true(all(map_chr(result, ~ class(.)) == "list"))
  expect_equal(names(result$ae$lResults), c(
    "strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed",
    "dfAnalyzed", "dfFlagged", "dfSummary", "chart", "lChecks"
  ))
})

# metadata is returned as expected ----------------------------------------
test_that("metadata is returned as expected", {
  ae <- result$ae
  expect_equal(ae$tags, list(Assessment = "Safety", Label = "AEs"))
  expect_equal(ae$lResults$strFunctionName, "AE_Assess()")
  expect_equal(ae$workflow[[1]], list(
    name = "FilterDomain", inputs = "dfAE", output = "dfAE",
    params = list(
      strDomain = "dfAE", strColParam = "strTreatmentEmergentCol",
      strValParam = "strTreatmentEmergentVal"
    )
  ))
  expect_equal(ae$name, "ae")
  expect_true(ae$bStatus)
})



# custom tests ------------------------------------------------------------



# Study_Assess() runs with missing datasets -------------------------------

test_that("Study_Assess() runs with missing datasets", {
  lData <- list(
    dfSUBJ = dfSUBJ,
    dfAE = dfAE,
    dfPD = dfPD
  )

  result <- Study_Assess(lData = lData, lAssessments= lAssessments, bQuiet = TRUE)

  expect_true(result$ae$bStatus)
  expect_true(result$sae$bStatus)
  expect_true(result$pd$bStatus)
  expect_true(result$importantpd$bStatus)
  expect_false(result$consent$bStatus)
  expect_false(result$ie$bStatus)
  expect_false("lResults" %in% names(result$consent))
  expect_false("lResults" %in% names(result$ie))
  expect_equal(10, length(result))
  expect_equal(c("ae",
                 "aeQTL",
                 "consent",
                 "dispStudy",
                 "dispStudyWithdrew",
                 "dispTreatment",
                 "ie",
                 "importantpd",
                 "pd",
                 "sae"), names(result))
  expect_equal(names(result$ae$lResults), c(
    "strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed",
    "dfAnalyzed", "dfFlagged", "dfSummary", "chart", "lChecks"
  ))
  expect_equal(names(result$pd$lResults), c(
    "strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed",
    "dfAnalyzed", "dfFlagged", "dfSummary", "chart", "lChecks"
  ))
})


test_that("custom lMapping runs as intended", {

  lMapping$dfAE$strIDCol <- "SUBJID"

  result <- Study_Assess(lData = lData, lMapping = lMapping, bQuiet=TRUE)
  expect_false(result$ae$bStatus)
  expect_false(result$sae$bStatus)
  expect_false("lResults" %in% names(result$ae))
  expect_false("lResults" %in% names(result$sae))

  lMapping$dfAE$strIDCol <- "SUBJID"
  lData$dfAE <- lData$dfAE %>%
    rename(SUBJID = SubjectID)

  result <- Study_Assess(lData = lData, lMapping = lMapping, bQuiet=TRUE)
  expect_true(result$ae$bStatus)
  expect_true(result$sae$bStatus)
  expect_true("lResults" %in% names(result$ae))
  expect_true("lResults" %in% names(result$sae))
})

test_that("custom lAssessments runs as intended", {
  custom_assessments <- MakeAssessmentList()
  # remove FilterDomain from workflow
  custom_assessments$ae$workflow[[1]] <- NULL

  result <- Study_Assess(lAssessments = custom_assessments, lData = lData, bQuiet=TRUE)
  expect_equal(length(result$ae$workflow), 2)
  expect_true(result$ae$bStatus)

  custom_assessments <- MakeAssessmentList()
  custom_assessments$ie$workflow <- NULL
  result <- Study_Assess(lAssessments = custom_assessments, lData = lData, bQuiet=TRUE)
  expect_equal(length(result$ie), 6)
})

test_that("bQuiet works as intended", {
  expect_snapshot(result <- Study_Assess(lData = lData, bQuiet = TRUE))
  expect_snapshot(result <- Study_Assess(lData = lData, bQuiet = FALSE))
})

test_that("lTags are carried through", {
  result <- Study_Assess(
    lData = lData,
    lTags = list(
      Study = "test study",
      Q = "Q2 2022",
      Region = "Northwest"
    ),
    bQuiet=TRUE
  )

  expect_equal(
    result$ae$lResults$lTags,
    list(
      Study = "test study", Q = "Q2 2022", Region = "Northwest",
      Assessment = "Safety", Label = "AEs"
    )
  )

  expect_equal(
    result$consent$lResults$lTags,
    list(
      Study = "test study", Q = "Q2 2022", Region = "Northwest",
      Assessment = "Consent", Label = "Consent"
    )
  )

  expect_equal(
    result$ie$lResults$lTags,
    list(
      Study = "test study", Q = "Q2 2022", Region = "Northwest",
      Assessment = "IE", Label = "IE"
    )
  )

  expect_equal(
    result$importantpd$lResults$lTags,
    list(
      Study = "test study", Q = "Q2 2022", Region = "Northwest",
      Assessment = "PD", Label = "Important PD"
    )
  )

  expect_equal(
    result$pd$lResults$lTags,
    list(
      Study = "test study", Q = "Q2 2022", Region = "Northwest",
      Assessment = "PD", Label = "PD"
    )
  )

  expect_equal(
    result$sae$lResults$lTags,
    list(
      Study = "test study", Q = "Q2 2022", Region = "Northwest",
      Assessment = "Safety", Label = "AEs Serious"
    )
  )
})

test_that("incorrect lTags throw errors", {
  expect_snapshot_error(Study_Assess(lTags = "hi mom", bQuiet=TRUE))
  expect_snapshot_error(Study_Assess(lTags = list("hi", "mom"), bQuiet=TRUE))
  expect_snapshot_error(Study_Assess(lTags = list(greeting = "hi", "mom"), bQuiet=TRUE))
  expect_snapshot_error(Study_Assess(lTags = list(Assessment = "this is not an assessment"), bQuiet=TRUE))
  expect_snapshot_error(Study_Assess(lTags = list(Label = "this is not a label"), bQuiet=TRUE))
})

test_that("Map + Assess yields same result as Study_Assess()", {
  study_assess <- Study_Assess(lData = lData, bQuiet=TRUE)
  ae_assess <- AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ)) %>% AE_Assess()
  consent_assess <- Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ)) %>% Consent_Assess()
  ie_assess <- IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ)) %>% IE_Assess()
  pd_assess <- PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ)) %>% PD_Assess()

  # expect_equal(study_assess$ae$lResults$dfSummary[1:4], ae_assess$dfSummary[1:4])
  expect_equal(study_assess$consent$lResults$dfSummary[1:4], consent_assess$dfSummary[1:4])
  expect_equal(study_assess$ie$lResults$dfSummary[1:4], ie_assess$dfSummary[1:4])
  expect_equal(study_assess$pd$lResults$dfSummary[1:4], pd_assess$dfSummary[1:4])
})

test_that("lSubjFilters with 0 rows returns NULL", {
  lMappingCustom <- lMapping

  lMappingCustom$dfSUBJ$strSiteVal <- "XYZ"
  lMappingCustom$dfSUBJ$strRandFlagVal <- "N"


  tmp <- Study_Assess(
    lData = lData,
    lMapping = lMappingCustom,
    lSubjFilters = list(
      strSiteCol = "strSiteVal",
      strSiteCol = "strSiteVal2",
      strSiteCol = "strSiteVal3"
    ),
    bQuiet=TRUE
  )

  expect_null(tmp)
})

test_that("correct bStatus is returned when workflow is missing", {
  custom_assessments <- MakeAssessmentList()
  custom_assessments$ie$workflow <- NULL
  result <- Study_Assess(
    lData = lData,
    lAssessments = custom_assessments,
    bQuiet=TRUE
  )

  expect_false(result$ie$bStatus)
})
