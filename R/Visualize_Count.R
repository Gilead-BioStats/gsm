#' Site-level visualization of site-level Inclusion/Exclusion results
#'
#' @param dfInput Map results from IE or Consent assessments.
#' @param strTitle Title of plot. NULL by default.
#'
#' @return site level plot object
#'
#' @examples
#' dfInput <- IE_Map_Raw(clindata::raw_ie_all,
#'                       clindata::rawplus_rdsl,
#'                       strCategoryCol = "IECAT_STD",
#'                       strResultCol = "IEORRES")
#'
#' @import ggplot2
#' @importFrom stats reorder
#'
#' @export
Visualize_Count <- function(dfInput, strTitle = NULL) {

dfPlot <- dfInput %>%
  group_by(.data$SiteID) %>%
  summarize(SiteID = unique(.data$SiteID),
            N = sum(.data$Total),
            Valid = sum(.data$Valid),
            Invalid = sum(.data$Invalid),
            Missing = sum(.data$Missing),
            Count = sum(.data$Count))

p <- ggplot(data = dfPlot,
            aes(x = reorder(.data$SiteID, -.data$N))
            ) +
  geom_bar(aes(y = .data$N), stat = "identity", color = "black", fill = "white") +
  geom_bar(aes(y = .data$Invalid), stat = "identity", fill = "red") +
  ggtitle(strTitle) +
  labs(
    x = "Site ID",
    y = "Inclusion/Exclusion Issues"
  ) +
  theme(
    panel.grid.major.x = element_blank(),
    axis.text.x = element_text(angle=90, vjust = 0.5),
    legend.position="none"
  )

return(p)
}
