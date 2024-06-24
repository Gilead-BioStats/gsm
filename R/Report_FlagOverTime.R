# Create a table that shows flags over time for each site/KRI combination

# @param dfSummary A data frame with the following columns: SiteID, MetricID, snapshot_date, flag
# @param dfSite A data frame with the following columns: SiteID, SiteName
# @param dfMetrics A data frame with the following columns: MetricID, MetricName
#
# @return A data frame with the following columns: SiteID, SiteName, MetricID, MetricName, snapshot_date, flag

FlagOverTime <- function(dfSummary, dfSite, dfMetrics) {
  
  # Create a table that shows flags over time for each site/KRI combination
  dfFlagOverTime <- dfSummary %>%
    left_join(dfSite, by = "GroupID") %>%
    left_join(dfMetrics, by = "MetricID") %>%
    select(GroupID, GroupLevel, MetricID, abbreviation, snapshot_date, Flag) %>%
    tidyr::spread(key = snapshot_date, value = Flag) 

    ncol <- dim(dfFlagOverTime)[2]
  
  # Create a  table with flags over time for each site/KRI combination
  gt_table <- dfFlagOverTime %>% 
    group_by(GroupLevel, GroupID) %>%
    gt() %>%
    data_color(
        method = "numeric",
        palette =  c("#000000","#FF0000", "#FFA500", "#008000", "#FFA500", "#FF0000","#000000"),
        domain= c(-2.5,-1.5,-0.5,0.5,1.5,2.5)
    ) %>% 
    text_transform(
        locations = cells_body(columns = 5:ncol),
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
    cols_align(
        columns = 5:ncol,
        align = "center"
    ) %>% 
    opt_vertical_padding(0.5) %>%
    opt_vertical_padding(0.5) %>%
    tab_header(
        title = "Flag Over Time",
        subtitle = "Flags over time for each site/KRI combination"
    ) %>%
    tab_spanner(
        label = "Flag",
        columns = 5:ncol
    ) 





        

  return(gt_table)
}