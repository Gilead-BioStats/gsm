#' Inclusion/Exclusion Visualization
#'
#' Site-level plot of treatment Inclusion/Exclusion issues
#'
#' @param dfTransformed Input data to IE assessment
#' @param dfFlagged Flagged data after IE assessment
#' @param strTitle Title of plot
#'
#' @import ggplot2 RColorBrewer ggtext
#'
#' @export

IE_Visualize <- function(  dfFlagged , strTitle = "Inclusion/Exclusion issues by site" ){
  # subset to just the flagged rows for annotations
  notes <- dfFlagged %>% 
    filter(Flag==1) %>%
    mutate(y=-0.5)

  p <- ggplot(
    data=dfFlagged, 
    aes(x=reorder(SiteID,-N))) +
    geom_bar(aes(y=N),stat="identity", color="black", fill="white")  + 
    geom_bar(aes(y=Invalid),stat="identity", fill="red")  + 
    #scale_x_discrete( expand = expansion(add=2)) +
    ggtitle( strTitle ) +
    labs(
      x = "Site ID", 
      y = paste("Inclusion/Exclusion Issues")
    ) +
    theme(
      panel.grid.major.x = element_blank(),
      axis.text.x = element_text(angle=90, vjust = 0.5), 
      legend.position="none"
    ) + 
    annotate(
      "text",
      x=notes$SiteID,
      y=notes$y,
      label = notes$Estimate,
      color= "red"
    )

  return(p)
}