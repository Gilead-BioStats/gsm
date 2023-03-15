source(testthat::test_path("testdata/data.R"))

subsetByIndex <- function(data, domain, max_rows = 50) {
  data %>%
    select(all_of(colnames(domain))) %>%
    slice(1:max_rows)
}

meta_lookup <- tribble(
  ~workflowid, ~assessment_abbrev,
  "kri0001", "AE",
  "kri0002", "AE",
  "kri0003", "PD",
  "kri0004", "PD",
  "kri0005", "LB",
  "kri0006", "LB",
  "kri0007", "Disp",
  "kri0008", "Disp"
)

meta <- left_join(
  meta_workflow,
  meta_lookup,
  by = "workflowid"
)

dfSUBJ <- clindata::rawplus_dm %>% subsetByIndex(dfSUBJ)
dfAE <- clindata::rawplus_ae %>% subsetByIndex(dfAE)
dfPD <- clindata::rawplus_protdev %>% subsetByIndex(dfPD)
dfCONSENT <- clindata::rawplus_consent %>% subsetByIndex(dfCONSENT)
dfIE <- clindata::rawplus_ie %>% subsetByIndex(dfIE)
dfSTUDCOMP <- clindata::rawplus_studcomp %>% subsetByIndex(dfSTUDCOMP)
dfSDRGCOMP <- clindata::rawplus_sdrgcomp %>% subsetByIndex(dfSDRGCOMP)

set.seed(8675309)
subset <- dfSUBJ %>%
    slice_sample(n = 5)
dfLB <- clindata::rawplus_lb %>% filter(subjid %in% subset$subjid)
dfDATACHG <- clindata::edc_data_points %>% filter(subjectname %in% subset$subject_nsv)
dfDATAENT <- clindata::edc_data_pages %>% filter(subjectname %in% subset$subject_nsv)
dfQUERY <- clindata::edc_queries %>% filter(subjectname %in% subset$subject_nsv)

lData <- list(
  dfSUBJ = dfSUBJ,
  dfAE = dfAE,
  dfPD = dfPD,
  dfCONSENT = dfCONSENT,
  dfIE = dfIE,
  dfSTUDCOMP = dfSTUDCOMP,
  dfSDRGCOMP = dfSDRGCOMP,
  dfLB = dfLB,
  dfDATACHG = dfDATACHG,
  dfDATAENT = dfDATAENT,
  dfQUERY = dfQUERY,
  dfENROLL = dfENROLL
)

lAssessments <- MakeWorkflowList()

lMapping <- c(
  yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_adam.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))
)

result <- Study_Assess(
  lData = lData,
  lAssessments = lAssessments,
  bQuiet = TRUE
)

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  expect_equal(length(lAssessments), length(result))
  expect_equal(names(lAssessments), names(result))
  expect_true(all(map_chr(result, ~ class(.)) == "list"))
  expect_true(all(map_lgl(result, ~ .x$bStatus)))
  expect_snapshot(names(result$kri0001))
  expect_snapshot(names(result$kri0002))
  expect_snapshot(names(result$kri0003))
  expect_snapshot(names(result$kri0004))
  expect_snapshot(names(result$kri0005))
  expect_snapshot(names(result$kri0006))
  expect_snapshot(names(result$kri0007))
})

# metadata is returned as expected ----------------------------------------
test_that("metadata is returned as expected", {
  kri0001 <- result$kri0001

  # snapshot important/nested assessment data
  expect_snapshot(kri0001$steps)
  expect_snapshot(kri0001$lData)
  expect_snapshot(kri0001$lChecks)
  expect_snapshot(kri0001$checks$FilterDomain$dfAE)
  expect_snapshot(kri0001$checks$AE_Map_Raw$dfAE)
  expect_snapshot(kri0001$checks$AE_Map_Raw$dfSUBJ)
  expect_snapshot(kri0001$checks$AE_Assess$dfInput)
  expect_snapshot(kri0001$checks$AE_Assess$mapping$dfInput)
})



# custom tests ------------------------------------------------------------



# Study_Assess() runs with missing datasets -------------------------------

