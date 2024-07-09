# Create a table that shows flags over time for each site/KRI combination

# @param dfSummary A data frame with the following columns: GroupID, GroupLevel, MetricID, snapshot_date, Flag
# @param dfMetrics A data frame with the following columns: MetricID, abbreviation
#
# @return An object of class `gt_tbl`.

FlagOverTime <- function(dfSummary, dfMetrics) {
  rlang::check_installed("gt")
  # Create a table that shows flags over time for each site/KRI combination
  dfFlagOverTime <- dfSummary %>%
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

    ncol <- dim(dfFlagOverTime)[2]

  # Create a  table with flags over time for each site/KRI combination
  gt_table <- dfFlagOverTime %>%
    dplyr::group_by(GroupLevel, GroupID) %>%
    gt::gt() %>%
    gt::data_color(
        method = "numeric",
        palette =  c("#000000","#FF0000", "#FFA500", "#008000", "#FFA500", "#FF0000","#000000"),
        domain = c(-2.5,-1.5,-0.5,0.5,1.5,2.5)
    ) %>%
    gt::text_transform(
        locations = gt::cells_body(columns = 5:ncol),
        fn = function(x) {
            dplyr::case_when(
                x == -2 ~ "-",
                x == -1 ~ "-",
                x == 0 ~ "",
                x == 1 ~ "+",
                x == 2 ~ "+",
                TRUE ~ ""
            )
        }
    ) %>%
    gt::cols_align(
        columns = 5:ncol,
        align = "center"
    ) %>%
    gt::opt_vertical_padding(0.5) %>%
    gt::opt_vertical_padding(0.5) %>%
    gt::tab_header(
        title = "Flag Over Time",
        subtitle = "Flags over time for each site/KRI combination"
    ) %>%
    gt::tab_spanner(
        label = "Flag",
        columns = 5:ncol
    )

  return(gt_table)
}
