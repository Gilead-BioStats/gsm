#' `r lifecycle::badge("experimental")`
#'
#' Time-Series Continuous Plot
#'
#' @description
#' A widget that displays a time-series plot based on longitudinal snapshots using `{gsm}`.
#'
#' @param results `data.frame` the stacked output of `Make_Snapshot()$lSnapshot$results_summary`, containing a minimum of two unique values for `gsm_analysis_date`.
#' @param workflow `data.frame` the output of `Make_Snapshot()$lSnapshot$meta_workflow`.
#' @param parameters `data.frame` the stacked output of `Make_Snapshot()$lSnapshot$meta_param`.
#' @param selectedGroupIDs `character` group IDs to highlight, \code{NULL} by default, can be a single site or a vector.
#' @param width `numeric` width of widget.
#' @param height `numeric` height of widget.
#' @param elementId `character` ID of container HTML element.
#' @param addSiteSelect `logical` add a dropdown to highlight sites? Default: `TRUE`.
#' @param siteSelectLabelValue Label used to populate the HTML drop-down menu. Constructed as: 'Highlighted {siteSelectLabelValue}: '.
#'
#' @import htmlwidgets
#' @import htmltools
#'
#' @export
Widget_TimeSeries <- function(
  results,
  workflow,
  parameters,
  selectedGroupIDs = NULL,
  width = NULL,
  height = NULL,
  elementId = NULL,
  addSiteSelect = TRUE,
  siteSelectLabelValue = NULL
) {
  # get unique sites
  if (all(grepl("^[0-9]$", results$groupid))) {
    uniqueSiteSelections <- sort(unique(as.numeric(results$groupid)))
  } else {
    uniqueSiteSelections <- sort(unique(results$groupid))
  }

  if (!is.null(siteSelectLabelValue)) {
    siteSelectLabelValue <- paste0("Highlighted ", siteSelectLabelValue, ": ")
  }


  # forward options using x
  x <- list(
    results = results,
    workflow = workflow,
    parameters = parameters,
    addSiteSelect = addSiteSelect,
    selectedGroupIDs = c(as.character(selectedGroupIDs))
  )

  # create standalone timeseries widget
  htmlwidgets::createWidget(
    name = "Widget_TimeSeries",
    x,
    width = width,
    height = height,
    package = "gsm",
    elementId = elementId
  ) %>%
    htmlwidgets::prependContent(
      htmltools::tags$div(
        class = "select-group-container",
        htmltools::tags$label(siteSelectLabelValue),
        htmltools::tags$select(
          class = "site-select--time-series",
          id = glue::glue("site-select--time-series_{unique(workflow$workflowid)}"),
          purrr::map(
            c("None", uniqueSiteSelections),
            ~ htmltools::HTML(paste0(
              "<option value='",
              .x,
              "'",
              ifelse(.x == selectedGroupIDs, "selected", ""),
              ">",
              .x,
              "</option>"
            ))
          )
        )
      )
    )
}

#' `r lifecycle::badge("experimental")`
#'
#' Shiny bindings for Widget_TimeSeries
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

#' `r lifecycle::badge("experimental")`
#'
#' @rdname Widget_TimeSeries-shiny
#' @export
renderWidget_TimeSeries <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, Widget_TimeSeriesOutput, env, quoted = TRUE)
}
