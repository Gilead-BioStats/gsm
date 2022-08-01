#' Site-level visualization of scores.
#'
#' @param dfFlagged `data.frame` returned by [gsm::Flag()]
#' @param strType `character` One of `"KRI"` or `"score"`.
#' @param bFlagFilter `logical` Filter out non-flagged sites? Default: `FALSE`
#' @param strTitle Title of plot. NULL by default.
#'
#' @return site-level plot object.
#'
#' @examples
#' ae <- AE_Map_Raw() %>% AE_Assess(vThreshold = c(-8, 8))
#'
#' Visualize_Score(ae$dfFlagged) # visualize KRI (default)
#' Visualize_Score(ae$dfFlagged, bFlagFilter = TRUE) # drop non-flagged sites
#'
#' consent <- Consent_Map_Raw() %>% Consent_Assess()
#' Visualize_Score(consent$dfFlagged, strType = "score") # visualize score
#'
#' @import ggplot2
#' @importFrom stats reorder
#'
#' @export

Visualize_Score <- function(
    dfFlagged,
    strType = "KRI",
    bFlagFilter = FALSE,
    strTitle = ""
    ) {
  stopifnot(
    "strTitle must be character" = is.character(strTitle),
    "bFlagFilter must be logical" = is.logical(bFlagFilter),
    "dfFlagged must be a data.frame" = is.data.frame(dfFlagged),
    "strType must be 'KRI' or 'score'" = strType %in% c("KRI", "score"),
    "strType must be length 1" = length(strType) == 1
  )

  if(bFlagFilter) {
    dfFlagged <- dfFlagged %>%
      filter(
        .data$Flag != 0
        )
  }

  if(strType == "KRI") {

    dfFlaggedWithTooltip <- dfFlagged %>%
      mutate(
        tooltip = paste(
          paste0('Group: ', .data$GroupID),
          paste0('Exposure (days): ', format(.data$TotalExposure, big.mark = ',', trim = TRUE)),
          paste0('# of Events: ', format(.data$TotalCount, big.mark = ',', trim = TRUE)),
          sep = '\n'
        )
      )

    p <- dfFlaggedWithTooltip %>%
      ggplot(
        aes(
        x = reorder(.data$GroupID, -.data$KRI), y = .data$KRI),
        text = .data$tooltip
      ) +
      geom_bar(
        stat = "identity"
        ) +
      geom_hline(
        yintercept = sum(dfFlagged$TotalCount)/sum(dfFlagged$TotalExposure),
        linetype="dashed",
        color="red",
        size=1
      ) +
      ylab(
        paste0("KRI [", unique(dfFlagged$KRILabel), "]")
        )

  }

  if(strType == "score") {

    ThresholdLow <- unique(dfFlagged$ThresholdLow)
    ThresholdHigh <- unique(dfFlagged$ThresholdHigh)

    dfFlaggedWithTooltip <- dfFlagged %>%
      mutate(
        tooltip = paste(
          paste0('Group: ', .data$GroupID),
          paste0('ScoreLabel: ', .data$ScoreLabel),
          paste0('Score: ', .data$Score),
          sep = '\n'
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
        paste0("Score [", unique(dfFlagged$ScoreLabel), "]")
        )

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
    xlab(
      paste0("Group [", unique(dfFlagged$GroupLabel), "]")
      ) +
    theme_bw() +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
      panel.grid.major.x = element_blank(),
      legend.position = "none"
    ) +
    ggtitle(strTitle)

  if(nrow(dfFlaggedWithTooltip) > 25) {
    p <- p +
      theme(
        axis.ticks.x = element_blank()
      )
  }

  return(p)

}
