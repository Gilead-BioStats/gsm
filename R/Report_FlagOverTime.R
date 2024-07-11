# Create a table that shows flags over time for each site/KRI combination

# @param dfSummary A data frame with the following columns: GroupID, GroupLevel,
#   MetricID, SnapshotDate, Flag
# @param dfMetrics A data frame with the following columns: MetricID,
#   Abbreviation
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
    fmt_flag_rag(columns = date_cols) %>%
    gt::tab_header(
      title = "Flag Over Time",
      subtitle = "Flags over time for each site/KRI combination"
    ) %>%
    gt::opt_vertical_padding(0.5)
}

widen_summary <- function(dfSummary, dfMetrics) {
  dfMetrics_join <- dfMetrics %>%
    dplyr::select(
      "MetricID",
      "Abbreviation"
    )
  dfSummary %>%
    dplyr::left_join(dfMetrics_join, by = c("MetricID")) %>%
    dplyr::select(
      "GroupID",
      "GroupLevel",
      "MetricID",
      "Abbreviation",
      "SnapshotDate",
      "Flag"
    ) %>%
    dplyr::arrange(GroupID, MetricID, SnapshotDate) %>%
    tidyr::pivot_wider(names_from = "SnapshotDate", values_from = "Flag")
}

fmt_flag_rag <- function(data,
  columns = gt::everything(),
  rows = gt::everything()) {
  fmt_sign_rag(data, columns = columns) %>%
    cols_label_month(columns = columns) %>%
    gt::tab_spanner(label = "Flag", columns = columns)
}

# Cells ------------------------------------------------------------------------

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

# Headers ----------------------------------------------------------------------

cols_label_month <- function(data, columns = gt::everything()) {
  gt::cols_label_with(
    data,
    columns = columns,
    fn = function(x) {
      months(as.Date(x), abbreviate = TRUE)
    }
  ) %>%
    gt::tab_spanner_delim(
      delim = "-",
      columns = columns,
      split = "first",
      limit = 1
    )
}
