function(
    dfSummary, dfBounds = NULL, strGroupCol = NULL, strGroupLabel = NULL,
    strUnit = "days", vColors = c("#999999", "#FADB14", "#FF4D4F")) {
  groupLabel <- ifelse(is.null(strGroupLabel), "GroupID: ",
    strGroupLabel
  )
  dfSummaryWithTooltip <- dfSummary %>%
    filter(!is.na(Flag)) %>%
    mutate(tooltip = paste(paste0("Group: ", groupLabel),
      paste0("GroupID: ", .data$GroupID), paste0(
        "Exposure (days): ",
        format(.data$Denominator, big.mark = ",", trim = TRUE)
      ),
      paste0("# of Events: ", format(.data$Numerator,
        big.mark = ",",
        trim = TRUE
      )),
      sep = "\n"
    ))
  if (nrow(dfSummaryWithTooltip) == 0) {
    return(NULL)
  }
  dfSummaryWithTooltip$FlagAbs <- abs(dfSummaryWithTooltip$Flag)
  maxFlag <- max(dfSummaryWithTooltip$FlagAbs)
  flagBreaks <- as.character(seq(0, maxFlag))
  flagValues <- vColors[1:length(flagBreaks)]
  p <- dfSummaryWithTooltip %>% ggplot(aes(
    x = log(.data$Denominator),
    y = .data$Numerator, color = as.factor(.data$FlagAbs),
    text = .data$tooltip
  )) +
    theme_bw() +
    scale_x_continuous(breaks = log(c(
      5,
      10, 50, 100, 500, 1000, 5000, 10000
    )), labels = c(
      5,
      10, 50, 100, 500, 1000, 5000, 10000
    )) +
    theme(legend.position = "none") +
    scale_color_manual(breaks = flagBreaks, values = flagValues) +
    geom_point() +
    xlab(glue::glue("{groupLabel} Total (Denominator) ({strUnit} - log scale)")) +
    ylab(glue::glue("{groupLabel} Total (Numerator)"))
  if (!is.null(dfBounds)) {
    dfBounds$ThresholdAbs <- abs(dfBounds$Threshold)
    thresholds <- unique(dfBounds$Threshold) %>% sort()
    thresholdAbs <- unique(dfBounds$ThresholdAbs) %>% sort()
    for (i in seq_along(thresholds)) {
      threshold <- thresholds[i]
      thresholdAb <- thresholdAbs[thresholdAbs == abs(threshold)]
      color <- vColors[match(thresholdAb, thresholdAbs)]
      p <- p + geom_line(data = dfBounds %>% filter(.data$Threshold ==
        threshold, !is.nan(.data$Numerator)), aes(
        x = .data$LogDenominator,
        y = .data$Numerator
      ), color = color, inherit.aes = FALSE)
    }
  }
  p <- p + geom_text(data = dfSummaryWithTooltip %>% filter(.data$FlagAbs !=
    0), aes(
    x = log(.data$Denominator), y = .data$Numerator,
    label = .data$GroupID
  ), vjust = 1.5, col = "black", size = 3.5)
  if (!is.null(strGroupCol)) {
    p <- p + facet_wrap(vars(.data[[strGroupCol]]))
  }
  return(p)
}
