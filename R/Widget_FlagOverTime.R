Widget_FlagOverTime <- function(
  dfResults,
  dfMetrics,
  strGroupLevel = c("Site", "Study", "Country"),
  strGroupSubset = "red"
) {
  gtFlagOverTime <- Report_FlagOverTime(
    dfResults,
    dfMetrics,
    strGroupLevel = strGroupLevel
  ) %>%
    gt::tab_options(table.align = "left") %>%
    gt::as_raw_html()
  x <- list(
    html = gtFlagOverTime
  )
  htmlwidgets::createWidget(
    name = "Widget_FlagOverTime",
    x,
    width = "100%",
    package = 'gsm'
  )
}
