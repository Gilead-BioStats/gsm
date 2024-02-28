#' make plot data for bar chart
#'
#' @param dfInput `data.frame` data created with
#' @param strGroup `string` Site or Study level specification
#'
#' @export
#'
#' @keywords internal
Make_Plot_Data <- function(dfInput, strGroup){
  if(!strGroup %in% c("Study", "Site")){
    stop("strGroup must be either 'Study' or 'Site'")
  }
  if(strGroup == "Study"){
    plot_data <- dfInput %>%
      filter(!is.empty(`Discontinuation Reason`)) %>%
      group_by(`Discontinuation Reason`) %>%
      summarise(disc = n())
  } else if (strGroup == "Site") {
    plot_data <- dfInput %>%
      filter(!is.empty(`Discontinuation Reason`)) %>%
      group_by(`Site ID`, `Discontinuation Reason`) %>%
      summarise(disc = n()) %>%
      group_by(`Site ID`) %>%
      mutate(total = sum(disc))
  }
  return(plot_data)
}
