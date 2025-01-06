test_that("[ FilterByFlags ] returns group/metric combinations with a flag at any snapshot.", {
  dfResultsFlaggedActual <- FilterByFlags(reportingResults)

  strRiskSignals <- reportingResults %>%
    filter(
      .data$Flag != 0
    ) %>%
    mutate(
      riskSignalID = paste(.data$GroupID, .data$MetricID, sep = "_")
    ) %>%
    distinct(
      riskSignalID
    ) %>%
    pull(
      riskSignalID
    )

  dfResultsFlaggedExpected <- reportingResults %>%
    filter(
      paste(.data$GroupID, .data$MetricID, sep = "_") %in% strRiskSignals
    ) %>%
    as_tibble()

  expect_equal(
    dfResultsFlaggedActual,
    dfResultsFlaggedExpected
  )
})

test_that("[ FilterByFlags ] returns group/metric combinations with a flag at most recent snapshot.", {
  dfResultsFlaggedActual <- FilterByFlags(reportingResults, bCurrentlyFlagged = TRUE)

  strRiskSignals <- reportingResults %>%
    FilterByLatestSnapshotDate() %>%
    filter(
      .data$Flag != 0
    ) %>%
    mutate(
      riskSignalID = paste(.data$GroupID, .data$MetricID, sep = "_")
    ) %>%
    distinct(
      riskSignalID
    ) %>%
    pull(
      riskSignalID
    )

  dfResultsFlaggedExpected <- reportingResults %>%
    filter(
      paste(.data$GroupID, .data$MetricID, sep = "_") %in% strRiskSignals
    ) %>%
    as_tibble()

  expect_equal(
    dfResultsFlaggedActual,
    dfResultsFlaggedExpected
  )
})
