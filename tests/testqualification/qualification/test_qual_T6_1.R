## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))
mapping_workflow <- flatten(MakeWorkflowList("mapping", yaml_path_original))
kri_workflows <- MakeWorkflowList(c("kri0001_custom", "cou0001_custom"), yaml_path_custom)
mapped_data <- robust_runworkflow(mapping_workflow, lData)$lData

## Test Code
testthat::test_that("Adverse Event Assessments can be done correctly using a grouping variable, such as Site or Country for KRIs, and Study for QTLs, when applicable.", {
  test <- map(kri_workflows, ~robust_runworkflow(.x, mapped_data, steps = 1:2))
  # kri
  group_level <- kri_workflows$kri0001_custom$steps[[1]]$params$strGroupCol
  groups <- unique(test$kri0001_custom$lData$dfEnrolled[[group_level]])

  expect_identical(sort(unique(test$kri0001_custom$lData$dfInput$GroupID)), sort(test$kri0001_custom$lData$dfTransformed$GroupID))
  expect_identical(unique(test$kri0001_custom$lData$dfTransformed$GroupLevel), group_level)
  expect_equal(nrow(test$kri0001_custom$lData$dfTransformed), length(groups))

  # cou
  group_level <- kri_workflows$cou0001_custom$steps[[1]]$params$strGroupCol
  groups <- unique(test$cou0001_custom$lData$dfEnrolled[[group_level]])

  expect_identical(sort(unique(test$cou0001_custom$lData$dfInput$GroupID)), sort(test$cou0001_custom$lData$dfTransformed$GroupID))
  expect_identical(unique(test$cou0001_custom$lData$dfTransformed$GroupLevel), group_level)
  expect_equal(nrow(test$cou0001_custom$lData$dfTransformed), length(groups))

  ## custom ================================================
  kri_workflows$kri0001_custom$steps[[1]]$params$strGroupCol <- "sex"
  kri_workflows$cou0001_custom$steps[[1]]$params$strGroupCol <- "sex"

  test_custom <- map(kri_workflows, ~robust_runworkflow(.x, mapped_data, steps = 1:2))

  group_level <- 'sex'
  groups_kri <- unique(test_custom$kri0001_custom$lData$dfEnrolled[[group_level]])
  groups_cou <- unique(test_custom$cou0001_custom$lData$dfEnrolled[[group_level]])

  expect_identical(sort(unique(test_custom$kri0001_custom$lData$dfInput$GroupID)), sort(test_custom$kri0001_custom$lData$dfTransformed$GroupID))
  expect_identical(unique(test_custom$kri0001_custom$lData$dfTransformed$GroupLevel), group_level)
  expect_equal(nrow(test_custom$kri0001_custom$lData$dfTransformed), length(groups_cou))
  expect_identical(sort(unique(test_custom$cou0001_custom$lData$dfInput$GroupID)), sort(test_custom$cou0001_custom$lData$dfTransformed$GroupID))
  expect_identical(unique(test_custom$cou0001_custom$lData$dfTransformed$GroupLevel), group_level)
  expect_equal(nrow(test_custom$cou0001_custom$lData$dfTransformed), length(groups_cou))

})
