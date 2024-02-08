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
    plot_data <- dfInput %>%
      filter(!is.empty(`Discontinuation Reason`)) %>%
      group_by(`Discontinuation Reason`) %>%
      summarise(disp = n())

    ggplotly(
      ggplot(plot_data,
             aes(x = reorder(`Discontinuation Reason`, desc(disp)),
                 y = disp,
                 text = paste0(
                   glue("Total Patients: {plot_data$disp}"), "</br></br>",
                   glue("Reason: {plot_data$`Discontinuation Reason`}")
                 )
             )
      ) +
        geom_col(fill = "dodgerblue", alpha = .8) +
        xlab("Discontinuation Reason") +
        ylab("# Patients Disc.") +
        theme(
          axis.text.x = element_text(angle = 45),
          axis.title.x = element_blank(),
          axis.title.y = element_text(face = "bold", size = 11),
          panel.background = element_rect(fill = "white"),
          panel.grid = element_blank(),
          axis.line = element_line(color = "lightgrey", size = .25)
        ), tooltip = "text"
    )
  } else if (strGroup == "Site") {
    plot_data <- dfInput %>%
      filter(!is.empty(`Discontinuation Reason`)) %>%
      group_by(`Site ID`, `Discontinuation Reason`) %>%
      summarise(disc = n()) %>%
      group_by(`Site ID`) %>%
      mutate(total = sum(disc))

    ggplotly(
      ggplot(plot_data,
             aes(x = reorder(`Site ID`, desc(total)),
                 y = disc,
                 fill = `Discontinuation Reason`,
                 text = paste0(
                   glue("Site: {plot_data$`Site ID`}"), "</br></br>",
                   glue("Patients Discontinued: {plot_data$disc}"), "</br>",
                   glue("Reason: {plot_data$`Discontinuation Reason`}")
                 )
             )
      ) +
        geom_col(show.legend = FALSE) +
        xlab("Discontinuation Reason") +
        ylab("# Patients Disc.") +
        expand_limits(y = max(plot_data$disc) * 1.1) +
        theme(
          axis.text.x = element_text(angle = 90),
          axis.title.x = element_blank(),
          axis.title.y = element_text(face = "bold", size = 11),
          panel.background = element_rect(fill = "white"),
          panel.grid = element_blank(),
          axis.line = element_line(color = "lightgrey", size = .25)
        ), tooltip = "text"
    )
  }

}
