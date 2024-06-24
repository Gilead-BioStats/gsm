skip()
test_that("Widget_TimeSeries processes dfSummary correctly", {
  dfSummary <- data.frame(
    studyid = 1:3,
    siteid = c("A", "B", "C"),
    numerator_value = 4:6,
    denominator_value = 7:9,
    metric_value = 10:12,
    score = 13:15,
    flag_value = 16:18,
    gsm_analysis_date = as.Date('2020-01-01') + 1:3,
    snapshot_date = as.Date('2020-01-01') + 4:6,
    stringsAsFactors = FALSE
  )

  lLabels <- data.frame(
    workflowid = 1,
    group = "TestGroup",
    abbreviation = "TG",
    metric = "metric",
    numerator = "num",
    denominator = "den",
    outcome = "outcome",
    model = "model",
    score = "score",
    data_inputs = "data",
    data_filters = "filters",
    gsm_analysis_date = as.Date('2020-01-01'),
    stringsAsFactors = FALSE
  )

  widget <- suppressWarnings(Widget_TimeSeries(dfSummary, lLabels, yAxis = "metric"))

  dfSummary_expected <- dfSummary %>%
    select(
      studyid,
      groupid = siteid,
      numerator = numerator_value,
      denominator = denominator_value,
      metric = metric_value,
      score,
      flag = flag_value,
      gsm_analysis_date,
      snapshot_date
    ) %>%
    jsonlite::toJSON(na = "string")

  expect_equal(widget$x$dfSummary, dfSummary_expected)
})

test_that("Widget_TimeSeries processes dfParams correctly for score yAxis", {
  dfSummary <- data.frame(
    studyid = 1:3,
    siteid = c("A", "B", "C"),
    numerator_value = 4:6,
    denominator_value = 7:9,
    metric_value = 10:12,
    score = 13:15,
    flag_value = 16:18,
    gsm_analysis_date = as.Date('2020-01-01') + 1:3,
    snapshot_date = as.Date('2020-01-01') + 4:6,
    stringsAsFactors = FALSE
  )

  lLabels <- data.frame(
    workflowid = 1,
    group = "TestGroup",
    abbreviation = "TG",
    metric = "metric",
    numerator = "num",
    denominator = "den",
    outcome = "outcome",
    model = "model",
    score = "score",
    data_inputs = "data",
    data_filters = "filters",
    gsm_analysis_date = as.Date('2020-01-01'),
    stringsAsFactors = FALSE
  )

  dfParams <- data.frame(
    workflowid = 1,
    param = "param1",
    index = 1:3,
    gsm_analysis_date = as.Date('2020-01-01') + 1:3,
    snapshot_date = as.Date('2020-01-01') + 4:6,
    studyid = 1:3,
    default_s = 4:6,
    stringsAsFactors = FALSE
  )

  widget <- Widget_TimeSeries(dfSummary, lLabels, dfParams = dfParams, yAxis = "score") %>%
    suppressWarnings()

  dfParams_expected <- dfParams %>%
    select(
      workflowid,
      param,
      index,
      gsm_analysis_date,
      snapshot_date,
      studyid,
      value = default_s
    ) %>%
    jsonlite::toJSON(na = "string")

  expect_equal(widget$x$dfParams, dfParams_expected)
})

test_that("Widget_TimeSeries handles dfSite correctly", {
  dfSummary <- data.frame(
    studyid = 1:3,
    siteid = c("A", "B", "C"),
    numerator_value = 4:6,
    denominator_value = 7:9,
    metric_value = 10:12,
    score = 13:15,
    flag_value = 16:18,
    gsm_analysis_date = as.Date('2020-01-01') + 1:3,
    snapshot_date = as.Date('2020-01-01') + 4:6,
    stringsAsFactors = FALSE
  )

  lLabels <- data.frame(
    workflowid = 1,
    group = "TestGroup",
    abbreviation = "TG",
    metric = "metric",
    numerator = "num",
    denominator = "den",
    outcome = "outcome",
    model = "model",
    score = "score",
    data_inputs = "data",
    data_filters = "filters",
    gsm_analysis_date = as.Date('2020-01-01'),
    stringsAsFactors = FALSE
  )

  dfParams <- data.frame(
    workflowid = 1,
    param = "param1",
    index = 1:3,
    gsm_analysis_date = as.Date('2020-01-01') + 1:3,
    snapshot_date = as.Date('2020-01-01') + 4:6,
    studyid = 1:3,
    default_s = 4:6,
    stringsAsFactors = FALSE
  )

  dfSite <- data.frame(
    SiteID = c(1, 2, 3),
    stringsAsFactors = FALSE
  )

  widget <- Widget_TimeSeries(dfSummary, lLabels, dfSite = dfSite, dfParams = dfParams) %>%
    suppressWarnings()

  dfSite_expected <- jsonlite::toJSON(dfSite, na = "string")
  expect_equal(widget$x$dfSite, dfSite_expected)
})

