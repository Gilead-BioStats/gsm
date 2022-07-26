#' Site-level visualization of site-level scores.
#'
#' @param dfFlagged
#' @param strType
#'
#' @return ggplot
#' @export

Visualize_Score <- function(dfFlagged, strType = "KRI") {

  dfFlagged <- dfFlagged

  # %>%
  #   filter(.data$Flag != 0)



  if(strType == "KRI") {

    p <- ggplot(data = dfFlagged, aes(x = reorder(GroupID, -KRI), y = KRI)) +
      geom_bar(stat = "identity") +
      geom_hline(
        yintercept = sum(dfFlagged$TotalCount)/sum(dfFlagged$TotalExposure),
        linetype="dashed",
        color="red",
        size=1
      ) +
      ylab(paste0("KRI [", unique(dfFlagged$KRILabel), "]"))

  }

  if(strType == "score") {

    ThresholdLow <- unique(dfFlagged$ThresholdLow)
    ThresholdHigh <- unique(dfFlagged$ThresholdHigh)

    p <- ggplot(data = dfFlagged, aes(x = reorder(GroupID, -Score), y = Score)) +
      geom_bar(stat = "identity") +
      ylab(paste0("Score [", unique(dfFlagged$ScoreLabel), "]"))

    if(!is.na(ThresholdLow)) {

      p <- p +
        geom_hline(
          yintercept = unique(dfFlagged$ThresholdLow),
          linetype = "dashed",
          color = "red",
          size = 1
        )

    }

    if(!is.na(ThresholdHigh)) {

      p <- p +
        geom_hline(
          yintercept = unique(dfFlagged$ThresholdHigh),
          linetype = "dashed",
          color = "red",
          size = 1
        )
    }

  }

  p <- p +
    xlab(paste0("Group [", unique(dfFlagged$GroupLabel), "]")) +
    theme_bw() +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
      panel.grid.major.x = element_blank(),
      legend.position = "none"
    )

  return(p)

}
