#' Site Overview Widget
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' A widget that generates a site overview table of group-level metric results across one or more
#' metrics.
#'
#' @param dfSummary `data.frame` Output of [gsm::Summarize()].
#' @param dfMetrics `list` Metric metadata, captured at the top of metric workflows and returned by
#' [gsm::MakeMetricInfo()].
#' @param dfGroups `data.frame` Group metadata.
#' @param strGroupSubset `character` Subset of groups to include in the table. Default: 'red'. Options:
#' - 'all': All groups.
#' - 'red': Groups with 1+ red flags.
#' - 'red/amber': Groups with 1+ red/amber flag.
#' - 'amber': Groups with 1+ amber flag.
#' @param bDebug `logical` Print debug messages? Default: `FALSE`.
#'
#' @examples
#' \dontrun{
#' data_raw <- gsm::UseClindata(
#'     list(
#'         "dfSUBJ" = "clindata::rawplus_dm",
#'         "dfAE" = "clindata::rawplus_ae",
#'         "dfPD" = "clindata::ctms_protdev",
#'         "dfLB" = "clindata::rawplus_lb",
#'         "dfSTUDCOMP" = "clindata::rawplus_studcomp",
#'         "dfSDRGCOMP" = "clindata::rawplus_sdrgcomp %>%
#'       dplyr::filter(.data$phase == 'Blinded Study Drug Completion')",
#'         "dfDATACHG" = "clindata::edc_data_points",
#'         "dfDATAENT" = "clindata::edc_data_pages",
#'         "dfQUERY" = "clindata::edc_queries",
#'         "dfENROLL" = "clindata::rawplus_enroll"
#'     )
#' )
#'
#' workflows <- MakeWorkflowList()
#'
#' data_mapped <- RunWorkflow(workflows$mapping, data_raw)$lData
#'
#' results <- workflows[ grepl('^kri', names(workflows) ) ] %>%
#'     map(~ RunWorkflow(.x, data_mapped))
#'
#' dfSummary <- results %>% map_dfr(~ {
#'     data <- .x$lData$dfSummary
#'     data$MetricID <- .x$name
#'     data
#' })
#' 
#' counts <- RunWorkflow(workflows$counts, data_mapped)
#' 
#' # TODO: use [ clindata::rawplus_dm$invid ] and [ clindata::ctms_site$pi_number ] insstead of
#' # [ clindata::rawplus_dm$siteid ] and [ clindata::ctms_site$site_num ].
#' dfGroups <- clindata::ctms_site %>%
#'   dplyr::left_join(
#'     clindata::rawplus_dm %>%
#'       dplyr::group_by(siteid) %>%
#'       dplyr::tally(name = "enrolled_participants"),
#'     c('site_num' = 'siteid')
#'   ) %>%
#'   dplyr::rename(
#'     SiteID = site_num,
#'     status = site_status
#'   )
#' 
#' dfMetrics <- results %>% map_dfr(~ {
#'     metric <- .x$meta
#'     metric$vThreshold <- paste(metric$vThreshold, collapse = ',')
#'     metric
#' })
#' 
#' Widget_SiteOverview(
#'   dfSummary,
#'   dfMetrics,
#'   dfGroups
#' )
#' }
#' @export

Widget_SiteOverview <- function(
  dfSummary,
  dfMetrics = gsm::meta_workflow,
  dfGroups = clindata::ctms_site %>%
    dplyr::left_join(
      clindata::rawplus_dm %>%
        dplyr::group_by(siteid) %>%
        dplyr::tally(name = "enrolled_participants"),
      c('site_num' = 'siteid')
    ) %>%
    dplyr::rename(
      SiteID = site_num,
      status = site_status
    ),
  strGroupSubset = 'red',
  bDebug = FALSE
) {
  # forward options using x
  input <- list(
    dfSummary = dfSummary,
    dfMetrics = dfMetrics,
    dfGroups = dfGroups,
    strGroupSubset = strGroupSubset
  )

  # create widget
  widget <- htmlwidgets::createWidget(
    name = "Widget_SiteOverview",
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

#' Shiny bindings for Widget_SiteOverview
#'
#' `r lifecycle::badge("stable")`
#'
#' Output and render functions for using Widget_SiteOverview within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a Widget_SiteOverview
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name Widget_SiteOverview-shiny
#'
#' @export
Widget_SiteOverviewOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "Widget_SiteOverview", width, height, package = "gsm")
}

#' @rdname Widget_SiteOverview-shiny
#' @export
renderWidget_SiteOverview <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, Widget_SiteOverviewOutput, env, quoted = TRUE)
}
