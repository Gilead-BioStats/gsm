#' Site Overview Table
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' A widget that displays a site overview table based on the output of [gsm::Study_Assess()].
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
#' @param lConfig configuration with columns:
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
#' @param dfWorkflow `data.frame` Workflow metadata with columns:
#' \itemize{
#'  \item{\code{workflowid}}
#'  \item{\code{description}}
#'  \item{\code{abbreviation}}
#' }
#'
#' @param width width of widget, full screen by default
#' @param height height of widget, calculated based on width
#' @param elementId ID of container HTML element
#'
#' @examples
#' study_assessment <- Study_Assess()
#'
#' kri_results <- study_assessment %>%
#'     imap_dfr(function(kri, workflowid) {
#'         kri$lResults$lData$dfSummary %>%
#'             rename_with(tolower) %>%
#'             mutate(
#'                 workflowid = !!workflowid
#'             )
#'     }) %>%
#'     filter(grepl('^kri', workflowid))
#'
#' Widget_SiteOverview(kri_results)
#'
#' @export

Widget_SiteOverview <- function(
  dfSummary,
  lConfig = list(),
  dfSite = Site_Map_Raw(),
  dfWorkflow = gsm::meta_workflow,
  width = NULL,
  height = NULL,
  elementId = NULL
) {
  dfSummary <- dfSummary %>%
    dplyr::rename_with(tolower)

  if (!is.null(elementId)) {
    elementId <- paste(elementId, as.numeric(Sys.time()) * 1000, sep = "-")
  }

  if (!is.null(dfSite)) {
    dfSite <- jsonlite::toJSON(dfSite, na = "string")
  }

  # forward options using x
  x <- list(
    dfSummary = jsonlite::toJSON(dfSummary, na = "string"),   # data
    lConfig = jsonlite::toJSON(lConfig, na = "string"),       # config
    dfSite = dfSite,                                          # site metadata
    dfWorkflow = jsonlite::toJSON(dfWorkflow, na = "string")  # workflow metadata
  )

  # create widget
  htmlwidgets::createWidget(
    name = "Widget_SiteOverview",
    x,
    width = width,
    height = height,
    package = "gsm",
    elementId = elementId
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
