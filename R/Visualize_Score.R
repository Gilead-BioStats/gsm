#' Group-level visualization of scores.
#'
#' `r lifecycle::badge("stable")`
#'
#' @inheritParams shared-params
#' @param vThreshold `numeric` Threshold specification, a vector of length 2 that defaults to NULL.
#' @param strType `character` One of `"KRI"` or `"score"`.
#' @param bFlagFilter `logical` Filter out non-flagged groups? Default: `FALSE`
#' @param strTitle `character` Title of plot.
#'
#' @return group-level ggplot2 object.
#'
#' @examples
#' \dontrun{
#' lData <- UseClindata(
#'   list(
#'     "dfSUBJ" = "clindata::rawplus_dm",
#'     "dfAE" = "clindata::rawplus_ae",
#'     "dfPD" = "clindata::ctms_protdev",
#'     "dfCONSENT" = "clindata::rawplus_consent",
#'     "dfIE" = "clindata::rawplus_ie",
#'     "dfLB" = "clindata::rawplus_lb",
#'     "dfSTUDCOMP" = "clindata::rawplus_studcomp",
#'     "dfSDRGCOMP" = "clindata::rawplus_sdrgcomp %>%
#'           dplyr::filter(.data$phase == 'Blinded Study Drug Completion')",
#'     "dfDATACHG" = "clindata::edc_data_points",
#'     "dfDATAENT" = "clindata::edc_data_pages",
#'     "dfQUERY" = "clindata::edc_queries",
#'     "dfENROLL" = "clindata::rawplus_enroll"
#'   )
#' )
#' wf_mapping <- MakeWorkflowList("mapping")
#' ae_workflow <- MakeWorkflowList(strNames = "kri0001")
#' lMapped <- RunWorkflow(wf_mapping, lData)$lData
#' AE <- map(ae_workflow, ~ RunWorkflow(., lMapped))
#' Visualize_Score(AE$kri0001$lData$dfSummary, dfBounds)
#' }
#' @export

Visualize_Score <- function(
  dfResults,
  vThreshold = NULL,
  strType = "Metric",
  bFlagFilter = FALSE,
  strTitle = ""
) {
  stopifnot(
    "strTitle must be character" = is.character(strTitle),
    "bFlagFilter must be logical" = is.logical(bFlagFilter),
    "dfResults must be a data.frame" = is.data.frame(dfResults),
    "strType must be 'Metric' or 'Score'" = strType %in% c("Metric", "Score"),
    "strType must be length 1" = length(strType) == 1
  )

  dfResults$FlagAbs <- abs(dfResults$Flag)
  flagBreaks <- as.character(unique(sort(dfResults$FlagAbs)))
  flagValues <- c("#999999", "#FADB14", "#FF4D4F")[1:length(flagBreaks)]

  if (bFlagFilter) {
    dfResults <- dfResults %>%
      filter(
        .data$Flag != 0
      )
  }

  if (strType == "Metric") {
    dfResultsWithTooltip <- dfResults %>%
      mutate(
        tooltip = paste(
          paste0("GroupID: ", .data$GroupID),
          paste(.data$Metric),
          sep = "\n"
        )
      )

    p <- dfResultsWithTooltip %>%
      ggplot(
        aes(
          x = reorder(.data$GroupID, -.data$Metric),
          y = .data$Metric,
          fill = as.factor(.data$FlagAbs),
          text = .data$tooltip
        )
      ) +
      geom_bar(
        stat = "identity"
      ) +
      scale_fill_manual(
        breaks = flagBreaks,
        values = flagValues
      ) +
      ylab(
        "Metric"
      )

    if (all(c("Numerator", "Denominator") %in% names(dfResults))) {
      p <- p +
        geom_hline(
          yintercept = sum(dfResults$Numerator) / sum(dfResults$Denominator),
          linetype = "dashed",
          color = "#FF4D4F"
        )
    }
  }

  if (strType == "Score") {
    if (!is.null(vThreshold)) {
      ThresholdLow <- min(vThreshold)
      ThresholdHigh <- max(vThreshold)
    } else {
      ThresholdLow <- NA
      ThresholdHigh <- NA
    }


    dfResultsWithTooltip <- dfResults %>%
      mutate(
        tooltip = paste(
          paste0("GroupID: ", .data$GroupID),
          paste("Score", " = ", .data$Score),
          sep = "\n"
        )
      )

    p <- dfResultsWithTooltip %>%
      ggplot(
        aes(
          x = reorder(.data$GroupID, -.data$Score),
          y = .data$Score,
          fill = as.factor(.data$FlagAbs),
          tooltip = .data$tooltip
        )
      ) +
      geom_bar(
        stat = "identity"
      ) +
      scale_fill_manual(
        breaks = flagBreaks,
        values = flagValues
      ) +
      ylab(
        "Score"
      )

    if (!is.na(ThresholdLow)) {
      p <- p +
        geom_hline(
          yintercept = ThresholdLow,
          linetype = "dashed",
          color = "#FF4D4F",
          linewidth = 1
        )
    }

    if (!is.na(ThresholdHigh)) {
      p <- p +
        geom_hline(
          yintercept = ThresholdHigh,
          linetype = "dashed",
          color = "#FF4D4F",
          linewidth = 1
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

  if (nrow(dfResultsWithTooltip) > 25) {
    p <- p +
      theme(
        axis.ticks.x = element_blank()
      )
  }

  return(p)
}
