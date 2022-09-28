#' Group-level visualization of scores.
#'
#' @param dfFlagged `data.frame` returned by [gsm::Flag()]
#' @param vThreshold `numeric` Threshold specification, a vector of length 2 that defaults to NULL.
#' @param strType `character` One of `"KRI"` or `"score"`.
#' @param bFlagFilter `logical` Filter out non-flagged groups? Default: `FALSE`
#' @param strTitle Title of plot. NULL by default.
#'
#' @return group-level plot object.
#'
#' @examples
#' ae <- AE_Map_Raw() %>% AE_Assess(vThreshold = c(-8, 8))
#'
#' Visualize_Score(ae$lData$dfFlagged) # visualize KRI (default)
#' Visualize_Score(ae$lData$dfFlagged, bFlagFilter = TRUE) # drop non-flagged groups
#'
#' consent <- Consent_Map_Raw() %>% Consent_Assess()
#' Visualize_Score(consent$lData$dfFlagged, strType = "score") # visualize score
#'
#' @import ggplot2
#' @importFrom stats reorder
#'
#' @export

Visualize_Score <- function(
  dfFlagged,
  vThreshold = NULL,
  strType = "metric",
  bFlagFilter = FALSE,
  strTitle = ""
) {
  stopifnot(
    "strTitle must be character" = is.character(strTitle),
    "bFlagFilter must be logical" = is.logical(bFlagFilter),
    "dfFlagged must be a data.frame" = is.data.frame(dfFlagged),
    "strType must be 'metric' or 'score'" = strType %in% c("metric", "score"),
    "strType must be length 1" = length(strType) == 1
  )

  if (bFlagFilter) {
    dfFlagged <- dfFlagged %>%
      filter(
        .data$Flag != 0
      )
  }

  if (strType == "metric") {
    dfFlaggedWithTooltip <- dfFlagged %>%
      mutate(
        tooltip = paste(
          paste0("GroupID: ", .data$GroupID),
          paste(.data$Metric),
          sep = "\n"
        )
      )

    p <- dfFlaggedWithTooltip %>%
      ggplot(
        aes(
          x = reorder(.data$GroupID, -.data$Metric), y = .data$Metric,
          text = .data$tooltip
        )
      ) +
      geom_bar(
        stat = "identity"
      ) +
      geom_hline(
        yintercept = sum(dfFlagged$Numerator) / sum(dfFlagged$Denominator),
        linetype = "dashed",
        color = "red",
        size = 1
      ) +
      ylab(
        "Metric"
      )
  }

  if (strType == "score") {

    if (!is.null(vThreshold)) {
      ThresholdLow <- min(vThreshold)
      ThresholdHigh <- max(vThreshold)
    } else {
      ThresholdLow <- NA
      ThresholdHigh <- NA
    }


    dfFlaggedWithTooltip <- dfFlagged %>%
      mutate(
        tooltip = paste(
          paste0("GroupID: ", .data$GroupID),
          paste("Score", " = ", .data$Score),
          sep = "\n"
        )
      )

    p <- dfFlaggedWithTooltip %>%
      ggplot(
        aes(
          x = reorder(.data$GroupID, -.data$Score), y = .data$Score,
          tooltip = .data$tooltip
        )
      ) +
      geom_bar(
        stat = "identity"
      ) +
      ylab(
        "Score"
      )

    if (!is.na(ThresholdLow)) {
      p <- p +
        geom_hline(
          yintercept = ThresholdLow,
          linetype = "dashed",
          color = "red",
          size = 1
        )
    }

    if (!is.na(ThresholdHigh)) {
      p <- p +
        geom_hline(
          yintercept = ThresholdHigh,
          linetype = "dashed",
          color = "red",
          size = 1
        )
    }
  }

  p <- p +
    xlab(
      "Group"
    ) +
    theme_bw() +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
      panel.grid.major.x = element_blank(),
      legend.position = "none"
    ) +
    ggtitle(strTitle)

  if (nrow(dfFlaggedWithTooltip) > 25) {
    p <- p +
      theme(
        axis.ticks.x = element_blank()
      )
  }

  return(p)
}
