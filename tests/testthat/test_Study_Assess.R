source(testthat::test_path("testdata/data.R"))

subsetDfs <- function(data, domain, max_rows = 50) {
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



dfSUBJ <- clindata::rawplus_dm %>% subsetDfs(dfSUBJ)
dfAE <- clindata::rawplus_ae %>% subsetDfs(dfAE)
dfPD <- clindata::rawplus_protdev %>% subsetDfs(dfPD)
dfCONSENT <- clindata::rawplus_consent %>% subsetDfs(dfCONSENT)
dfIE <- clindata::rawplus_ie %>% subsetDfs(dfIE)
dfSTUDCOMP <- clindata::rawplus_studcomp %>% subsetDfs(dfSTUDCOMP)
dfSDRGCOMP <- clindata::rawplus_sdrgcomp %>% subsetDfs(dfSDRGCOMP)
dfLB <- clindata::rawplus_lb %>% subsetDfs(dfLB, max_rows = 300)
dfDATACHG <- clindata::edc_data_change_rate %>% subsetDfs(dfDATACHG, max_rows = 300)
dfDATAENT <- clindata::edc_data_entry_lag %>% subsetDfs(dfDATAENT, max_rows = 300)
dfQUERY <- clindata::edc_queries %>% subsetDfs(dfQUERY, max_rows = 300)


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

test_that("lSubjFilters with 0 rows returns NULL", {
  lData <- list(
    dfSUBJ = dfSUBJ,
    dfCONSENT = dfCONSENT,
    dfIE = dfIE
  )

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
    bQuiet = TRUE
  )

  expect_null(tmp)
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

test_that("flowchart is returned when bFlowchart is TRUE", {
  # run Study_Assess with AE only
  lData <- list(
    dfSUBJ = dfSUBJ,
    dfAE = dfAE
  )

  lWorkflow <- MakeWorkflowList(strNames = "kri0001")

  result <- Study_Assess(lData = lData, lAssessments = lWorkflow, bFlowchart = TRUE)

  expect_type(result$kri0001$lChecks$flowchart, "list")
  expect_snapshot(result$kri0001$lChecks$flowchart)

})


test_that("lSubjFilter correctly filters subjects from dm dataset", {
  # run Study_Assess with AE only
  lData <- list(
    dfSUBJ = dfSUBJ,
    dfAE = dfAE
  )

  lWorkflow <- MakeWorkflowList(strNames = "kri0001")

  # filter for US only
  lMappingFilter <- lMapping
  lMappingFilter$dfSUBJ[['strCountryVal']] <- "US"
  result <- Study_Assess(
    lData = lData,
    lAssessments = lWorkflow,
    lMapping = lMappingFilter,
    lSubjFilters = list("strCountryCol" = "strCountryVal")
    )

  # these should only be group ids where country == "US"
  us_group_ids <- result$kri0001$lResults$lData$dfSummary$GroupID

  # filter where country != "US" should not be found in the result above
  not_us_group_ids <- dfSUBJ %>%
    filter(country != "US") %>%
    pull(siteid) %>%
    unique()

  expect_true(!all(us_group_ids %in% not_us_group_ids))
})

test_that("lSubjFilter identifies dm dataset with 0 rows", {
  # run Study_Assess with AE only
  lData <- list(
    dfSUBJ = dfSUBJ,
    dfAE = dfAE
  )

  lWorkflow <- MakeWorkflowList(strNames = "kri0001")

  lMappingFilter <- lMapping
  lMappingFilter$dfSUBJ[['strStudyVal']] <- 'XYZ'

  # filter for US only
  # expected snapshot:
  # ── Checking Input Data for `FilterDomain()` ──
  #
  # ✔ No issues found for dfSUBJ domain
  # Filtering on `studyid %in% c("XYZ")`.
  # ✔ Filtered on `studyid %in% c("XYZ")` to drop 50 rows from 50 to 0 rows.
  # ! WARNING: Filtered data has 0 rows.
  # ✖ Subject-level data contains 0 rows. Assessment not run.
  # NULL
  expect_snapshot(
    Study_Assess(
      lData = lData,
      lAssessments = lWorkflow,
      lMapping = lMappingFilter,
      lSubjFilters = list("strStudyCol" = "strStudyVal"),
      bQuiet = FALSE
      )
    )
})


test_that("a stratified workflow can be run using Study_Assess", {

  lData <- list(
    dfSUBJ = dfSUBJ,
    dfAE = dfAE
  )

  lMapping <- yaml::read_yaml(
    system.file("mappings", "mapping_rawplus.yaml", package = "gsm")
  )

  lWorkflowList <- MakeWorkflowList(strNames = "aeGrade", bRecursive = TRUE)

  # Adverse events by grade
  StratifiedAE <- MakeStratifiedAssessment(
    lData = list(
      dfSUBJ = clindata::rawplus_dm,
      dfAE = clindata::rawplus_ae
    ),
    lMapping = lMapping,
    lWorkflow = lWorkflowList$aeGrade
  )

  result <- Study_Assess(lData = lData, lMapping = lMapping, lAssessments = StratifiedAE)

  expect_equal(names(result), c("aeGrade_1", "aeGrade_2", "aeGrade_3", "aeGrade_4"))
  expect_true(all(result %>% map_lgl(~.x$bStatus)))
})
