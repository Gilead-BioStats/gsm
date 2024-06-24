skip()
lCharts <- list(
  kri0001 = NULL
)

dfSummary <- tibble::tibble(
 GroupID = c("10", "100", "101", "102", "103"),
 GroupLevel = rep("Site", 5),
 Numerator = seq(2,10,2),
 Denomicator = seq(10,50,10),
 Metric = c(0.02, 0.02, 0.02, 0.02, 0.02),
 Score = c(1,3,2,1,1),
 Flag = c(0,2,1,0,0),
 MetricID = rep("kri0001", 5)
)

dfStudy <- clindata::ctms_study %>% rename(StudyID = protocol_number)
dfSite <- clindata::ctms_site %>% rename(SiteID = site_num)
dfMetrics <- tibble::tibble(
  metric = "Adverse Event Rate",
  workflowid = "kri0001",
  group = "Site"
)

test_that("Check default output path when strOutpath is NULL", {
    expect_output(
      Report_KRI(lCharts = lCharts, dfSummary = dfSummary, dfStudy = dfStudy, dfSite = dfSite, dfMetrics = dfMetrics,
                 strOutpath = tempfile()) %>% grepl(getwd(), .),
      fixed = TRUE )
})

test_that("Output path is correctly assigned", {
  withr::with_envvar(c("RSTUDIO_PANDOC" = ""), {
    expect_identical(
      Report_KRI(lCharts = lCharts, dfSummary = dfSummary, dfStudy = dfStudy, dfSite = dfSite, dfMetrics = dfMetrics,
                 strOutpath = tempfile("custom_path")) %>%
        grepl("custom_path", .),
      TRUE
    )
  })
})

# test_that("Function handles NULL arguments properly", {
#   expect_silent(Report_KRI())
# })
#
# test_that("Function handles non-NULL arguments properly", {
#   withr::with_envvar(c("RSTUDIO_PANDOC" = ""), {
#     expect_silent(Report_KRI(
#       lCharts = lCharts, dfSummary = dfSummary, dfStudy = dfStudy, dfSite = dfSite, dfMetrics = dfMetrics,
#       strOutpath = "test_output.html"
#     ))
#   })
# })

test_that("Verifying rendering of RMarkdown file", {
  withr::with_envvar(c("RSTUDIO_PANDOC" = ""), {
    expect_message(
      Report_KRI(lCharts = lCharts, dfSummary = dfSummary, dfStudy = dfStudy, dfSite = dfSite, dfMetrics = dfMetrics,
                 strOutpath = tempfile("test_Report")),
      regexp = "Output created:.*test_Report"
    )
  })
})
