#' generates plotly bar plot of study discontinuation information for discontinuation report
#'
#' @param dfInput_study `data.frame` output from `Disc_Study_Map()`
#' @param strGroup `string` type of bar plot to output option either 'Study' or 'Site
#'
#' @export
#'
#' @keywords internal
Disc_Bar_Plot <- function(dfInput, strGroup){
  if(strGroup == "Study"){
    plot_ly(dfInput) %>%
      add_trace(
        y = ~reorder(`Discontinuation Reason`, disc),
        x = ~disc,
        type = "bar",
        orientation = "h",
        text = paste0(
          glue("Total Patients: {dfInput$disc}"), "</br></br>",
          glue("Reason: {dfInput$`Discontinuation Reason`}")
        ),
        textposition = "none",
        hoverinfo = "text") %>%
      layout(yaxis = list(title = ""),
             xaxis = list(title = list(text = "<b>Patients Discontinued</b>"),
                          titlefont = list(size = 16))
      )
  } else if (strGroup == "Site") {
    plot_ly(dfInput) %>%
      add_trace(
        y = ~reorder(`Site ID`, total),
        x = ~disc,
        color = ~`Discontinuation Reason`,
        type = "bar",
        orientation = "h",
        text = paste0(
          glue("Site: {dfInput$`Site ID`}"), "</br></br>",
          glue("Patients Discontinued: {dfInput$disc}"), "</br>",
          glue("Reason: {dfInput$`Discontinuation Reason`}")
        ),
        hoverinfo = "text"
      ) %>%
      layout(yaxis = list(title = ""),
             xaxis = list(title = list(text = "<b>Patients Discontinued</b>"),
                          titlefont = list(size = 16)),
             barmode = "stack")
  }

}
