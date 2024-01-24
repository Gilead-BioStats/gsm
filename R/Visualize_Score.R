function(
    dfSummary, vThreshold = NULL, strType = "metric", bFlagFilter = FALSE,
    strTitle = "") {
  stopifnot(
    `strTitle must be character` = is.character(strTitle),
    `bFlagFilter must be logical` = is.logical(bFlagFilter),
    `dfSummary must be a data.frame` = is.data.frame(dfSummary),
    `strType must be 'metric' or 'score'` = strType %in%
      c("metric", "score"), `strType must be length 1` = length(strType) ==
      1
  )
  dfSummary$FlagAbs <- abs(dfSummary$Flag)
  flagBreaks <- as.character(unique(sort(dfSummary$FlagAbs)))
  flagValues <- c("#999999", "#FADB14", "#FF4D4F")[1:length(flagBreaks)]
  if (bFlagFilter) {
    dfSummary <- dfSummary %>% filter(.data$Flag != 0)
  }
  if (strType == "metric") {
    dfSummaryWithTooltip <- dfSummary %>% mutate(tooltip = paste(paste0(
      "GroupID: ",
      .data$GroupID
    ), paste(.data$Metric), sep = "\n"))
    p <- dfSummaryWithTooltip %>% ggplot(aes(
      x = reorder(
        .data$GroupID,
        -.data$Metric
      ), y = .data$Metric, fill = as.factor(.data$FlagAbs),
      text = .data$tooltip
    )) +
      geom_bar(stat = "identity") +
      scale_fill_manual(breaks = flagBreaks, values = flagValues) +
      ylab("Metric")
    if (all(c("Numerator", "Denominator") %in% names(dfSummary))) {
      p <- p + geom_hline(
        yintercept = sum(dfSummary$Numerator) / sum(dfSummary$Denominator),
        linetype = "dashed", color = "#FF4D4F"
      )
    }
  }
  if (strType == "score") {
    if (!is.null(vThreshold)) {
      ThresholdLow <- min(vThreshold)
      ThresholdHigh <- max(vThreshold)
    } else {
      ThresholdLow <- NA
      ThresholdHigh <- NA
    }
    dfSummaryWithTooltip <- dfSummary %>% mutate(tooltip = paste(
      paste0(
        "GroupID: ",
        .data$GroupID
      ), paste("Score", " = ", .data$Score),
      sep = "\n"
    ))
    p <- dfSummaryWithTooltip %>% ggplot(aes(
      x = reorder(
        .data$GroupID,
        -.data$Score
      ), y = .data$Score, fill = as.factor(.data$FlagAbs),
      tooltip = .data$tooltip
    )) +
      geom_bar(stat = "identity") +
      scale_fill_manual(breaks = flagBreaks, values = flagValues) +
      ylab("Score")
    if (!is.na(ThresholdLow)) {
      p <- p + geom_hline(
        yintercept = ThresholdLow, linetype = "dashed",
        color = "#FF4D4F", linewidth = 1
      )
    }
    if (!is.na(ThresholdHigh)) {
      p <- p + geom_hline(
        yintercept = ThresholdHigh, linetype = "dashed",
        color = "#FF4D4F", linewidth = 1
      )
    }
  }
  p <- p + xlab("Group") + theme_bw() + theme(
    axis.text.x = element_text(
      angle = 90,
      vjust = 0.5, hjust = 1
    ), panel.grid.major.x = element_blank(),
    legend.position = "none"
  ) + ggtitle(strTitle)
  if (nrow(dfSummaryWithTooltip) > 25) {
    p <- p + theme(axis.ticks.x = element_blank())
  }
  return(p)
}
