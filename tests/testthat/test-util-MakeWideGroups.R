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

test_that("MakeWideGroups widens dfMeta", {
  reporting_subset <- reportingGroups %>%
    dplyr::filter(
      GroupID %in% c(10, 20),
      Param %in% c("Status", "Country")
    )
  expected <- tibble::tibble(
    GroupID = c("10", "20"),
    GroupLevel = "Site",
    Status = "Active",
    Country = c("China", "US")
  )
  expect_identical(
    MakeWideGroups(reporting_subset, "Site"),
    expected
  )
})
