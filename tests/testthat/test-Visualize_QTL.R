# test_that("Visualize_QTL stops on incorrect input types", {
#   dfSummary <- data.frame()
#   dfParams <- data.frame()
#   dfAnalysis <- data.frame()
#   lLabels <- list()
#
#   expect_error(Visualize_QTL("QTL1", list(), dfParams, dfAnalysis, lLabels),
#                "[ `dfSummary` ] must be a `data.frame`.")
#   expect_error(Visualize_QTL("QTL1", dfSummary, dfParams, dfAnalysis, "labels"),
#                "[ `lLabels` ] must be a `list`.")
#   expect_error(Visualize_QTL("QTL1", dfSummary, "params", dfAnalysis, lLabels),
#                "[ `dfParam` ] must be a `data.frame`.")
#   expect_error(Visualize_QTL("QTL1", dfSummary, dfParams, "analysis", lLabels),
#                "[ `dfAnalysis` ] must be a `data.frame`.")
# })
#
# test_that("Visualize_QTL returns correct structure", {
#   dfSummary <- data.frame(a = 1:3, b = 4:6)
#   dfParams <- data.frame(c = 7:9, d = 10:12)
#   dfAnalysis <- data.frame(e = 13:15, f = 16:18)
#   lLabels <- list(label1 = "Label 1", label2 = "Label 2")
#   strQtlName <- "QTL1"
#
#   result <- Visualize_QTL(strQtlName, dfSummary, dfParams, dfAnalysis, lLabels)
#
#   expect_type(result, "list")
#   expect_named(result, "timeseriesQtl")
#   expect_type(result$timeseriesQtl, "list")
#   expect_equal(result$timeseriesQtl$qtl, strQtlName)
#   expect_equal(result$timeseriesQtl$dfSummary, dfSummary)
#   expect_equal(result$timeseriesQtl$lLabels, lLabels)
#   expect_equal(result$timeseriesQtl$dfParams, dfParams)
#   expect_equal(result$timeseriesQtl$dfAnalysis, dfAnalysis)
# })
