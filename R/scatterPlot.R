#' Scatter plot HTML widget from `{rbm-viz}`
#'
#' TODO: Update documentation
#'
#' @param results TODO
#' @param workflow TODO
#' @param bounds TODO
#' @param selectedGroupIDs TODO
#' @param width TODO
#' @param height TODO
#' @param elementId TODO
#'
#' @return htmlwidget scatter plot
#' @export
scatterPlot <- function(
    results,
    workflow,
    bounds,
    selectedGroupIDs = NULL,
    width = NULL,
    height = NULL,
    elementId = NULL
) {

  results <- results %>%
    dplyr::rename_with(tolower)

  if (!is.null(bounds)) {
    bounds <- bounds %>% dplyr::rename_with(tolower)
  }

  # forward options using x
  x = list(
    results = results,
    workflow = workflow,
    bounds = bounds,
    selectedGroupIDs = as.character(selectedGroupIDs)
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'scatterPlot',
    x,
    width = width,
    height = height,
    package = 'gsm',
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
scatterPlotOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'scatterPlot', width, height, package = 'gsm')
}

#' @rdname scatterPlot-shiny
#' @export
renderScatterPlot <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, scatterPlotOutput, env, quoted = TRUE)
}
