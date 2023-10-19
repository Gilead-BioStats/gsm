#' Create Study Results table for Report
#' @param lResults `list` the output of `Study_Assess()` containing results of kri analysis
#' @export
#' @keywords internal
Flags_by_site <- function(lResults){
  output <- lResults[grep("kri", names(lResults))] %>%
    map_df(., function(kri) {
      bind_rows(kri$lResults$lData$dfSummary)
    }, .id = "kri") %>%
    filter(!is.na(Flag)) %>%
    mutate(flag_color = case_when(Flag %in% c(2, -2) ~ "red",
                                  Flag %in% c(1, -1) ~ "amber",
                                  Flag == 0 ~ "green")) %>%
    group_by(GroupID, flag_color) %>%
    summarise(n_flags = n(), .groups = "drop") %>%
    filter(flag_color %in% c("red", "amber")) %>%
    tidyr::pivot_wider(names_from = "flag_color", values_from = "n_flags") %>%
    select("siteid" = "GroupID",
           "num_of_at_risk_kris" = "red",
           "num_of_flagged_kris" = "amber")

  return(output)
}




