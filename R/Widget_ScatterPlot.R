#' KRI Scatter Plot
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' A widget that displays a group-level scatter plot based on the output of a KRI analysis.
#' Scatter plots are provided by default in any Assess function, and are suffixed with "JS" to indicate that they are an `htmlwidget` ported from the `rbm-viz` JavaScript library.
#'
#' @param dfSummary data with columns:
#' \itemize{
#'  \item{\code{studyid}}
#'  \item{\code{workflowid}}
#'  \item{\code{groupid}}
#'  \item{\code{numerator}}
#'  \item{\code{denominator}}
#'  \item{\code{metric}}
#'  \item{\code{score}}
#'  \item{\code{flag}}
#' }
#'
#' @param lLabels configuration with columns:
#' \itemize{
#'  \item{\code{workflow}}
#'  \item{\code{gsm_version}}
#'  \item{\code{group}}
#'  \item{\code{metric}}
#'  \item{\code{numerator}}
#'  \item{\code{denominator}}
#'  \item{\code{outcome}}
#'  \item{\code{model}}
#'  \item{\code{score}}
#'  \item{\code{data_inputs}}
#'  \item{\code{data_filters}}
#' }
#'
#' @param dfSite `data.frame` Site metadata.
#'
#' @param dfBounds chart bounds data with columns:
#' \itemize{
#'  \item{\code{threshold}}
#'  \item{\code{numerator}}
#'  \item{\code{denominator}}
#'  \item{\code{metric}}
#'  \item{\code{logdenominator}}
#' }
#'
#' @param dfSummary `data.frame` A data.frame returned by [gsm::Summarize()].
#' @param lLabels `list` Metrics metadata.
#' @param dfSite `data.frame` Site metadata.
#' @param dfBounds `data.frame`, A data.frame returned by [gsm::Analyze_NormalApprox_PredictBounds()] or [gsm::Analyze_Poisson_PredictBounds()]
#' @param selectedGroupIDs group IDs to highlight, \code{NULL} by default, can be a single site or a vector.
#' @param addSiteSelect `logical` add a dropdown to highlight sites? Default: `TRUE`.
#' @param bHideDropdown `logical` should the dropdown be hidden? Default: `FALSE`. This is primarily used for the Shiny app `{gsmApp}` to hide the drop-down site selector,
#' since it is an additional element that needs to be updated based on user interactivity.
#' @param width width of widget, full screen by default
#' @param height height of widget, calculated based on width
#' @param elementId ID of container HTML element
#'
#'
#' @examples
#' \dontrun{
#' lData <- list(
#'     dfSTUDY = clindata::ctms_study,
#'     dfSITE = clindata::ctms_site,
#'     dfSUBJ = clindata::rawplus_dm,
#'     dfAE = clindata::rawplus_ae
#' )
#' 
#' mapping_workflow <- MakeWorkflowList('mapping')$mapping
#' 
#' mapping_workflow$steps <- mapping_workflow$steps %>%
#'     purrr::keep(~ .x$params$df %in% names(lData))
#' 
#' lDataMapped <- RunWorkflow(
#'     mapping_workflow,
#'     lData
#' )$lData
#' 
#' workflowid <- 'kri0001'
#' kri_workflow <- MakeWorkflowList(workflowid)[[ workflowid ]]
#' 
#' lResults <- RunWorkflow(
#'     kri_workflow,
#'     lDataMapped
#' )
#' 
#' dfSite <- clindata::ctms_site %>%
#'     left_join(
#'         lDataMapped$dfEnrolled %>%
#'             group_by(siteid) %>%
#'             tally(name = 'enrolled_participants'),
#'         c('site_num' = 'siteid')
#'     ) %>%
#'     rename(
#'         SiteID = site_num,
#'         status = site_status
#'     )
#' 
#' Widget_ScatterPlot(
#'     lResults$lData$dfSummary,
#'     kri_workflow$meta,
#'     dfSite,
#'     lResults$lData$dfBounds
#' )
#' }
#' @export
Widget_ScatterPlot <- function(
  dfSummary,
  lLabels,
  dfSite = NULL,
  dfBounds = NULL,
  selectedGroupIDs = NULL,
  addSiteSelect = TRUE,
  bHideDropdown = FALSE,
  width = NULL,
  height = NULL,
  elementId = NULL
) {
  if (!is.null(dfBounds)) {
    dfBounds <- dfBounds %>%
      jsonlite::toJSON()
  }

  if (!is.null(elementId)) {
    elementId <- paste(elementId, as.numeric(Sys.time()) * 1000, sep = "-")
  }

  if (!is.null(lLabels$Group)) {
    siteSelectLabelValue <- paste0("Highlighted ", lLabels$Group, ": ")
  }

  if (!is.null(dfSite)) {
    dfSite <- jsonlite::toJSON(dfSite, na = "string")
  }

  # forward options using x
  x <- list(
    dfSummary = jsonlite::toJSON(dfSummary, na = "string"),   # data
    lLabels = jsonlite::toJSON(lLabels, na = "string"),       # config
    dfBounds = dfBounds,                                      # bounds
    dfSite = dfSite,
    selectedGroupIDs = as.character(selectedGroupIDs),
    addSiteSelect = addSiteSelect,
    siteSelectLabelValue = siteSelectLabelValue,
    bHideDropdown = bHideDropdown
  )


  # create widget
  htmlwidgets::createWidget(
    name = "Widget_ScatterPlot",
    x,
    width = width,
    height = height,
    package = "gsm",
    elementId = elementId
  )
}

#' Shiny bindings for Widget_ScatterPlot
#'
#' `r lifecycle::badge("stable")`
#'
#' Output and render functions for using Widget_ScatterPlot within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a Widget_ScatterPlot
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name Widget_ScatterPlot-shiny
#'
#' @export
Widget_ScatterPlotOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "Widget_ScatterPlot", width, height, package = "gsm")
}

#' @rdname Widget_ScatterPlot-shiny
#' @export
renderWidget_ScatterPlot <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, Widget_ScatterPlotOutput, env, quoted = TRUE)
}
