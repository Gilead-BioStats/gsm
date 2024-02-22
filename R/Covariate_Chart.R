#' Covariate Charts
#'
#' @param dfCovariate data.frame returned by [gsm::Covariate_Map].
#'
#' @return `list` of Plotly chart objects.
#'
#' @examples
#' \dontrun{
#' snapshot <- Make_Snapshot()
#'
#' study_comp <- Covariate_Map(
#'   dfCovariate = snapshot$lStudyAssessResults$kri0006$lData$dfSTUDCOMP,
#'   strCovariteColName = "compreas",
#'   strWorkflowId = "kri0006"
#' )
#'
#' charts <- Covariate_Chart(study_comp)
#' }
#'
#' @export
Covariate_Chart <- function(dfCovariate) {

  site_total <- covariate_chart_site(dfCovariate[[1]]$site, strType = "total")
  site_percent <- covariate_chart_site(dfCovariate[[1]]$site, strType = "percent")
  study_total <- covariate_chart_study(dfCovariate[[1]]$study, strType = "total")
  study_percent <- covariate_chart_study(dfCovariate[[1]]$study, strType = "percent")

  return(dplyr::lst(
    site_total,
    site_percent,
    study_total,
    study_percent
  ))

}



#' Make covariate site chart.
#'
#' @param dfCovariate `data.frame` site-level data.frame returned by [gsm::Covariate_Map].
#' @param strType `character` one of "total" or "percent".
#'
#' @return `plotly` chart.
#'
#' @keywords internal
#' @export
covariate_chart_site <- function(dfCovariate, strType = "total") {

  strType <- switch(strType, total = "Total", percent = "Percent")

  plot <- plotly::plot_ly(dfCovariate) %>%
    plotly::add_bars(
      y = ~reorder(`Site ID`, .data[[strType]]),
      x = ~.data[[strType]],
      color = ~Metric,
      type = "bar",
      text = paste0(
        glue::glue("Site: {dfCovariate$`Site ID`}"), "</br></br>",
        glue::glue("Patient {strType}: {dfCovariate[[strType]]}"), "</br>",
        glue::glue("Metric: {dfCovariate$Metric}")
      ),
      textposition = "none",
      hoverinfo = "text"
    ) %>%
    plotly::layout(xaxis = list(title = glue::glue("<b>Metric ({strType})</b>")),
                   yaxis = list(title = list(text = ""),
                                titlefont = list(size = 16)),
                   barmode = "stack",
                   margin = list(pad = 4),
                   bargap = 10
    ) %>%
    htmlwidgets::onRender("
      function(el, x) {
        el.classList.add('covariate-scatter-plot-site');
      }")

  return(plot)
}



#' Make covariate study chart.
#'
#' @param dfCovariate `data.frame` study-level data.frame returned by [gsm::Covariate_Map].
#' @param strType `character` one of "total" or "percent".
#'
#' @return `plotly` chart.
#'
#' @keywords internal
#' @export
covariate_chart_study <- function(dfCovariate, strType) {

  strType <- switch(strType, total = "Total", percent = "Percent")

  plot <- plotly::plot_ly(dfCovariate) %>%
    plotly::add_trace(
      y = ~reorder(Metric, .data[[strType]]),
      x = ~.data[[strType]],
      type = "bar",
      orientation = "h",
      text = paste0(
        glue::glue("Total Patients: {dfCovariate[[strType]]}"), "</br></br>",
        glue::glue("Reason: {dfCovariate$Metric}")
      ),
      textposition = "none",
      hoverinfo = "text",
      width = 0.4) %>%
    plotly::layout(yaxis = list(title = ""),
           xaxis = list(title = list(text = glue::glue("<b>Metric ({strType})</b>")),
                        titlefont = list(size = 16)),
           margin = list(pad = 4)) %>%
    htmlwidgets::onRender("
      function(el, x) {
        el.classList.add('covariate-scatter-plot-study');
      }")


  return(plot)

}
