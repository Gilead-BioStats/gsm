test_that("Visualize_Scatter handles empty datasets", {
  dfSummary <- data.frame(
    GroupID = character(),
    Denominator = numeric(),
    Numerator = numeric(),
    Flag = integer()
  )

  plot <- Visualize_Scatter(dfSummary)
  expect_null(plot)
})

test_that("Visualize_Scatter generates correct tooltip", {
  dfSummary <- data.frame(
    GroupID = "A",
    Denominator = 1000,
    Numerator = 10,
    Flag = 1
  )

  plot <- Visualize_Scatter(dfSummary)
  plot_data <- ggplot_build(plot)$data[[1]]

  expected_tooltip <- paste(
    "Group: GroupID: ",
    "GroupID: A",
    "Exposure (days): 1,000",
    "# of Events: 10",
    sep = "\n"
  )

  expect_equal(plot_data$text, expected_tooltip)
})

test_that("Visualize_Scatter plots points with correct colors", {
  dfSummary <- data.frame(
    GroupID = c("A", "B"),
    Denominator = c(1000, 2000),
    Numerator = c(10, 20),
    Flag = c(1, 2)
  )

  plot <- Visualize_Scatter(dfSummary)
  plot_data <- ggplot_build(plot)$data[[1]]

  expect_equal(plot_data$colour, c("#FADB14", "#FF4D4F"))
})

test_that("Visualize_Scatter handles dfBounds correctly", {
  dfSummary <- data.frame(
    GroupID = c("A", "B"),
    Denominator = c(1000, 1200),
    Numerator = c(10, 15),
    Flag = c(1, 2)
  )

  dfBounds <- data.frame(
    Threshold = c(1, 2),
    LogDenominator = log(c(1000, 1200)),
    Numerator = c(10, 15)
  )

  plot <- Visualize_Scatter(dfSummary, dfBounds)
  plot_data <- ggplot_build(plot)$data[[1]]

  expect_equal(plot_data$x, log(c(1000, 1200)))
  expect_equal(plot_data$y, c(10, 15))
  expect_equal(plot_data$colour, c("#FADB14", "#FF4D4F"))
})

test_that("Visualize_Scatter handles facets correctly", {
  dfSummary <- data.frame(
    GroupID = c("A", "B"),
    Denominator = c(1000, 2000),
    Numerator = c(10, 20),
    Flag = c(1, 2),
    GroupCol = c("X", "Y")
  )

  plot <- Visualize_Scatter(dfSummary, strGroupCol = "GroupCol")
  plot_data <- ggplot_build(plot)$data[[1]]

  expect_true("PANEL" %in% names(plot_data))
  expect_equal(unique(plot_data$PANEL) %>% as.numeric(), c(1, 2))
})
