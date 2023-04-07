#' Time-Series Continuous Plot
#'
#' @description
#' A widget that displays a time-series plot based on longitudinal "snapshots" using `{gsm}`
#'
#' @param kri selected workflow to filter data and display
#' @param raw_results results_summary_over_time
#' @param raw_workflow meta_workflow
#' @param raw_param meta_param
#' @param raw_param_over_time status_param_over_time
#' @param selectedGroupIDs specific group to highlight in the chart
#' @param width width of widget
#' @param height height of widget
#' @param elementId optional elementId of widget
#' @param addSiteSelect add a dropdown to highlight sites?
#'
#' @import htmlwidgets
#'
#' @export
timeSeriesContinuous <- function(kri,
                       raw_results,
                       raw_workflow,
                       raw_param,
                       raw_analysis = NULL,
                       selectedGroupIDs = NULL,
                       width = NULL,
                       height = NULL,
                       elementId = NULL,
                       addSiteSelect = TRUE) {

  results <- raw_results %>%
    dplyr::filter(.data$workflowid == kri) # contains the string kri


  workflow <- raw_workflow %>%
    dplyr::filter(.data$workflowid == kri) %>%
    dplyr::mutate(selectedGroupIDs = selectedGroupIDs)

  if (length(raw_analysis) > 0) {
    workflow <- workflow %>% dplyr::mutate(y = "metric")

    analysis <- raw_analysis %>%
      dplyr::filter(.data$workflowid == kri)
  } else {
    analysis <- raw_analysis
  }

  parameters <- raw_param %>%
    dplyr::filter(.data$workflowid == kri)

  # highlight the most concerning site(s)
  # TODO: this doesn't work
  # if (is.null(selectedGroupIDs)) {
  #   selectedGroupIDs <- results %>%
  #     filter(flag == max(abs(flag))) %>%
  #     filter(score == max(abs(score))) %>%
  #     pull(groupid) %>%
  #     unique()
  # }

  # forward options using x
  x <- list(
    results = results,
    workflow = workflow,
    parameters = parameters,
    addSiteSelect = addSiteSelect,
    analysis = analysis,
    selectedGroupIDs = c(as.character(selectedGroupIDs))
    # selectedGroupIDs = c(selectedGroupIDs) #TODO: decide if this is the right implementation
  )

  # get unique sites
  uniqueSiteSelections <- sort(unique(as.numeric(results$groupid)))

  if (is.null(selectedGroupIDs)) {
    selectedGroupIDs <- 'None'
  }

  # create standalone timeseries widget
  htmlwidgets::createWidget(
        name = 'timeSeriesContinuous',
        x,
        width = width,
        height = height,
        package = 'gsm',
        elementId = elementId
  ) %>%
    htmlwidgets::prependContent(
      htmltools::tags$div(class="select-group-container",
        htmltools::tags$label("Highlighted Site:"),
        htmltools::tags$select(class="site-select",
                               purrr::map(c('None', uniqueSiteSelections),
                                          ~shiny::HTML(paste0(
                                            "<option value='",
                                            .x,
                                            "'",
                                            ifelse(.x == selectedGroupIDs, 'selected', ''),
                                            ">",
                                            .x,
                                            "</option>"
                                          ))
                               )
        )
      )
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
