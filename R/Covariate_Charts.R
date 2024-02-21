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
    map(kri, function(data){
      ## create study level bar plotl
      plot_output$study <- plot_ly(data$study) %>%
        add_trace(
          y = ~reorder(Metric, `# Patients`),
          x = ~`# Patients`,
          type = "bar",
          orientation = "h",
          text = paste0(
            glue("Total Patients: {data$study$`# Patients`}"), "</br></br>",
            glue("Reason: {data$study$Metric}")
          ),
          textposition = "none",
          hoverinfo = "text") %>%
        layout(yaxis = list(title = ""),
               xaxis = list(title = list(text = "<b>Number of Patients</b>"),
                            titlefont = list(size = 16)),
               margin = list(pad = 4)
        )


      ## create site level bar plot
      plot_output$site <- plot_ly(data$site) %>%
        highlight_key(~ `Site ID`) %>%
        add_trace(
          y = ~reorder(`Site ID`, `# Patients`),
          x = ~`# Patients`,
          color = ~Metric,
          type = "bar",
          # orientation = "h",
          text = paste0(
            glue("Site: {data$site$`Site ID`}"), "</br></br>",
            glue("Patient Count: {data$site$`# Patients`}"), "</br>",
            glue("Metric: {data$site$Metric}")
          ),
          textposition = "none",
          hoverinfo = "text"
        ) %>%
        layout(xaxis = list(title = "<b>Number of Patients</b>"),
               yaxis = list(title = list(text = ""),
                            titlefont = list(size = 16)),
               barmode = "stack",
               margin = list(pad = 4)) %>%
        highlight(on = "plotly_click",off = "plotly_doubleclick") %>%
        htmlwidgets::onRender("
      function(el, x) {
        el.classList.add('covariate-scatter-plot');
  }")


      return(plot_output)
    })
  })
  return(mapped_plots)
}

