# Create a table that shows flags over time for each site/KRI combination

# @param dfSummary A data frame with the following columns: GroupID, GroupLevel, MetricID, snapshot_date, Flag
# @param dfMetrics A data frame with the following columns: MetricID, abbreviation
#
# @return An object of class `gt_tbl`.

Report_FlagOverTime <- function(dfSummary, dfMetrics) {
  dfFlagOverTime <- widen_summary(dfSummary, dfMetrics)
  date_cols <- stringr::str_which(
    colnames(dfFlagOverTime),
    r"(\d{4}-\d{2}-\d{2})"
  )

  rlang::check_installed("gt")
  dfFlagOverTime %>%
    dplyr::group_by(.data$GroupLevel, .data$GroupID) %>%
    gt::gt() %>%
    fmt_flags_change(columns = date_cols) %>%
    gt::tab_header(
      title = "Flag Over Time",
      subtitle = "Flags over time for each site/KRI combination"
    ) %>%
    gt::opt_vertical_padding(0.5)
}

widen_summary <- function(dfSummary, dfMetrics) {
  dfSummary %>%
    dplyr::left_join(dfMetrics, by = "MetricID") %>%
    dplyr::select(
      "GroupID",
      "GroupLevel",
      "MetricID",
      "abbreviation",
      "snapshot_date",
      "Flag"
    ) %>%
    tidyr::pivot_wider(names_from = "snapshot_date", values_from = "Flag")
}

fmt_flags_change <- function(data,
  columns = gt::everything(),
  rows = gt::everything()) {
  fmt_sign_rag(data, columns = columns, rows = rows) %>%
    gt::tab_spanner(label = "Flag", columns = columns)
}

fmt_sign_rag <- function(data,
  columns = gt::everything(),
  rows = gt::everything()) {
  data_color_rag(data, columns = columns, rows = rows) %>%
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
    x == 0 ~ "#008000",
    abs(x) >= 2 ~ "#A52A2A",
    abs(x) >= 1 ~ "#FFA500",
    TRUE ~ "#808080"
  )
}
