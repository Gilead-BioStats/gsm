test_that("MakeLongMeta fails for missing columns strGroupCols", {
  given <- data.frame(
    GroupID = c(1, 2),
    Param1 = c(10, 20),
    Param2 = c(100, 200)
  )
  expect_error(
    MakeLongMeta(given, "Site", strGroupCols = "other"),
    "strGroupCols not found in data"
  )
  expect_error(
    MakeLongMeta(given, "Site", strGroupCols = c("GroupID", "other")),
    "strGroupCols not found in data"
  )
})

test_that("MakeLongMeta makes dfMeta", {
  given <- data.frame(
    GroupID = c(1, 2),
    Param1 = c(10, 20),
    Param2 = c(100, 200)
  )
  expected <- tibble::tibble(
    GroupID = c("1", "1", "2", "2"),
    Param = c("Param1", "Param2", "Param1", "Param2"),
    Value = as.character(c(10, 100, 20, 200)),
    GroupLevel = "Site"
  )
  expect_identical(
    MakeLongMeta(given, "Site"),
    expected
  )
})
