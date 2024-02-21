#' Covariate Charts
#'
#' @param dfCovariate
#'
#' @return
#' @export
#'
#' @examples
Covariate_Chart <- function(dfCovariate) {

  site_total <- covariate_chart_site(dfCovariate)
  site_percent <- covariate_chart_site(dfCovariate, "percent")

  return(list(
    site_total, site_percent
  ))

}



#' Title
#'
#' @param dfCovariate
#' @param strType one of 'total' or 'percent'
#'
#' @return
#' @export
#'
#' @examples
#' @keywords internal
covariate_chart_site <- function(dfCovariate, strType = "total") {

  strType <- ifelse(strType == 'total', 'Total', 'Percent')

  plot <- plotly::plot_ly(dfCovariate) %>%
    plotly::add_bars(
      y = ~reorder(`Site ID`, .data[[strType]]),
      x = ~.data[[strType]],
      color = ~Metric,
      type = "bar",
      text = paste0(
        glue::glue("Site: {dfCovariate$`Site ID`}"), "</br></br>",
        glue::glue("Patient {tools::toTitleCase(strType)}: {dfCovariate[[strType]]}"), "</br>",
        glue::glue("Metric: {dfCovariate$Metric}")
      ),
      textposition = "none",
      hoverinfo = "text"
    ) %>%
    plotly::layout(xaxis = list(title = glue::glue("<b>Metric {tools::toTitleCase(strType)}</b>")),
                   yaxis = list(title = list(text = ""),
                                titlefont = list(size = 16)),
                   barmode = "stack",
                   margin = list(pad = 4),
                   bargap = 10
    ) %>%
    htmlwidgets::onRender("
      function(el, x) {
        el.classList.add('covariate-scatter-plot');
      }")

  return(plot)
}



#' Title
#'
#' @param dfCovariate
#'
#' @return
#' @export
#'
#' @examples
#' @keywords internal
covariate_chart_study <- function(dfCovariate) {

}
