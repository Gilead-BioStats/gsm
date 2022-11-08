#' Group-level visualization of group-level results using a Poisson or Wilcoxon model.
#'
#' @param dfFlagged analyze_poisson results with flags added.
#' @param dfBounds data.frame giving prediction bounds for range of dfFlagged.
#' @param strGroupCol name of stratification column for facet wrap (default=NULL)
#' @param strGroupLabel name of group, used for labeling axes.
#' @param strUnit exposure time unit. Defaults to "days".
#'
#' @return group-level plot object.
#'
#' @examples
#' dfInput <- AE_Map_Adam()
#' SafetyAE <- AE_Assess(dfInput)
#' dfBounds <- Analyze_Poisson_PredictBounds(SafetyAE$lData$dfTransformed, c(-5, 5))
#' Visualize_Scatter(SafetyAE$lData$dfFlagged, dfBounds)
#'
#'
#' # TODO: add stratified example
#'
#' @import ggplot2
#'
#' @export

Visualize_Scatter <- function(
  dfFlagged,
  dfBounds = NULL,
  strGroupCol = NULL,
  strGroupLabel = NULL,
  strUnit = "days"
) {

  groupLabel <- ifelse(
    is.null(strGroupLabel),
    "GroupID: ",
    strGroupLabel
  )
  # TODO: account for incomplete set of flags
  dfFlagged$FlagAbs <- abs(dfFlagged$Flag)
  flagBreaks <- as.character(unique(sort(dfFlagged$FlagAbs)))
  flagValues <- c("#999999", "#FADB14", "#FF4D4F")[1:length(flagBreaks)]

  # Define tooltip for use in plotly.
  dfFlaggedWithTooltip <- dfFlagged %>%
    mutate(
      tooltip = paste(
        paste0("Group: ", groupLabel),
        paste0("GroupID: ", .data$GroupID),
        paste0("Exposure (days): ", format(.data$Denominator, big.mark = ",", trim = TRUE)),
        paste0("# of Events: ", format(.data$Numerator, big.mark = ",", trim = TRUE)),
        sep = "\n"
      )
    )

  ### Plot of data
  p <- dfFlaggedWithTooltip %>%
    ggplot(
      aes(
        x = log(.data$Denominator),
        y = .data$Numerator,
        color = as.factor(.data$FlagAbs),
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
      breaks = flagBreaks,
      values = flagValues
    ) +
    # Add chart elements
    geom_point() +
    xlab(glue::glue("{groupLabel} Total (Denominator) ({strUnit} - log scale)")) +
    ylab(glue::glue("{groupLabel} Total (Numerator)"))

  if (!is.null(dfBounds)) {
    for (current_threshold in unique(dfBounds$Threshold)) {
      color <- case_when(
        current_threshold == 0 ~ "gray",
        current_threshold == min(unique(dfBounds$Threshold)) ~ "#FF4D4F",
        current_threshold == max(unique(dfBounds$Threshold)) ~ "#FF4D4F",
        TRUE ~ "#FADB14"
      )

      p <- p + geom_line(
        data = dfBounds %>% filter(.data$Threshold == current_threshold, !is.nan(.data$Numerator)),
        aes(x = .data$LogDenominator, y = .data$Numerator),
        color = color,
        inherit.aes = FALSE
      )
    }
  }

  p <- p +
    geom_text(
      data = dfFlaggedWithTooltip %>% filter(.data$FlagAbs != 0),
      aes(x = log(.data$Denominator), y = .data$Numerator, label = .data$GroupID),
      vjust = 1.5,
      col = "black",
      size = 3.5
    )

  if (!is.null(strGroupCol)) {
    p <- p + facet_wrap(vars(.data[[strGroupCol]]))
  }

  return(p)
}
