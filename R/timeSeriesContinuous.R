#' <Add Title>
#'
#' <Add Description>
#'
#' @param kri selected workflow to filter data and display
#' @param raw_results results_summary_over_time
#' @param raw_workflow meta_workflow
#' @param raw_param meta_param
#' @param raw_param_over_time status_param_over_time
#' @param selectedGroupIDs specific group to highlight in the chart
#' @param width
#' @param height
#' @param elementId
#'
#' @import htmlwidgets
#'
#' @export
timeSeriesContinuous <- function(kri,
                       raw_results,
                       raw_workflow,
                       raw_param,
                       raw_param_over_time,
                       selectedGroupIDs = NULL,
                       width = NULL,
                       height = NULL,
                       elementId = NULL) {


  results <- raw_results %>%
    filter(workflowid == kri) # contains the string kri


  workflow <- raw_workflow %>%
    filter(grepl('kri', workflowid))%>%
    filter(workflowid == kri) %>%
    mutate(selectedGroupIDs = selectedGroupIDs)

  parameters <- raw_param %>%
    filter(workflowid == kri)


  # forward options using x
  x <- list(
    results = results,
    workflow = workflow,
    parameters = parameters
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'timeSeriesContinuous',
    x,
    width = width,
    height = height,
    package = 'gsm',
    elementId = elementId
  )
}

#' Shiny bindings for timeSeriesContinuous
#'
#' Output and render functions for using timeSeriesContinuous within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a timeSeriesContinuous
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name timeSeriesContinuous-shiny
#'
#' @export
timeSeriesContinuousOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'timeSeriesContinuous', width, height, package = 'gsm')
}

#' @rdname timeSeriesContinuous-shiny
#' @export
renderTimeSeriesContinuous <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, timeSeriesContinuousOutput, env, quoted = TRUE)
}
