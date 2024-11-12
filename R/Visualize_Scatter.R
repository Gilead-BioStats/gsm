#' Group-level visualization of group-level results
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' @inheritParams shared-params
#' @param strGroupCol `character` name of stratification column for facet wrap Default: `NULL`
#' @param strGroupLabel `character` name of group, used for labeling axes. Default: `NULL`
#' @param strUnit `character` exposure time unit. Default: `days`
#' @param vColors `character` vector of hex colors for plotting boundaries/thresholds. Index 1: mean; index 2: first threshold boundary; index 3: second threshold boundary.
#'
#' @return group-level plot object.
#'
#' @examples
#'
#' ## Filter sample data to only one metric
#' reportingResults_filter <- reportingResults %>%
#'   dplyr::filter(MetricID == "Analysis_kri0001")
#'
#' reportingBounds_filter <- reportingBounds %>%
#'   dplyr::filter(MetricID == "Analysis_kri0001")
#'
#' ## Output- filtered to one snapshot date
#' Visualize_Scatter(
#'   dfResults = reportingResults_filter %>%
#'     dplyr::filter(SnapshotDate == max(SnapshotDate)),
#'   dfBounds = reportingBounds_filter %>%
#'     dplyr::filter(SnapshotDate == max(SnapshotDate))
#' )
#'
#' ## Create Faceted output on snapshot date
#' Visualize_Scatter(
#'   dfResults = reportingResults_filter,
#'   dfBounds = reportingBounds_filter,
#'   strGroupCol = "SnapshotDate",
#'   strGroupLabel = "Snapshot Date"
#' )
#'
#' ## Custom Colors
#' Visualize_Scatter(
#'   dfResults = reportingResults_filter %>%
#'     dplyr::filter(SnapshotDate == max(SnapshotDate)),
#'   dfBounds = reportingBounds_filter %>%
#'     dplyr::filter(SnapshotDate == max(SnapshotDate)),
#'   vColors = c("#F4E7E7", "#C17070", "#981212")
#' )
#'
#' @export

Visualize_Scatter <- function(
  dfResults,
  dfBounds = NULL,
  strGroupCol = NULL,
  strGroupLabel = NULL,
  strUnit = "days",
  vColors = c("#999999", "#FADB14", "#FF4D4F")
) {
  groupLabel <- ifelse(
    is.null(strGroupLabel),
    "GroupID: ",
    strGroupLabel
  )

  # Remove `NA` flags and define tooltip for use in plotly.
  dfResultsWithTooltip <- dfResults %>%
    filter(
      !is.na(Flag)
    ) %>%
    mutate(
      tooltip = paste(
        paste0("Group: ", groupLabel),
        paste0("GroupID: ", .data$GroupID),
        paste0("Exposure (days): ", format(.data$Denominator, big.mark = ",", trim = TRUE)),
        paste0("# of Events: ", format(.data$Numerator, big.mark = ",", trim = TRUE)),
        sep = "\n"
      )
    )

  # Avoid plotting empty datasets

  if (nrow(dfResultsWithTooltip) == 0) {
    return(NULL)
  }


  # Account for incomplete set of flags
  dfResultsWithTooltip$FlagAbs <- abs(dfResultsWithTooltip$Flag)
  maxFlag <- max(dfResultsWithTooltip$FlagAbs)
  flagBreaks <- as.character(seq(0, maxFlag))
  flagValues <- vColors[1:length(flagBreaks)]

  ### Plot of data
  p <- dfResultsWithTooltip %>%
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

  # Add bound lines one at a time.
  if (!is.null(dfBounds)) {
    dfBounds$ThresholdAbs <- abs(dfBounds$Threshold)
    thresholds <- unique(dfBounds$Threshold) %>% sort()
    thresholdAbs <- unique(dfBounds$ThresholdAbs) %>% sort()

    for (i in seq_along(thresholds)) {
      threshold <- thresholds[i]
      thresholdAb <- thresholdAbs[thresholdAbs == abs(threshold)]
      color <- vColors[match(thresholdAb, thresholdAbs)]

      p <- p + geom_line(
        data = dfBounds %>%
          filter(
            .data$Threshold == threshold,
            !is.nan(.data$Numerator)
          ),
        aes(
          x = .data$LogDenominator,
          y = .data$Numerator
        ),
        color = color,
        inherit.aes = FALSE
      )
    }
  }

  p <- p +
    geom_text(
      data = dfResultsWithTooltip %>% filter(.data$FlagAbs != 0),
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
