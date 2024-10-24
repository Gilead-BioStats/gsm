`%|0|%` <- function(x, y) {
  if (length(x)) {
    return(x)
  } else {
    return(y)
  }
}

stop_if_empty <- function(x, x_arg = rlang::caller_arg(x)) {
  if (!length(x)) {
    cli::cli_abort(
      "{.arg {x_arg}} must not be `NULL`.",
      class = "gsm_error-null_arg"
    )
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
      cli::cli_abort(c(
        "{.arg {arg_name}} must contain a {.var SnapshotDate} column."
      ))
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
#' @param df A data frame containing the results.
#'
#' @return A data frame containing the results with at least one flagged record
#' over time for an group's individual metric
#'
#' @examples
#' reportingResults_flags <- FilterByFlags(reportingResults)
#'
#' @export
FilterByFlags <- function(df) {
  df %>%
    group_by(.data$GroupID, .data$MetricID) %>%
    mutate(flagsum = sum(.data$Flag)) %>%
    ungroup() %>%
    filter(.data$flagsum != 0 | is.na(.data$flagsum)) %>%
    select(-"flagsum")
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
        tidyselect::all_of(c("GroupID", "Param", "Value"))
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
