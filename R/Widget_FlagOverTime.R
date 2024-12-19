#' Flag Over Time Widget
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' A widget that generates a table of flags over time using
#' [Report_FlagOverTime()].
#'
#' @inheritParams shared-params
#' @param strGroupLevel `character` Value for the group level. Default: "Site".
#' @param strFootnote `character` Text to insert for figure
#' @param bExcludeEver `logical` Exclude options in widget dropdown that include the string "ever".
#' Default: `FALSE`.
#'
#' @examples
#' # Include all risk signals, irrespective flag value.
#' Widget_FlagOverTime(
#'   dfResults = reportingResults,
#'   dfMetrics = reportingMetrics
#' )
#'
#' # Include risk signals that were ever flagged.
#' Widget_FlagOverTime(
#'   dfResults = FilterByFlags(
#'     reportingResults
#'   ),
#'   dfMetrics = reportingMetrics
#' )
#'
#' # Include risk signals that were only flagged in the most recent snapshot.
#' Widget_FlagOverTime(
#'   dfResults = FilterByFlags(
#'     reportingResults,
#'     bCurrentlyFlagged = TRUE
#'   ),
#'   dfMetrics = reportingMetrics,
#'   bExcludeEver = TRUE
#' )
#'
#' @export

Widget_FlagOverTime <- function(
  dfResults,
  dfMetrics,
  strGroupLevel = c("Site", "Study", "Country"),
  strFootnote = NULL,
  bExcludeEver = FALSE,
  bDebug = FALSE
) {
  stopifnot(
    "dfResults is not a data.frame" = is.data.frame(dfResults),
    "dfMetrics is not a data.frame" = is.data.frame(dfMetrics),
    "strGroupLevel is not a character" = is.character(strGroupLevel),
    "strFootnote is not a character" = is.null(strFootnote) || is.character(strFootnote),
    "bDebug is not a logical" = is.logical(bDebug)
  )

  gtFlagOverTime <- Report_FlagOverTime(
    dfResults,
    dfMetrics,
    strGroupLevel = strGroupLevel
  ) %>%
    gt::tab_options(table.align = "left") %>%
    gt::as_raw_html(inline_css = FALSE)

  x <- list(
    gtFlagOverTime = gtFlagOverTime,
    strFootnote = strFootnote,
    bExcludeEver = bExcludeEver,
    bDebug = bDebug
  )

  widget <- htmlwidgets::createWidget(
    name = "Widget_FlagOverTime",
    x,
    width = "100%",
    package = "gsm"
  )

  if (bDebug) {
    viewer <- getOption("viewer")
    options(viewer = NULL)
    print(widget)
    options(viewer = viewer)
  }

  return(widget)
}

#' Shiny bindings for Widget_FlagOverTime
#'
#' @description
#' `r lifecycle::badge("stable")`
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
