#' Create charts for distribution of kri metrics
#'
#' @param lInput `list` output from `Distribution_Map()` function
#'
#' @export
#'
#' @keywords internal
Covariate_Charts <- function(lInput){
  # Create output list
  plot_output <- list()
  # map over dfInput to generate chart for each list component
  mapped_plots <- map(lInput, function(kri){
    ## create study level bar plot
    plot_output$study <- plot_ly(kri$study) %>%
      add_trace(
        y = ~reorder(Metric, Total),
        x = ~Total,
        type = "bar",
        orientation = "h",
        text = paste0(
          glue("Total Patients: {kri$study$Total}"), "</br></br>",
          glue("Reason: {kri$study$Metric}")
        ),
        textposition = "none",
        hoverinfo = "text",
        width = 0.4) %>%
      layout(yaxis = list(title = ""),
             xaxis = list(title = list(text = "<b>Metric Count</b>"),
                          titlefont = list(size = 16)),
             margin = list(pad = 4)
      )


    ## create site level bar plot
    plot_output$site <- plot_ly(kri$site) %>%
      add_bars(
        y = ~reorder(`Site ID`, Total),
        x = ~Total,
        color = ~Metric,
        type = "bar",
        # orientation = "h",
        text = paste0(
          glue("Site: {kri$site$`Site ID`}"), "</br></br>",
          glue("Patient Count: {kri$site$Total}"), "</br>",
          glue("Metric: {kri$site$Metric}")
        ),
        textposition = "none",
        hoverinfo = "text"#,
        # width = 0.8
      ) %>%
      layout(xaxis = list(title = "<b>Metric Count</b>"),
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


    return(plot_output)
  })
  return(mapped_plots)
}


#' Create site chart for distribution of kri metrics
#'
#' @param lInput `list` output from `Distribution_Map()` function
#'
#' @export
#'
#' @keywords internal
CovariateSiteChart <- function(lInput) {


  kri <- lInput$lCovariateTables[[1]]

  chart <- plot_ly(kri$site) %>%
    add_bars(
      y = ~reorder(`Site ID`, Total),
      x = ~Total,
      color = ~Metric,
      type = "bar",
      text = paste0(
        glue("Site: {kri$site$`Site ID`}"), "</br></br>",
        glue("Patient Count: {kri$site$Total}"), "</br>",
        glue("Metric: {kri$site$Metric}")
      ),
      textposition = "none",
      hoverinfo = "text",
    ) %>%
    layout(
      xaxis = list(title = "<b>Metric Count</b>"),
      yaxis = list(title = list(text = ""), titlefont = list(size = 16)),
      barmode = "stack",
      margin = list(pad = 4),
      bargap = 10
    ) %>%
    htmlwidgets::onRender("
      function(el, x) {
        el.classList.add('covariate-scatter-plot');
      }")
}
