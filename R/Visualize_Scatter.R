#' Site-level visualization of site-level results using a Poisson or Wilcoxon model.
#'
#' @param dfFlagged analyze_poisson results with flags added.
#' @param dfBounds data.frame giving prediction bounds for range of dfFlagged.
#' @param strUnit exposure time unit. Defaults to "days".
#'
#' @return site level plot object
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
#' @import ggplot2
#'
#' @export
Visualize_Scatter <- function(dfFlagged, dfBounds = NULL, strUnit = "days") {

  ### Plot of data
  p <- ggplot(
    dfFlagged,
    aes(
      x = log(.data$TotalExposure),
      y = .data$TotalCount,
      color = as.factor(.data$Flag)
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
      data = dfFlagged %>% filter(.data$Flag != 0),
      aes(x = log(.data$TotalExposure), y = .data$TotalCount, label = .data$SiteID),
      vjust = 1.5,
      col = "red",
      size = 3.5
    )

  if (!is.null(dfBounds)) {
    p <- p +
      geom_line(data = dfBounds, aes(x = .data$LogExposure, y = .data$MeanCount), color = "red") +
      geom_line(data = dfBounds, aes(x = .data$LogExposure, y = .data$LowerCount), color = "red", linetype = "dashed") +
      geom_line(data = dfBounds, aes(x = .data$LogExposure, y = .data$UpperCount), color = "red", linetype = "dashed")
  }

  return(p)
}