test_that("Widget_TimeSeries sets siteSelectLabelValue correctly", {
  dfSummary <- data.frame(
    studyid = 1:3,
    siteid = c("A", "B", "C"),
    numerator_value = 4:6,
    denominator_value = 7:9,
    metric_value = 10:12,
    score = 13:15,
    flag_value = 16:18,
    gsm_analysis_date = as.Date('2020-01-01') + 1:3,
    snapshot_date = as.Date('2020-01-01') + 4:6,
    stringsAsFactors = FALSE
  )

  lLabels <- data.frame(
    workflowid = 1,
    group = "TestGroup",
    abbreviation = "TG",
    metric = "metric",
    numerator = "num",
    denominator = "den",
    outcome = "outcome",
    model = "model",
    score = "score",
    data_inputs = "data",
    data_filters = "filters",
    gsm_analysis_date = as.Date('2020-01-01'),
    stringsAsFactors = FALSE
  )

  dfParams <- data.frame(
    workflowid = 1,
    param = "param1",
    index = 1:3,
    gsm_analysis_date = as.Date('2020-01-01') + 1:3,
    snapshot_date = as.Date('2020-01-01') + 4:6,
    studyid = 1:3,
    default_s = 4:6,
    stringsAsFactors = FALSE
  )

  widget <- Widget_TimeSeries(dfSummary, lLabels, dfParams = dfParams, siteSelectLabelValue = "CustomSite") %>%
    suppressWarnings()

  expect_equal(widget$x$siteSelectLabelValue, "Highlighted CustomSite: ")
})

test_that("Widget_TimeSeries processes addSiteSelect correctly", {
  dfSummary <- data.frame(
    studyid = 1:3,
    siteid = c("A", "B", "C"),
    numerator_value = 4:6,
    denominator_value = 7:9,
    metric_value = 10:12,
    score = 13:15,
    flag_value = 16:18,
    gsm_analysis_date = as.Date('2020-01-01') + 1:3,
    snapshot_date = as.Date('2020-01-01') + 4:6,
    stringsAsFactors = FALSE
  )

  lLabels <- data.frame(
    workflowid = 1,
    group = "TestGroup",
    abbreviation = "TG",
    metric = "metric",
    numerator = "num",
    denominator = "den",
    outcome = "outcome",
    model = "model",
    score = "score",
    data_inputs = "data",
    data_filters = "filters",
    gsm_analysis_date = as.Date('2020-01-01'),
    stringsAsFactors = FALSE
  )

  dfParams <- data.frame(
    workflowid = 1,
    param = "param1",
    index = 1:3,
    gsm_analysis_date = as.Date('2020-01-01') + 1:3,
    snapshot_date = as.Date('2020-01-01') + 4:6,
    studyid = 1:3,
    default_s = 4:6,
    stringsAsFactors = FALSE
  )

  widget <- Widget_TimeSeries(dfSummary, lLabels, dfParams = dfParams, addSiteSelect = FALSE) %>%
    suppressWarnings()
  expect_equal(widget$x$addSiteSelect, FALSE)
})

test_that("Widget_TimeSeries processes selectedGroupIDs correctly", {
  dfSummary <- data.frame(
    studyid = 1:3,
    siteid = c("A", "B", "C"),
    numerator_value = 4:6,
    denominator_value = 7:9,
    metric_value = 10:12,
    score = 13:15,
    flag_value = 16:18,
    gsm_analysis_date = as.Date('2020-01-01') + 1:3,
    snapshot_date = as.Date('2020-01-01') + 4:6,
    stringsAsFactors = FALSE
  )

  lLabels <- data.frame(
    workflowid = 1,
    group = "TestGroup",
    abbreviation = "TG",
    metric = "metric",
    numerator = "num",
    denominator = "den",
    outcome = "outcome",
    model = "model",
    score = "score",
    data_inputs = "data",
    data_filters = "filters",
    gsm_analysis_date = as.Date('2020-01-01'),
    stringsAsFactors = FALSE
  )

  dfParams <- data.frame(
    workflowid = 1,
    param = "param1",
    index = 1:3,
    gsm_analysis_date = as.Date('2020-01-01') + 1:3,
    snapshot_date = as.Date('2020-01-01') + 4:6,
    studyid = 1:3,
    default_s = 4:6,
    stringsAsFactors = FALSE
  )

  selectedGroupIDs <- c("A", "C")

  widget <- Widget_TimeSeries(dfSummary, lLabels, dfParams = dfParams, selectedGroupIDs = selectedGroupIDs) %>%
    suppressWarnings()
  expect_equal(widget$x$selectedGroupIDs, as.character(selectedGroupIDs))
})
