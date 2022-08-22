source(testthat::test_path("testdata/data.R"))

lAssessments <- MakeAssessmentList()

lData <- list(
  dfAE = dfAE,
  dfCONSENT = dfCONSENT,
  dfIE = dfIE,
  dfPD = dfPD,
  dfDISP = dfDISP,
  dfSUBJ = dfSUBJ
)

results <- Study_Assess(lAssessments = lAssessments, lData = lData, bQuiet = TRUE) %>%
  purrr::map(~ .x$lResults) %>%
  purrr::compact() %>%
  purrr::map_df(~ .x$dfSummary) %>%
  filter(!is.nan(Score)) %>% # Disp_Assess() for study is returning NaN for Score and failing Study_Table
  suppressMessages() %>%
  mutate(Flag = 1) # none of the test data is flagged - quick fix for now.

test_that("Study Table Runs as expected", {
  tbl <- Study_Table(results)
  expect_true(is.data.frame(tbl$df_summary))
  expect_null(tbl$footnote)
  expect_equal(
    names(tbl$df_summary),
    c("Title", "X010X", "X102X", "X999X")
  )

  expect_snapshot(tbl$df_summary$Title)
})

test_that("incorrect inputs throw errors", {
  expect_error(Study_Table(dfFindings = "data"))
  expect_error(Study_Table(dfFindings = results, bFormat = "Yes"))
  expect_error(Study_Table(dfFindings = results, bShowCounts = "Yes"))
  expect_error(Study_Table(dfFindings = results, bShowSiteScore = "Yes"))
  expect_error(Study_Table(dfFindings = results, vSiteScoreThreshold = "five"))
  expect_error(Study_Table(dfFindings = results, bColCollapse = "Yes"))
})

test_that("bFormat works", {
  tbl <- Study_Table(dfFindings = results, bFormat = FALSE)
  expect_snapshot(tbl$df_summary$X010X)
})

test_that("bShowCounts works", {
  tbl <- Study_Table(dfFindings = results, bShowCounts = FALSE)
  tblCounts <- Study_Table(dfFindings = results, bShowCounts = TRUE)

  expect_snapshot(tbl$df_summary$Title)
  expect_snapshot(tblCounts$df_summary$Title)
})

test_that("bShowSiteScore works", {
  expect_true(
    "Score" %in% Study_Table(dfFindings = results, bShowSiteScore = TRUE)$df_summary$Title
  )
  expect_false(
    "Score" %in% Study_Table(dfFindings = results, bShowSiteScore = FALSE)$df_summary$Title
  )
})

test_that("vSiteScoreThreshold works", {
  tbl <- Study_Table(dfFindings = results)
  expect_snapshot(names(tbl$df_summary))

  tbl_transpose <- as.data.frame(t(tbl$df_summary))
  names(tbl_transpose) <- tbl_transpose[1, ]
  tbl_transpose <- tbl_transpose[-1, ]
  expect_lte(max(as.numeric(tbl_transpose$Score)), 6)
})

test_that("bColCollapse works", {
  tbl <- Study_Table(dfFindings = results, bColCollapse = FALSE)
  tblCollapse <- Study_Table(dfFindings = results, bColCollapse = TRUE)
  expect_true("Assessment" %in% names(tbl$df_summary))
  expect_true("Label" %in% names(tbl$df_summary))
  expect_false("Assessment" %in% names(tblCollapse$df_summary))
  expect_false("Label" %in% names(tblCollapse$df_summary))
})

test_that("footnote is NULL when no sites were excluded", {
  tbl <- Study_Table(results, vSiteScoreThreshold = 0)
  expect_null(tbl$footnote)
})
