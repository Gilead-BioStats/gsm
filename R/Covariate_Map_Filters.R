#' filter covariate by group
#'
#' @param df `data.frame` data frame to filter
#' @param strGroup `string` group to filter by. options include: "study", "site", "subject
#'
#' @export
#'
#' @keywords internal
filter_covariate <- function(df, strGroup = "subject"){
  if(strGroup == "study"){
    group <- rlang::syms('Study ID')
  } else if(strGroup == "study"){
    group <- rlang::syms('Site ID')
  } else if(strGroup == "study"){
    group <- rlang::syms('Subject ID')
  }

  if(strGroup %in% c("study", "site")){
    df %>%
      group_by(!!group) %>%
      mutate("Enrolled Patients" = n_distinct(`Subject ID`)) %>%
      filter(!is.empty(Metric)) %>%
      mutate("Subjects with Metric" = n_distinct(`Subject ID`)) %>%
      group_by(!!group, Metric, `Enrolled Patients`) %>%
      summarise("# Patients" = n_distinct(`Subject ID`), .groups = "drop") %>%
      mutate(`%` = gt::pct(round(`# Patients`/`Enrolled Patients` * 100, digits = 2)))
  }
  if(strGroup == "subject"){
    df
  }

}
