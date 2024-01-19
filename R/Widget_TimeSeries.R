#' Time-Series Continuous Plot
#'
#' `r lifecycle::badge("experimental")`
#'
#' @description
#' A widget that displays a time-series plot based on longitudinal snapshots using `{gsm}`.
#'
#' @param dfSummary `data.frame` the stacked output of `Make_Snapshot()$lStackedSnapshots$rpt_site_kri_details`, containing a minimum of two unique values for `gsm_analysis_date`.
#' @param lLabels `list` chart labels, typically defined by `Make_Snapshot()$lStackedSnapshots$rpt_site_kri_details`.
#' @param dfParams `data.frame` the stacked output of `Make_Snapshot()$lStackedSnapshots$rpt_kri_threshold_param`.
#' @param selectedGroupIDs `character` group IDs to highlight, \code{NULL} by default, can be a single site or a vector.
#' @param width `numeric` width of widget.
#' @param height `numeric` height of widget.
#' @param elementId `character` ID of container HTML element.
#' @param addSiteSelect `logical` add a dropdown to highlight sites? Default: `TRUE`.
#' @param siteSelectLabelValue Label used to populate the HTML drop-down menu. Constructed as: 'Highlighted {siteSelectLabelValue}: '.
#'
#' @importFrom jsonlite toJSON
#'
#' @export
Widget_TimeSeries <- function(
  dfSummary,
  lLabels,
  dfParams,
  selectedGroupIDs = NULL,
  width = NULL,
  height = NULL,
  elementId = NULL,
  addSiteSelect = TRUE,
  siteSelectLabelValue = NULL
) {
  if (!is.null(siteSelectLabelValue)) {
    siteSelectLabelValue <- paste0("Highlighted ", siteSelectLabelValue, ": ")
  }

  # rename results to account for rpt_* table refactor
  # -- this is the data format expected by JS library {rbm-viz}

  dfSummary <- dfSummary %>%
    select(
      "studyid",
      "groupid" = "siteid",
      "numerator" = "numerator_value",
      "denominator" = "denominator_value",
      "metric" = "metric_value",
      "score",
      "flag" = "flag_value",
      "gsm_analysis_date",
      "snapshot_date"
    )

  # get unique sites
  if (all(grepl("^[0-9]$", dfSummary$groupid))) {
    uniqueSiteSelections <- sort(unique(as.numeric(dfSummary$groupid)))
  } else {
    uniqueSiteSelections <- sort(unique(dfSummary$groupid))
  }

  lLabels <- lLabels %>%
    select(
      "workflowid",
      "group",
      "abbreviation",
      "metric",
      "numerator",
      "denominator",
      "outcome",
      "model",
      "score",
      "data_inputs",
      "data_filters",
      "gsm_analysis_date"
    )

  dfParams <- dfParams %>%
    select(
      "workflowid",
      "param",
      "index",
      "gsm_analysis_date",
      "snapshot_date",
      "studyid",
      "value" = "default_s"
    )



  # forward options using x
  x <- list(
    dfSummary = jsonlite::toJSON(dfSummary, na = "string"),
    lLabels = lLabels,
    dfParams = jsonlite::toJSON(dfParams, na = "string"),
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
          id = glue::glue("site-select--time-series_{lLabels$workflowid}"),
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

#' Shiny bindings for Widget_TimeSeries
#'
#' `r lifecycle::badge("experimental")`
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


#' @rdname Widget_TimeSeries-shiny
#' @export
renderWidget_TimeSeries <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, Widget_TimeSeriesOutput, env, quoted = TRUE)
}
