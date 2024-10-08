#' Group Overview Widget
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' A widget that generates a group overview table of group-level metric results across one or more
#' metrics.
#'
#' @inheritParams shared-params
#' @param strGroupLevel `character` Value for the group level. Default: NULL and taken from `dfMetrics$GroupLevel` if available.
#' @param strGroupSubset `character` Subset of groups to include in the table. Default: 'red'. Options:
#' - 'all': All groups.
#' - 'red': Groups with 1+ red flags.
#' - 'red/amber': Groups with 1+ red/amber flag.
#' - 'amber': Groups with 1+ amber flag.
#' @param strGroupLabelKey `character` Value for the group label key. Default: 'InvestigatorLastName'.
#'
#' @examples
#' # site-level report
#' Widget_GroupOverview(
#'   dfResults = FilterByLatestSnapshotDate(reportingResults),
#'   dfMetrics = reportingMetrics,
#'   dfGroups = reportingGroups
#' )
#'
#' # filter site-level report to all flags
#' Widget_GroupOverview(
#'   dfResults = FilterByLatestSnapshotDate(reportingResults),
#'   dfMetrics = reportingMetrics,
#'   dfGroups = reportingGroups,
#'   strGroupSubset = "all"
#' )
#'
#' # country-level report
#' reportingMetrics$GroupLevel <- "Country"
#' Widget_GroupOverview(
#'   dfResults = FilterByLatestSnapshotDate(reportingResults),
#'   dfMetrics = reportingMetrics,
#'   dfGroups = reportingGroups,
#'   strGroupLevel = "Country"
#' )
#'
#' @export

Widget_GroupOverview <- function(
  dfResults,
  dfMetrics,
  dfGroups,
  strGroupLevel = NULL,
  strGroupSubset = "red",
  strGroupLabelKey = "InvestigatorLastName",
  bDebug = FALSE
) {
  stopifnot(
    "dfResults is not a data.frame" = is.data.frame(dfResults),
    "dfMetrics is not a data.frame" = is.data.frame(dfMetrics),
    "dfGroups is not a data.frame" = is.data.frame(dfGroups),
    "strGroupSubset is not a character" = is.character(strGroupSubset),
    "strGroupLabelKey is not a character or NULL" = is.character(strGroupLabelKey) || is.null(strGroupLabelKey),
    "bDebug is not a logical" = is.logical(bDebug)
  )

  # set strGroupLevel if NULL and dfMetrics is not NULL
  if (is.null(strGroupLevel) && !is.null(dfMetrics)) {
    strGroupLevel <- unique(dfMetrics$GroupLevel)
  }

  if (is.null(strGroupLevel) || length(strGroupLevel) != 1) {
    stop("A single group level must be provided to create group-level output.")
  }

  # forward options using x
  input <- list(
    dfResults = dfResults,
    dfMetrics = dfMetrics,
    dfGroups = dfGroups,
    strGroupLevel = strGroupLevel,
    strGroupSubset = strGroupSubset,
    strGroupLabelKey = strGroupLabelKey,
    bDebug = bDebug
  )

  # create widget
  widget <- htmlwidgets::createWidget(
    name = "Widget_GroupOverview",
    purrr::map(
      input,
      ~ jsonlite::toJSON(
        .x,
        null = "null",
        na = "string",
        auto_unbox = TRUE
      )
    ),
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

#' Shiny bindings for Widget_GroupOverview
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Output and render functions for using Widget_GroupOverview within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a Widget_GroupOverview
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name Widget_GroupOverview-shiny
#'
#' @export
Widget_GroupOverviewOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "Widget_GroupOverview", width, height, package = "gsm")
}

#' @rdname Widget_GroupOverview-shiny
#' @export
renderWidget_GroupOverview <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, Widget_GroupOverviewOutput, env, quoted = TRUE)
}
