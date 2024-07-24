#' Time Series Widget
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' A widget that generates a time series of group-level metric results over time, plotting snapshot
#' date on the x-axis and the outcome (numerator, denominator, metric, or score) on the y-axis.
#'
#' @inheritParams shared-params
#' @param lMetric `list` Metric metadata, captured at the top of metric workflows and returned by
#' [MakeMetric()].
#' @param dfGroups `data.frame` Group metadata.
#' @param vThreshold `numeric` Threshold value(s).
#' @param strOutcome `character` Outcome variable. Default: 'Score'.
#' @param bAddGroupSelect `logical` Add a dropdown to highlight sites? Default: `TRUE`.
#' @param bDebug `logical` Print debug messages? Default: `FALSE`.
#'
#' @examples
#' \dontrun{
#' strMetricID <- "kri0001"
#' lMetricWorkflow <- MakeWorkflowList()[[strMetricID]]
#'
#' lData <- list(
#'   dfEnrolled = clindata::rawplus_dm %>% filter(enrollyn == "Y"),
#'   dfAE = clindata::rawplus_ae
#' )
#'
#' lResults <- lMetricWorkflow %>%
#'   RunWorkflow(lData)
#'
#' # Simulate longitudinal snapshot data.
#' SnapshotDates <- paste0("20", 13:24, "-01-01")
#'
#' dfSummary <- purrr::map_dfr(
#'   SnapshotDates,
#'   ~ {
#'     order <- sample(1:nrow(lResults$dfSummary))
#'     dfSummary <- lResults$dfSummary %>%
#'       mutate(
#'         SnapshotDate = .x,
#'         Numerator = Numerator[order],
#'         Denominator = Denominator[order],
#'         Metric = Metric[order],
#'         Score = Score[order],
#'         Flag = Flag[order]
#'       )
#'
#'     return(dfSummary)
#'   }
#' )
#'
#' dfGroups <- bind_rows(
#'   "SELECT pi_number as GroupID,
#'     site_status as Status,
#'     pi_first_name as InvestigatorFirstName,
#'     pi_last_name as InvestigatorLastName,
#'     city as City,
#'     state as State,
#'     country as Country, *
#'    FROM df" %>%
#'     RunQuery(clindata::ctms_site) %>%
#'     MakeLongMeta("Site"),
#'   "SELECT invid as GroupID,
#'     COUNT(DISTINCT subjectid) as ParticipantCount,
#'     COUNT(DISTINCT invid) as SiteCount
#'    FROM df
#'    GROUP BY invid" %>%
#'     RunQuery(lData$dfEnrolled) %>%
#'     MakeLongMeta("Site"),
#'   "SELECT country as GroupID,
#'     COUNT(DISTINCT subjectid) as ParticipantCount,
#'     COUNT(DISTINCT invid) as SiteCount
#'    FROM df
#'    GROUP BY country" %>%
#'     RunQuery(lData$dfEnrolled) %>%
#'     MakeLongMeta("Country")
#' )
#'
#' Widget_TimeSeries(
#'   dfResults = dfSummary,
#'   lMetric = lMetricWorkflow$meta,
#'   dfGroups = dfGroups,
#'   vThreshold = lMetricWorkflow$meta$Threshold
#' )
#' }
#' @export

Widget_TimeSeries <- function(
  dfResults,
  lMetric,
  dfGroups = NULL,
  vThreshold = NULL,
  strOutcome = "Score",
  bAddGroupSelect = TRUE,
  bDebug = FALSE
) {
  # Parse `vThreshold` from comma-delimited character string to numeric vector.
  if (!is.null(vThreshold)) {
    if (is.character(vThreshold)) {
      vThreshold <- strsplit(vThreshold, ",")[[1]] %>% as.numeric()
    }
  }
  print(vThreshold)
  # define widget inputs
  input <- list(
    dfResults = dfResults,
    lMetric = lMetric,
    dfGroups = dfGroups,
    vThreshold = vThreshold,
    strOutcome = strOutcome,
    bAddGroupSelect = bAddGroupSelect,
    bDebug = bDebug
  )

  # create widget
  widget <- htmlwidgets::createWidget(
    name = "Widget_TimeSeries",
    purrr::map(
      input,
      ~ jsonlite::toJSON(
        .x,
        null = "null",
        na = "string",
        auto_unbox = TRUE
      )
    ),
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

#' Shiny bindings for Widget_TimeSeries
#'
#' `r lifecycle::badge("stable")`
#'
#' Output and render functions for using Widget_TimeSeries within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a Widget_TimeSeries
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name Widget_TimeSeries-shiny
#'
#' @export
Widget_TimeSeriesOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "Widget_TimeSeries", width, height, package = "gsm")
}

#' @rdname Widget_TimeSeries-shiny
#' @export
renderWidget_TimeSeries <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, Widget_TimeSeriesOutput, env, quoted = TRUE)
}
