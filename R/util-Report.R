`%|0|%` <- function(x, y) {
  if (length(x)) {
    return(x)
  } else {
    return(y)
  }
}

stop_if <- function(cnd, message) {
  if (cnd) {
    LogMessage(level = "error", message = message)
  }
}

#' Filter by Latest Snapshot Date
#'
#' Filter a data frame to the most recent snapshot date.
#'
#' @param df A data frame containing the results.
#' @param strSnapshotDate A character string representing the snapshot date.
#'
#' @return A data frame containing the results for the most recent snapshot date.
#'
#' @examples
#' reportingResults_latest <- FilterByLatestSnapshotDate(reportingResults)
#'
#' @export

FilterByLatestSnapshotDate <- function(df, strSnapshotDate = NULL) {
  if (!nrow(df)) {
    return(df)
  }
  if (!length(df$SnapshotDate)) {
    if (length(strSnapshotDate)) {
      arg_name <- rlang::caller_arg(df)
      LogMessage(
        level = "fatal",
        message = "`{arg_name}` must contain a `SnapshotDate` column."
      )
    }
    return(df)
  }
  # use most recent snapshot date if strSnapshotDate is missing
  strSnapshotDate <- as.Date(strSnapshotDate) %|0|% max(df$SnapshotDate)
  df$SnapshotDate <- as.Date(df$SnapshotDate)
  return(dplyr::filter(df, .data$SnapshotDate == strSnapshotDate))
}

#' Filter out non-flagged rows on FlagOverTime Widget
#'
#' Filter a results dataframe so that only metrics across all timepoints
#' that have at least one flag are kept
#'
#' @param dfResults `data.frame` Analysis results data.
#' @param bCurrentlyFlagged `logical` Include risk signals flagged in most recent snapshot?
#' Default: `FALSE`.
#'
#' @return A data frame containing the results with at least one flagged record over time for an
#' group's individual metric
#'
#' @examples
#' reportingResults_flags <- FilterByFlags(reportingResults)
#'
#' @export

FilterByFlags <- function(
    dfResults,
    bCurrentlyFlagged = FALSE
) {
  dfResultsFlagged <- dfResults %>%
    group_by(.data$GroupID, .data$MetricID) %>%
    mutate(
        flagsum = sum(abs(.data$Flag), na.rm = TRUE),
        flaglatest = Flag[SnapshotDate == max(SnapshotDate)]
    ) %>%
    ungroup() %>%
    filter(
      .data$flagsum > 0
    )

    if (bCurrentlyFlagged) {
      dfResultsFlagged <- dfResultsFlagged %>%
        filter(
            .data$flaglatest != 0
        )
    }

    dfResultsFlagged <- dfResultsFlagged %>%
        select(-all_of(c(
            'flagsum', 'flaglatest'
        )))

    return(dfResultsFlagged)
}

add_Groups_metadata <- function(
  dfResults,
  dfGroups,
  strGroupLevel = c("Site", "Study", "Country"),
  strGroupDetailsParams
) {
  if (nrow(dfResults)) {
    strGroupLevel <- rlang::arg_match(strGroupLevel)
    dfGroups_wide <- widen_dfGroups(dfGroups, strGroupLevel, strGroupDetailsParams)
    if (nrow(dfGroups)) {
      dfResults <- dplyr::left_join(
        dfResults,
        dfGroups_wide,
        by = "GroupID"
      )
    }
  }
  return(dfResults)
}

widen_dfGroups <- function(dfGroups, strGroupLevel, strGroupDetailsParams) {
  # Subset on the specified group level and columns.
  dfGroupsSubset <- dfGroups %>%
    dplyr::filter(
      .data$GroupLevel == strGroupLevel
    ) %>%
    dplyr::select(
      dplyr::all_of(c("GroupID", "Param", "Value"))
    )
  if (nrow(dfGroupsSubset)) {
    if (is.null(strGroupDetailsParams)) {
      if (strGroupLevel == "Site") {
        strGroupDetailsParams <- c(
          "Country", "Status", "InvestigatorLastName", "ParticipantCount"
        )
      } else if (strGroupLevel == "Country") {
        strGroupDetailsParams <- c("SiteCount", "ParticipantCount")
      }
    }
    dfGroupsWide <- dfGroupsSubset %>%
      dplyr::filter(.data$Param %in% strGroupDetailsParams) %>%
      tidyr::pivot_wider(
        id_cols = "GroupID",
        names_from = "Param",
        values_from = "Value"
      ) %>%
      dplyr::mutate(
        dplyr::across(
          dplyr::any_of(c("ParticipantCount", "SiteCount")),
          as.integer
        )
      )
  }
  return(dfGroupsWide)
}

colorScheme <- function(
  color_name = c("gray", "green", "amber", "red"),
  color_family = c("light", "dark")
) {
  color_name <- rlang::arg_match(color_name)
  color_family <- rlang::arg_match(color_family)
  colors <- list(
    light = c(
      red = "#FF0040",
      amber = "#FFBF00",
      green = "#52C41A",
      gray = "#AAAAAA"
    ),
    dark = c(
      red = "#FF5859",
      amber = "#FEAA02",
      green = "#3DAF06",
      gray = "#828282"
    )
  )
  colors[[color_family]][[color_name]]
}
