#' Flag Over Time Widget
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' A widget that generates a table of flags over time using
#' [Report_FlagOverTime()].
#'
#' @inheritParams shared-params
#' @param strGroupLevel `character` Value for the group level. Default: "Site".
#'
#' @examples
#' Widget_FlagOverTime(
#'   dfResults = reportingResults,
#'   dfMetrics = reportingMetrics
#' )
#' @export
Widget_FlagOverTime <- function(
  dfResults,
  dfMetrics = NULL,
  strGroupLevel = c("Site", "Study", "Country")
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
    package = "gsm"
  )
}

#' Shiny bindings for Widget_FlagOverTime
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Output and render functions for using Widget_FlagOverTime within
#' Shiny applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#'
#' @name Widget_FlagOverTime-shiny
#'
#' @export
Widget_FlagOverTimeOutput <- function(
  outputId,
  width = "100%",
  height = "400px"
) {
  htmlwidgets::shinyWidgetOutput(
    outputId,
    "Widget_FlagOverTime",
    width,
    height,
    package = "gsm"
  )
}

#' @rdname Widget_FlagOverTime-shiny
#' @inheritParams Widget_FlagOverTime
#' @export
renderWidget_FlagOverTime <- function(
  dfResults,
  dfMetrics,
  strGroupLevel = c("Site", "Study", "Country")
) {
  htmlwidgets::shinyRenderWidget(
    {
      Widget_FlagOverTime(dfResults, dfMetrics, strGroupLevel)
    },
    Widget_FlagOverTimeOutput,
    env = rlang::current_env(),
    quoted = FALSE
  )
}
