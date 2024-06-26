#' Site Overview Table
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' A widget that displays a site overview table based on the output of KRI pipelines.
#'
#' @param dfSummary `data.frame` Analysis results data with columns:
#' \itemize{
#'  \item{\code{GroupID}}
#'  \item{\code{WorkflowID}}
#'  \item{\code{Numerator}}
#'  \item{\code{Denominator}}
#'  \item{\code{Metric}}
#'  \item{\code{Score}}
#'  \item{\code{Flag}}
#' }
#'
#' @param dfSite `data.frame` Site metadata with columns:
#' \itemize{
#'  \item{\code{studyid}}
#'  \item{\code{siteid} (derived from \code{pi_number})}
#'  \item{\code{account}}
#'  \item{\code{pi_last_name}}
#'  \item{\code{status}}
#'  \item{\code{country}}
#'  \item{\code{enrolled_participants} (derived)}
#'
#' @param dfMetrics `data.frame` Workflow metadata with columns:
#' \itemize{
#'  \item{\code{workflowid}}
#'  \item{\code{abbreviation}}
#'  \item{\code{numerator}}
#'  \item{\code{denominator}}
#'  \item{\code{metric}}
#'  \item{\code{score}}
#' }
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
#'     map(\(workflow) RunWorkflow(workflow, data_mapped))
#'
#' dfSummary <- results %>% map_dfr(~ {
#'     data <- .x$lData$dfSummary
#'     data$workflowid <- .x$name
#'     data
#' })
#' 
#' counts <- RunWorkflow(workflows$counts, data_mapped)
#' 
#' dfSite <- clindata::ctms_site %>%
#'     mutate(
#'         siteid = .data$site_num,
#'         invname = paste(.data$pi_last_name, .data$pi_first_name, sep = ', ')
#'     ) %>%
#'     left_join(
#'         counts$lData$dfSiteCounts,
#'         c('site_num' = 'GroupID')
#'     ) %>%
#'     rename(
#'         status = site_status,
#'         enrolled_participants = nSubjects
#'     )
#' 
#' dfMetrics <- results %>% map_dfr(~ {
#'     metric <- .x$meta
#'     metric$workflowid <- metric$MetricID
#'     metric$vThreshold <- paste(metric$vThreshold, collapse = ',')
#'     metric
#' })
#' 
#' Widget_SiteOverview(
#'   dfSummary,
#'   dfSite,
#'   dfMetrics
#' )
#' }
#' @export

Widget_SiteOverview <- function(
  dfSummary,
  dfSite = clindata::ctms_site,
  dfMetrics = gsm::meta_workflow
) {
  # forward options using x
  x <- list(
    dfSummary = dfSummary,
    dfSite = dfSite,
    dfMetrics = dfMetrics
  )

  # create widget
  htmlwidgets::createWidget(
    name = "Widget_SiteOverview",
    x %>% map(\(x) jsonlite::toJSON(x, na = "string")),
    package = "gsm"
  )
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
