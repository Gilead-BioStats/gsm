#' Visualize Score
#'
#' @param dfFlagged
#' @param strType
#'
#' @return ggplot
#' @export

Visualize_Score <- function(dfFlagged, strType = "rate") {

  dfFlagged <- dfFlagged %>%
    filter(.data$Flag != 0)

  p <- ggplot(data = dfFlagged, aes(x = reorder(GroupID, -KRI), y = KRI)) +
    geom_bar(stat = "identity") +
    xlab("GroupID") +
    theme_bw()

  if(strType == "rate") {

    p <- p + geom_hline(
      yintercept = sum(dfFlagged$TotalCount)/sum(dfFlagged$TotalExposure),
      linetype="dashed",
      color="red",
      size=1
    )

  }

  if(strType == "score") {

    ThresholdLow <- unique(dfFlagged$ThresholdLow)
    ThresholdHigh <- unique(dfFlagged$ThresholdHigh)

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

  return(p)

}
