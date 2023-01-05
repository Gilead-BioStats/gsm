#' KRI scatter plot
#'
#' TODO: Add Description + update documentation
#'
#' @param results data with columns:
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
#' @param workflow configuration with columns:
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
#' @param bounds bounds data with columns:
#' \itemize{
#'  \item{\code{threshold}}
#'  \item{\code{numerator}}
#'  \item{\code{denominator}}
#'  \item{\code{metric}}
#'  \item{\code{logdenominator}}
#' }
#'
#' @param selectedGroupIDs group IDs to highlight, \code{NULL} by default, can be a single site or a vector.
#' @param addSiteSelect add a dropdown to highlight sites?
#' @param width width of widget, full screen by default
#' @param height height of widget, calculated based on width
#' @param elementId ID of container HTML element
#'
#' @import htmlwidgets
#'
#' @export
scatterPlot <- function(
  results,
  workflow,
  bounds,
  selectedGroupIDs = NULL,
  addSiteSelect = TRUE,
  width = NULL,
  height = NULL,
  elementId = NULL
) {
  results <- results %>%
    dplyr::rename_with(tolower)

  if (!is.null(bounds)) {
    bounds <- bounds %>% dplyr::rename_with(tolower)
  }

  if (!is.null(elementId)) {
    elementId <- paste(elementId, as.numeric(Sys.time()) * 1000, sep = "-")
  }

  # forward options using x
  x <- list(
    results = results,
    workflow = workflow,
    bounds = bounds,
    selectedGroupIDs = as.character(selectedGroupIDs),
    addSiteSelect = addSiteSelect
  )

  # create widget
  htmlwidgets::createWidget(
    name = "scatterPlot",
    x,
    width = width,
    height = height,
    package = "gsm",
    elementId = elementId
  )
}

#' Shiny bindings for scatterPlot
#'
#' Output and render functions for using scatterPlot within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a scatterPlot
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name scatterPlot-shiny
#'
#' @export
scatterPlotOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "scatterPlot", width, height, package = "gsm")
}

#' @rdname scatterPlot-shiny
#' @export
renderScatterPlot <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, scatterPlotOutput, env, quoted = TRUE)
}