test_that("Study_Assess() runs with missing datasets", {
  # run Study_Assess with AE only
  lData <- list(
    dfSUBJ = dfSUBJ,
    dfAE = dfAE
  )

  # run assessment with missing data for everything but AE
  result <- Study_Assess(
    lData = lData,
    lAssessments = lAssessments,
    bQuiet = TRUE
  ) %>% suppressWarnings()

  # extract bStatus from returned list
  bStatusData <- purrr::map_df(result, ~ .x$bStatus) %>%
    tidyr::pivot_longer(everything()) %>%
    split(.$value)

  # filter metadata for workflowids that should return TRUE
  returnTrue <- meta %>%
    filter(assessment_abbrev == "AE") %>%
    pull(workflowid)

  # filter metadata for workflowids that should return FALSE
  returnFalse <- meta %>%
    filter(assessment_abbrev != "AE") %>%
    pull(workflowid)

  # test expectations
  expect_true(all(returnTrue %in% bStatusData$`TRUE`$name))
  expect_true(all(returnFalse %in% bStatusData$`FALSE`$name))
})


test_that("custom lMapping runs as intended", {
  lData <- list(
    dfSUBJ = dfSUBJ,
    dfAE = dfAE
  )

  lMapping$dfAE$strIDCol <- "SUBJID"

  result <- Study_Assess(lData = lData, lMapping = lMapping, bQuiet = TRUE)
  expect_false(result$kri0001$bStatus)
  expect_false(result$kri0001$bStatus)
  expect_false("lResults" %in% names(result$kri0001))
  expect_false("lResults" %in% names(result$kri0002))


  lMapping$dfAE$strIDCol <- "SUBJID"
  lData$dfAE <- lData$dfAE %>%
    rename(SUBJID = subjid)

  result <- Study_Assess(lData = lData, lMapping = lMapping, bQuiet = TRUE) %>%
    suppressWarnings()
  expect_true(result$kri0001$bStatus)
  expect_true(result$kri0002$bStatus)
  expect_true("lResults" %in% names(result$kri0001))
  expect_true("lResults" %in% names(result$kri0002))
})

test_that("bQuiet works as intended", {
  # run on subset to reduce runtime
  lData <- list(
    dfSUBJ = clindata::rawplus_dm %>% arrange(subjid) %>% slice(1:10),
    dfAE = clindata::rawplus_ae %>% arrange(subjid) %>% slice(1:10)
  )

  workflow <- MakeWorkflowList(strNames = "kri0001")

  expect_snapshot(result <- Study_Assess(lData = lData, lAssessments = workflow, bQuiet = FALSE))
})


test_that("Map + Assess yields same result as Study_Assess()", {
  lData <- list(
    dfSUBJ = dfSUBJ,
    dfCONSENT = dfCONSENT,
    dfIE = dfIE
  )


  custom_workflow <- MakeWorkflowList(strNames = c("ie", "consent"), bRecursive = TRUE)

  study_assess <- Study_Assess(lData = lData, bQuiet = TRUE, lAssessments = custom_workflow)
  consent_assess <- Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ)) %>% Consent_Assess()
  ie_assess <- IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ)) %>% IE_Assess()


  # expect_equal(study_assess$ae$lResults$dfSummary[1:4], ae_assess$dfSummary[1:4])
  expect_equal(study_assess$consent$lResults$dfSummary[1:4], consent_assess$dfSummary[1:4])
  expect_equal(study_assess$ie$lResults$dfSummary[1:4], ie_assess$dfSummary[1:4])
})



test_that("correct bStatus is returned when workflow is missing", {
  custom_assessments <- MakeWorkflowList()


  # remove workflows 2 - end. This only includes a workflow for kri0001
  custom_assessments[2:length(custom_assessments)] <- NULL

  result <- Study_Assess(
    lData = lData,
    lAssessments = custom_assessments,
    bQuiet = TRUE
  )

  # pull out all workflow names that should not have run
  omittedNames <- names(MakeWorkflowList()[2:length(MakeWorkflowList())])

  # test that workflow names are not found in the result of Study_Assess()
  expect_false(all(omittedNames %in% names(result)))
})


test_that("non-enrolled subjects are filtered out using a default workflow", {
  dfSUBJ <- lData$dfSUBJ %>%
    mutate(enrollyn = rep(c("Y", "N"), times = 25))

  lData <- list(
    dfSUBJ = dfSUBJ,
    dfAE = dfAE
  )

  result <- Study_Assess(
    lData = lData,
    lAssessments = MakeWorkflowList(strNames = 'kri0001')
  )

  expect_equal(25, nrow(result$kri0001$lData$dfSUBJ))
  expect_true(all(result$kri0001$lData$dfSUBJ$enrollyn == "Y"))

})
