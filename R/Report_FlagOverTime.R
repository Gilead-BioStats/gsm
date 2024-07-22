#' Summarize flags by SnapshotDate
#'
#' Create a table of longitudinal study data by site, study, or country, showing
#' flags over time.
#'
#' @inheritParams shared-params
#' @param strGroupLevel A string specifying the group type.
#'
#' @inherit gt-shared return
#' @export
Report_FlagOverTime <- function(dfResults,
                                dfMetrics,
                                strGroupLevel = c("Site", "Study", "Country")) {
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
      title = "Flag Over Time",
      subtitle = glue::glue(
        "Flags over time for each {strGroupLevel}/KRI combination"
      )
    )
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
  dfFlagOverTime %>%
    dplyr::arrange(.data$SnapshotDate) %>%
    tidyr::pivot_wider(names_from = "SnapshotDate", values_from = "Flag") %>%
    dplyr::arrange(.data$GroupID, .data$MetricID)
}

fmt_flag_rag <- function(data, columns = gt::everything()) {
  fmt_sign_rag(data, columns = columns) %>%
    cols_label_month(columns = columns) %>%
    gt::tab_spanner(label = "Flag", columns = columns)
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
    fns = n_to_sign
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

colorScheme <- function(color_name) {
  colors <- c(
    red = "#FF0040",
    amber = "#FFBF00",
    green = "#52C41A",
    gray = "#AAAAAA",
    grey = "#AAAAAA"
  )
  colors[[color_name]]
}
