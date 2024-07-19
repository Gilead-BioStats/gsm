#' Group Overview Widget
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' A widget that generates a group overview table of group-level metric results across one or more
#' metrics.
#'
#' @param dfResults `data.frame` Output of [Summarize()] and [BindResults()].
#' @param dfMetrics `list` Metric metadata, captured at the top of metric workflows and returned by
#' [MakeMetric()].
#' @param dfGroups `data.frame` Group metadata.
#' @param strGroupLevel `character` Value for the group level. Default: NULL and taken from `dfMetrics$GroupLevel` if available.
#' @param strGroupSubset `character` Subset of groups to include in the table. Default: 'red'. Options:
#' - 'all': All groups.
#' - 'red': Groups with 1+ red flags.
#' - 'red/amber': Groups with 1+ red/amber flag.
#' - 'amber': Groups with 1+ amber flag.
#' @param strGroupLabelKey `character` Value for the group label key. Default: 'InvestigatorLastName'.
#' @param bDebug `logical` Print debug messages? Default: `FALSE`.
#'
#' @examples
#' \dontrun{
#' strGroupLevel <- 'Site'
#'
#' lWorkflows <- MakeWorkflowList()
#' lMetricWorkflows <- lWorkflows[ grepl('^kri', names(lWorkflows) ) ]
#'
#' lDataRaw <- gsm::UseClindata(
#'     list(
#'         "dfSUBJ" = "clindata::rawplus_dm",
#'         "dfAE" = "clindata::rawplus_ae",
#'         "dfPD" = "clindata::ctms_protdev",
#'         "dfLB" = "clindata::rawplus_lb",
#'         "dfSTUDCOMP" = "clindata::rawplus_studcomp",
#'         "dfSDRGCOMP" = "clindata::rawplus_sdrgcomp %>%
#'             dplyr::filter(.data$phase == 'Blinded Study Drug Completion')",
#'         "dfDATACHG" = "clindata::edc_data_points",
#'         "dfDATAENT" = "clindata::edc_data_pages",
#'         "dfQUERY" = "clindata::edc_queries",
#'         "dfENROLL" = "clindata::rawplus_enroll"
#'     )
#' )
#'
#' lDataMapped <- RunWorkflow(lWorkflows$data_mapping, lDataRaw)
#'
#' lResults <- map(
#'     lMetricWorkflows,
#'     ~ RunWorkflow(.x, lDataMapped)
#' )
#'
#' dfResults <- lResults %>% imap_dfr(~ {
#'     data <- .x$dfSummary
#'     data$MetricID <- .y
#'     data$GroupLevel <- strGroupLevel
#'     data
#' })
#'
#' dfGroups <- bind_rows(
#'     "SELECT pi_number as GroupID, site_status as Status, pi_first_name as InvestigatorFirstName, pi_last_name as InvestigatorLastName, city as City, state as State, country as Country, * FROM df" %>%
#'         RunQuery(clindata::ctms_site) %>%
#'         MakeLongMeta('Site'),
#'     "SELECT invid as GroupID, COUNT(DISTINCT subjectid) as ParticipantCount, COUNT(DISTINCT invid) as SiteCount FROM df GROUP BY invid" %>%
#'         RunQuery(lData$dfEnrolled) %>%
#'         MakeLongMeta('Site'),
#'     "SELECT country as GroupID, COUNT(DISTINCT subjectid) as ParticipantCount, COUNT(DISTINCT invid) as SiteCount FROM df GROUP BY country" %>%
#'         RunQuery(lData$dfEnrolled) %>%
#'         MakeLongMeta('Country')
#' )
#'
#' dfMetrics <- lMetricWorkflows %>%
#'     map_dfr(~ .x$meta)
#'
#' Widget_GroupOverview(
#'   dfResults,
#'   dfMetrics,
#'   dfGroups
#' )
#' }
#' @export

Widget_GroupOverview <- function(
  dfResults,
  dfMetrics = NULL,
  dfGroups = NULL,
  strGroupLevel = NULL,
  strGroupSubset = 'red',
  strGroupLabelKey = 'InvestigatorLastName',
  bDebug = FALSE
) {
  # set strGroupLevel if NULL and dfMetrics is not NULL
  if (is.null(strGroupLevel) && !is.null(dfMetrics)) {
    strGroupLevel <- unique(dfMetrics$GroupLevel)
  }
  else if (!is.null(strGroupLevel)) {
    strGroupLevel <- strGroupLevel
  }
  else {
    stop("One of strGroupLevel or dfMetrics must be provided to create group-level output.")
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
    viewer <- getOption('viewer')
    options(viewer = NULL)
    print(widget)
    options(viewer = viewer)
  }

  return(widget)
}

#' Shiny bindings for Widget_GroupOverview
#'
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
