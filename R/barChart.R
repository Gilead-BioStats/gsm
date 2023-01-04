#' KRI bar chart
#'
#' TODO: Add Description + update documentation
#'
#' @param results data with column names:
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
#' @param workflow configuration data with columns:
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
#' @param threshold a one row data frame containing columns:
#' \itemize{
#'  \item{\code{workflowid}}
#'  \item{\code{gsm_version}}
#'  \item{\code{param}}
#'  \item{\code{index}}
#'  \item{\code{default}}
#'  \item{\code{configurable}}
#' }
#'
#' @param yaxis either \code{'score'} or \code{'metric'}
#' @param selectedGroupIDs group IDs to highlight, \code{NULL} by default, can be a single site or a vector.
#' @param addSiteSelect add a dropdown to highlight sites?
#' @param width width of widget, full screen by default
#' @param height height of widget, calculated based on width
#' @param elementId ID of container HTML element
#'
#' @import htmlwidgets
#'
#' @export
barChart <- function(
  results = NULL,
  workflow = list(),
  threshold = NULL,
  yaxis = "score",
  selectedGroupIDs = NULL,
  addSiteSelect = TRUE,
  width = NULL,
  height = NULL,
  elementId = NULL
) {
  results <- results %>%
    dplyr::mutate(across(everything(), as.character)) %>%
    dplyr::rename_with(tolower)

  if (!is.null(elementId)) {
    elementId <- paste(elementId, as.numeric(Sys.time()) * 1000, sep = "-")
  }

  # forward options using x
  x <- list(
    results = results,
    workflow = workflow,
    threshold = threshold,
    yaxis = yaxis,
    selectedGroupIDs = as.character(selectedGroupIDs),
    addSiteSelect = addSiteSelect
  )

  # create widget
  htmlwidgets::createWidget(
    name = "barChart",
    x,
    width = width,
    height = height,
    package = "gsm",
    elementId = elementId
  )
}

#' Shiny bindings for barChart
#'
#' Output and render functions for using barChart within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a barChart
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name barChart-shiny
#'
#' @export
barChartOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "barChart", width, height, package = "gsm")
}

#' @rdname barChart-shiny
#'
#'
#' @export
renderBarChart <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, barChartOutput, env, quoted = TRUE)
}
