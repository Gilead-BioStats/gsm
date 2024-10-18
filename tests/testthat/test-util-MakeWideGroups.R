test_that("MakeWideGroups fails for missing columns", {
  expect_error(
    MakeWideGroups(dplyr::select(reportingGroups, -"GroupID"), "Site"),
    "One or more of these columns"
  )
  expect_error(
    MakeWideGroups(dplyr::select(reportingGroups, -"GroupLevel"), "Site"),
    "One or more of these columns"
  )
  expect_error(
    MakeWideGroups(dplyr::select(reportingGroups, -"Param"), "Site"),
    "One or more of these columns"
  )
  expect_error(
    MakeWideGroups(dplyr::select(reportingGroups, -"Value"), "Site"),
    "One or more of these columns"
  )
})

test_that("MakeWideGroups widens dfGroups", {
  reporting_subset <- reportingGroups %>%
    dplyr::filter(
      GroupID %in% c("0X004", "0X005"),
      Param %in% c("site_status", "Country")
    )
  expected <- tibble::tibble(
    GroupID = c("0X005", "0X004"),
    GroupLevel = "Site",
    site_status = "Active",
    Country = c("US", "China")
  )
  expect_identical(
    MakeWideGroups(reporting_subset, "Site"),
    expected
  )
})
