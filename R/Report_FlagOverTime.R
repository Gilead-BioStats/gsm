#' Summarize flags by SnapshotDate
#'
#' `r lifecycle::badge("experimental")`
#'
#' Create a table of longitudinal study data by site, study, or country, showing
#' flags over time.
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
  dfFlagOverTime <- widen_results(dfResults, dfMetrics, strGroupLevel)
  date_cols <- stringr::str_which(
    colnames(dfFlagOverTime),
    r"(\d{4}-\d{2}-\d{2})"
  )

  dfFlagOverTime %>%
    dplyr::group_by(.data$GroupLevel, .data$GroupID) %>%
    gsm_gt() %>%
    fmt_flag_rag(columns = date_cols) %>%
    gt::tab_header(
      title = "Flags Over Time"
    ) %>%
    gt::opt_align_table_header(align = "left")
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
      "Flag"
    )
  dfFlagOverTime <- dfFlagOverTime %>%
    dplyr::arrange(.data$SnapshotDate) %>%
    tidyr::pivot_wider(names_from = "SnapshotDate", values_from = "Flag") %>%
    dplyr::arrange(.data$GroupID, .data$MetricID)
  
  # if `FlagChange` is present, get the value from the most recent SnapshotDate
  if ("FlagChange" %in% colnames(dfResults)) {
    dfFlagChange <- dfResults %>%
      dplyr::select(
        "GroupID",
        "MetricID",
        "SnapshotDate",
        "FlagChange"
      ) %>%
      dplyr::arrange(.data$SnapshotDate) %>%
      dplyr::group_by(.data$GroupID, .data$MetricID) %>%
      dplyr::slice_tail(n = 1) %>%
      dplyr::ungroup() %>% 
      select(-SnapshotDate)

      
    dfFlagOverTime <- dfFlagOverTime %>% 
    dplyr::left_join(dfFlagChange, by = c("GroupID", "MetricID")) %>%
    relocate(FlagChange, .after = Abbreviation) %>%
    mutate(FlagChange = ifelse(FlagChange,"\u2713" , "")) %>%
    mutate(FlagChange = ifelse(is.na(FlagChange), "", FlagChange)) %>% 
    rename("New Flag?"=FlagChange)


  }
  return(dfFlagOverTime)

}

fmt_flag_rag <- function(data, columns = gt::everything()) {
  fmt_sign_rag(data, columns = columns) %>%
    cols_label_month(columns = columns)
}

# Cells ------------------------------------------------------------------------

fmt_sign_rag <- function(data,
  columns = gt::everything(),
  rows = gt::everything()) {
  data_color_rag(data, columns = columns) %>%
    fmt_sign(columns = columns, rows = rows)
}

data_color_rag <- function(data,
  columns = gt::everything(),
  rows = gt::everything()) {
  gt::data_color(
    data,
    columns = columns,
    rows = rows,
    fn = n_to_rag
  )
}

fmt_sign <- function(data,
  columns = gt::everything(),
  rows = gt::everything()) {
  gt::fmt(
    data,
    columns = columns,
    rows = rows,
    compat = c("numeric", "integer"),
    fns = Report_FormatFlag
  ) %>%
    gt::cols_align(align = "center", columns = columns)
}

n_to_sign <- function(x) {
  dplyr::case_when(
    # Note: this is an actual minus sign for better printing, not a dash.
    x < 0 ~ "\u2212",
    x > 0 ~ "+",
    TRUE ~ ""
  )
}

n_to_rag <- function(x) {
  dplyr::case_when(
    x == 0 ~ colorScheme("green"),
    abs(x) >= 2 ~ colorScheme("red"),
    abs(x) >= 1 ~ colorScheme("amber"),
    TRUE ~ colorScheme("gray")
  )
}
