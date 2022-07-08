lAssessments <- MakeAssessmentList()
lAssessments$aeGrade <- NULL # Drop stratified assessment

results <- Study_Assess(lAssessments= lAssessments, bQuiet = TRUE) %>%
  purrr::map(~ .x$lResults) %>%
  purrr::compact() %>%
  purrr::map_df(~ .x$dfSummary) %>%
  suppressMessages()

test_that("Study Table Runs as expected", {
  tbl <- Study_Table(results)
  expect_true(is.data.frame(tbl$df_summary))
  expect_true(is.character(tbl$footnote))
  expect_equal(
    names(tbl$df_summary),
    c(
      "Title", "X055X", "X086X", "X050X", "X140X", "X180X", "X054X",
      "X154X", "X009X", "X164X", "X102X", "X090X", "X126X", "X192X",
      "X013X", "X168X", "X236X", "X068X", "X033X", "X081X", "X129X",
      "X018X", "X235X", "X037X", "X159X", "X173X", "X204X", "X038X",
      "X100X", "X094X", "X097X", "X143X", "X166X", "X174X", "X183X",
      "X185X", "X224X", "X110X", "X117X", "X179X", "X120X", "X132X",
      "X145X"
    )
  )

  expect_equal(
    tbl$df_summary$Title,
    c(
      "Number of Subjects", "Score", "Safety", "--AEs", "--AEs Serious",
      "Consent", "--Consent", "IE", "--IE", "PD", "--Important PD",
      "--PD"
    )
  )
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
  expect_equal(tbl$df_summary$X055X, c("43", "2", "*", "+", " ", "*", "+", "", " ", "", " ", " "))
})

test_that("bShowCounts works", {
  tbl <- Study_Table(dfFindings = results, bShowCounts = FALSE)
  tblCounts <- Study_Table(dfFindings = results, bShowCounts = TRUE)

  expect_equal(tbl$df_summary$Title, c(
    "Score", "Safety", "--AEs", "--AEs Serious", "Consent", "--Consent",
    "IE", "--IE", "PD", "--Important PD", "--PD"
  ))
  expect_equal(tblCounts$df_summary$Title, c(
    "Number of Subjects", "Score", "Safety", "--AEs", "--AEs Serious",
    "Consent", "--Consent", "IE", "--IE", "PD", "--Important PD",
    "--PD"
  ))
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
  tbl <- Study_Table(dfFindings = results, vSiteScoreThreshold = 2)
  expect_equal(names(tbl$df_summary), c(
    "Title", "X055X", "X086X", "X050X", "X140X", "X180X", "X054X",
    "X154X", "X009X", "X164X"
  ))

  tbl_transpose <- as.data.frame(t(tbl$df_summary))
  names(tbl_transpose) <- tbl_transpose[1, ]
  tbl_transpose <- tbl_transpose[-1, ]
  expect_lte(max(as.numeric(tbl_transpose$Score)), 2)
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
