test_that("BindResults binds dfs in lResults", {
  lResults <- list(
    resultA = list(
      tbl1 = tibble::tibble(
        a = 1:3,
        b = letters[1:3]
      ),
      tbl2 = tibble::tibble()
    ),
    resultB = list(
      tbl1 = tibble::tibble(
        a = 4:6,
        b = letters[4:6]
      ),
      tbl3 = tibble::tibble()
    )
  )
  expect_identical(
    BindResults(
      lResults = lResults,
      strName = "tbl1",
      strStudyID = "ThisStudy"
    ),
    tibble::tibble(
      a = 1:6,
      b = letters[1:6],
      MetricID = c(rep("resultA", 3), rep("resultB", 3)),
      SnapshotDate = Sys.Date(),
      StudyID = "ThisStudy"
    )
  )
})

test_that("BindResults binds dfs in lResults$lData", {
  lResults <- list(
    resultA = list(
      lData = list(
        tbl1 = tibble::tibble(
          a = 1:3,
          b = letters[1:3]
        ),
        tbl2 = tibble::tibble()
      )
    ),
    resultB = list(
      lData = list(
        tbl1 = tibble::tibble(
          a = 4:6,
          b = letters[4:6]
        ),
        tbl3 = tibble::tibble()
      )
    )
  )
  expect_identical(
    BindResults(
      lResults = lResults,
      strName = "tbl1",
      strStudyID = "ThisStudy",
      bUselData = TRUE
    ),
    tibble::tibble(
      a = 1:6,
      b = letters[1:6],
      MetricID = c(rep("resultA", 3), rep("resultB", 3)),
      SnapshotDate = Sys.Date(),
      StudyID = "ThisStudy"
    )
  )
})
