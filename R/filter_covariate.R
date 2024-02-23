#' filter covariate by group
#'
#' @param df `data.frame` data frame to filter
#' @param strGroup `string` group to filter by. options include: "study", "site", "subject
#'
#' @export
#'
#' @keywords internal
filter_covariate <- function(df, strGroup = "study"){
  if(strGroup == "study"){
    output <- df %>%
      filter(!is.empty(Metric)) %>%
      group_by(`Study ID`, Metric) %>%
      summarise("Total" = n_distinct(`Subject ID`), .groups = "drop") %>%
      mutate(`%` = gt::pct(round(`Total`/sum(`Total`) * 100, digits = 2)),
             Percent = `Total`/sum(`Total`) * 100) %>%
      arrange(desc(`Total`))

  } else if(strGroup == "site"){
    output <- df  %>%
      filter(!is.empty(Metric)) %>%
      group_by(`Site ID`) %>%
      mutate("Total" = n()) %>%
      group_by(`Site ID`, `Total`, Metric) %>%
      summarise("Total Metric" = n_distinct(`Subject ID`), .groups = "drop") %>%
      mutate(`%` = gt::pct(round(`Total Metric`/`Total` * 100, digits = 2)),
             Percent = `Total Metric`/`Total` * 100) %>%
      select( `Site ID`, Metric, `Total`, `Total Metric`, `%`, Percent) %>%
      arrange(desc(`Total`))
  }
  return(output)
}
