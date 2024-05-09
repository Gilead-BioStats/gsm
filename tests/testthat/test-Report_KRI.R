
# Define a mock environment to simulate the presence of the 'gsm' package and RMarkdown document
mock_env <- new.env()
mock_env$package <- "gsm"
mock_env$system.file <- function(...) {
  return(normalizePath("path/to/fake/Report_KRI.Rmd"))
}

test_that("Check for required packages", {
  expect_error(Report_KRI(), regexp = "to run `Study_Report()`")
})

test_that("Check default output path when strOutpath is NULL", {
  withr::with_envvar(c("RSTUDIO_PANDOC" = ""), {
    expect_output(
      Report_KRI(strOutpath = NULL) %>% grepl(paste0(getwd(), "/kri_report.html"), .),
      fixed = TRUE )
  })
})

test_that("Output path is correctly assigned", {
  withr::with_envvar(c("RSTUDIO_PANDOC" = ""), {
    expect_identical(
      Report_KRI(strOutpath = "custom_path.html") %>%
        grepl("custom_path.html", .),
      TRUE
    )
  })
})

test_that("Function handles NULL arguments properly", {
  expect_silent(Report_KRI())
})

test_that("Function handles non-NULL arguments properly", {
  lCharts <- list(chart1 = "data_chart_1", chart2 = "data_chart_2")
  dfSummary <- data.frame(Summary = c("Summary 1", "Summary 2"), stringsAsFactors = FALSE)
  dfStudy <- data.frame(Study = c("Study 1", "Study 2"), stringsAsFactors = FALSE)
  dfSite <- data.frame(Site = c("Site 1", "Site 2"), stringsAsFactors = FALSE)
  dfMetrics <- data.frame(Metrics = c("Metrics 1", "Metrics 2"), stringsAsFactors = FALSE)
  withr::with_envvar(c("RSTUDIO_PANDOC" = ""), {
    expect_silent(Report_KRI(
      lCharts = lCharts, dfSummary = dfSummary, dfStudy = dfStudy, dfSite = dfSite, dfMetrics = dfMetrics,
      strOutpath = "test_output.html"
    ))
  })
})

test_that("Verifying rendering of RMarkdown file", {
  withr::with_envvar(c("RSTUDIO_PANDOC" = ""), {
    expect_message(
      Report_KRI(strOutpath = "test_report.html"),
      "Output created: test_report.html"
    )
  })
})
