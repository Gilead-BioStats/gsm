#' Summarize flags by SnapshotDate
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Create a table of longitudinal study data by site, study, or
#' country, showing flags over time.
#'
#' @inheritParams shared-params
#' @param strGroupLevel A string specifying the group type.
#'
#' @inherit gt-shared return
#' @export
Report_FlagOverTime <- function(
  dfResults,
  dfMetrics,
  strGroupLevel = c("Site", "Study", "Country")
) {
  strGroupLevel <- rlang::arg_match(strGroupLevel)
  dfFlagOverTime <- dfResults %>%
    dplyr::filter(.data$GroupLevel == strGroupLevel) %>%
    flag_changes() %>%
    widen_results(dfMetrics, strGroupLevel)

  date_cols <- stringr::str_which(
    colnames(dfFlagOverTime),
    r"(\d{4}-\d{2}-\d{2})"
  )

  dfFlagOverTime %>%
    dplyr::group_by(.data$GroupLevel, .data$GroupID) %>%
    gsm_gt() %>%
    fmt_flag_rag(columns = date_cols) %>%
    fmt_present(columns = "FlagChange") %>%
    gt::cols_label(FlagChange = "New Flag?") %>%
    gt::tab_header(
      title = "Flags Over Time"
    ) %>%
    gt::opt_align_table_header(align = "left")
}

flag_changes <- function(dfResults) {
  dfResults %>%
    dplyr::mutate(
      FlagPrevious = dplyr::lag(.data$Flag, order_by = .data$SnapshotDate),
      .by = c("GroupID", "MetricID")
    ) %>%
    dplyr::mutate(
      FlagChange = !is.na(.data$Flag) &
        !is.na(.data$FlagPrevious) &
        .data$Flag != .data$FlagPrevious
    ) %>%
    dplyr::select(-"FlagPrevious")
}

widen_results <- function(dfResults, dfMetrics, strGroupLevel) {
  dfMetrics_join <- dfMetrics %>%
    dplyr::mutate(GroupLevel = stringr::str_to_sentence(.data$GroupLevel)) %>%
    dplyr::filter(.data$GroupLevel == strGroupLevel) %>%
    dplyr::select(
      "MetricID",
      "Abbreviation",
      "GroupLevel"
    )
  dfFlagOverTime <- dfResults %>%
    dplyr::mutate(GroupLevel = stringr::str_to_sentence(.data$GroupLevel)) %>%
    dplyr::inner_join(dfMetrics_join, by = c("MetricID", "GroupLevel")) %>%
    dplyr::select(
      "GroupLevel",
      "GroupID",
      "MetricID",
      "Abbreviation",
      "SnapshotDate",
      "Flag",
      "FlagChange"
    ) %>%
    dplyr::arrange(.data$SnapshotDate) %>%
    # Use the most recent `FlagChange`
    dplyr::mutate(
      FlagChange = dplyr::last(.data$FlagChange),
      .by = c("GroupID", "MetricID")
    ) %>%
    tidyr::pivot_wider(names_from = "SnapshotDate", values_from = "Flag") %>%
    dplyr::arrange(.data$GroupID, .data$MetricID)

  return(dfFlagOverTime)
}

fmt_flag_rag <- function(data, columns = gt::everything()) {
  fmt_sign(data, columns = columns) %>%
    cols_label_month(columns = columns)
}
