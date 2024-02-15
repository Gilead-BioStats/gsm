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
        hoverinfo = "text") %>%
      layout(yaxis = list(title = ""),
             xaxis = list(title = list(text = "<b>Number of Patients</b>"),
                          titlefont = list(size = 16)),
             margin = list(pad = 4)
      )
    ## create site level bar plot
    plot_output$site <- plot_ly(kri$site) %>%
      add_trace(
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
        hoverinfo = "text"
      ) %>%
      layout(xaxis = list(title = ""),
             yaxis = list(title = list(text = "<b>Number of Patients</b>"),
                          titlefont = list(size = 16)),
             barmode = "stack",
             margin = list(pad = 4))
    return(plot_output)
  })
  return(mapped_plots)
}

