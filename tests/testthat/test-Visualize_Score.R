test_that("Visualize_Score stops on incorrect input types", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, Flag = c(0, 1, 2))

  expect_error(Visualize_Score(dfSummary, strTitle = 123),
               "strTitle must be character")
  expect_error(Visualize_Score(dfSummary, bFlagFilter = "TRUE"),
               "bFlagFilter must be logical")
  expect_error(Visualize_Score(list(), strTitle = ""),
               "dfSummary must be a data.frame")
  expect_error(Visualize_Score(dfSummary, strType = "invalid"),
               "strType must be 'metric' or 'score'")
  expect_error(Visualize_Score(dfSummary, strType = c("metric", "score")),
               "strType must be length 1")
})

test_that("Visualize_Score handles 'metric' type correctly", {
  dfSummary <- data.frame(
    GroupID = c("A", "B", "C"),
    Metric = c(100, 200, 300),
    Flag = c(0, 1, 2),
    Numerator = c(10, 20, 30),
    Denominator = c(100, 100, 100)
  )

  p <- Visualize_Score(dfSummary, strType = "metric")
  plot_data <- ggplot_build(p)$data[[1]]

  expect_equal(plot_data$x %>% as.numeric(), c(3, 2, 1)) # reordered by Metric
  expect_equal(plot_data$y, dfSummary$Metric)
  expect_equal(plot_data$fill, c("#999999", "#FADB14", "#FF4D4F"))
})

test_that("Visualize_Score handles 'score' type correctly with thresholds", {
  dfSummary <- data.frame(
    GroupID = c("A", "B", "C"),
    Score = c(0.5, 0.8, 0.3),
    Flag = c(0, 1, 2)
  )

  vThreshold <- c(0.4, 0.7)

  p <- Visualize_Score(dfSummary, strType = "score", vThreshold = vThreshold)
  plot_data <- ggplot_build(p)$data[[1]]

  expect_equal(plot_data$x %>% as.numeric(), c(2, 1, 3)) # reordered by Score
  expect_equal(plot_data$y, dfSummary$Score)
  expect_equal(plot_data$fill, c("#999999", "#FADB14", "#FF4D4F"))

  # Check for the presence of horizontal lines at thresholds
  hline_yint <- c(ggplot_build(p)$data[[2]]$yintercept, ggplot_build(p)$data[[3]]$yintercept)
  expect_equal(hline_yint, vThreshold)
})

test_that("Visualize_Score handles flag filtering correctly", {
  dfSummary <- data.frame(
    GroupID = c("A", "B", "C"),
    Metric = c(100, 200, 300),
    Flag = c(0, 1, 2)
  )

  p <- Visualize_Score(dfSummary, strType = "metric", bFlagFilter = TRUE)
  plot_data <- ggplot_build(p)$data[[1]]

  expect_equal(plot_data$x %>% as.numeric(), c(2, 1)) # only B and C should remain
  expect_equal(plot_data$y %>% as.numeric(), c(200, 300))
})

test_that("Visualize_Score sets plot title correctly", {
  dfSummary <- data.frame(
    GroupID = c("A", "B", "C"),
    Metric = c(100, 200, 300),
    Flag = c(0, 1, 2)
  )

  strTitle <- "Test Title"

  p <- Visualize_Score(dfSummary, strType = "metric", strTitle = strTitle)
  plot_title <- ggplot_build(p)$plot$labels$title

  expect_equal(plot_title, strTitle)
})
