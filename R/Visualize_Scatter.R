#' Site-level visualization of site-level results using a Poisson or Wilcoxon model.
#'
#' @param dfFlagged analyze_poisson results with flags added.
#' @param dfBounds data.frame giving prediction bounds for range of dfFlagged.
#' @param strGroupCol name of stratification column for facet wrap (default=NULL)
#' @param strUnit exposure time unit. Defaults to "days".
#'
#' @return site-level plot object.
#'
#' @examples
#' dfInput <- AE_Map_Adam()
#' SafetyAE <- AE_Assess(dfInput)
#' dfBounds <- Analyze_Poisson_PredictBounds(SafetyAE$dfTransformed, c(-5, 5))
#' Visualize_Scatter(SafetyAE$dfFlagged, dfBounds)
#' 
#' SafetyAE_wilk <- AE_Assess(dfInput, strMethod = "wilcoxon")
#' Visualize_Scatter(SafetyAE_wilk$dfFlagged)
#'
#' # TODO: add stratified example
#'
#' @import ggplot2
#'
#' @export

Visualize_Scatter <- function(dfFlagged, dfBounds = NULL, strGroupCol = NULL, strUnit = "days") {
  # Define tooltip for use in plotly.
  dfFlaggedWithTooltip <- dfFlagged %>%
    mutate(
      tooltip = paste(
        paste0('Group: ', .data$GroupID),
        paste0('Exposure (days): ', format(.data$TotalExposure, big.mark = ',', trim = TRUE)),
        paste0('# of Events: ', format(.data$TotalCount, big.mark = ',', trim = TRUE)),
        sep = '\n'
      )
    )

  ### Plot of data
  p <- dfFlaggedWithTooltip %>%
    ggplot(
      aes(
        x = log(.data$TotalExposure),
        y = .data$TotalCount,
        color = as.factor(.data$Flag),
        text = .data$tooltip
      )
    ) +
    # Formatting
    theme_bw() +
    scale_x_continuous(
      breaks = log(c(5, 10, 50, 100, 500, 1000, 5000, 10000)),
      labels = c(5, 10, 50, 100, 500, 1000, 5000, 10000)
    ) +
    theme(legend.position = "none") +
    scale_color_manual(
      breaks = c("0", "-1", "1"),
      values = c("#999999", "red", "red")
    ) +
    # Add chart elements
    geom_point() +
    xlab(paste0("Site Total Exposure (", strUnit, " - log scale)")) +
    ylab("Site Total Events") +
    geom_text(
      data = dfFlaggedWithTooltip %>% filter(.data$Flag != 0),
      aes(x = log(.data$TotalExposure), y = .data$TotalCount, label = .data$GroupID),
      vjust = 1.5,
      col = "red",
      size = 3.5
    )

  if (!is.null(dfBounds)) {
    p <- p +
      geom_line(data = dfBounds, aes(x = .data$LogExposure, y = .data$MeanCount), color = "red", inherit.aes = FALSE) +
      geom_line(data = dfBounds, aes(x = .data$LogExposure, y = .data$LowerCount), color = "red", linetype = "dashed", inherit.aes = FALSE) +
      geom_line(data = dfBounds, aes(x = .data$LogExposure, y = .data$UpperCount), color = "red", linetype = "dashed", inherit.aes = FALSE)
  }

  if(!is.null(strGroupCol)){
    p<- p + facet_wrap(vars(.data[[strGroupCol]]))
  }

  return(p)
}
