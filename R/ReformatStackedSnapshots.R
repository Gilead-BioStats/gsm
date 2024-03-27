#' Reformat `lStackedSnapshots` from `gsm v1.8.4` to `gsm v1.9.0+`.
#'
#' @param lStackedSnapshots
#'
#' @keywords internal
ReformatStackedSnapshots <- function(lStackedSnapshots) {



# results_summary >>> rpt_site_kri_details --------------------------------

  rpt_site_kri_details <- lStackedSnapshots$results_summary %>%
    mutate(
      snapshot_date = .data$gsm_analysis_date,
      no_of_consecutive_loads = "",
      upper_threshold = "",
      lower_threshold = "",
      bottom_lower_threshold = "",
      top_upper_threshold = "",
      metric = "",
      country_aggregate = "",
      study_aggregate = "",
      numerator_name = "",
      denominator_name = "",
      pt_cycle_id = "",
      pt_data_dt = ""
    ) %>%
    select(
      "studyid",
      "snapshot_date",
      "siteid" = "groupid",
      "workflowid",
      "metric_value" = "metric",
      "score",
      "numerator_value" = "numerator",
      "denominator_value" = "denominator",
      "flag_value" = "flag",
      "no_of_consecutive_loads",
      "upper_threshold",
      "lower_threshold",
      "bottom_lower_threshold",
      "top_upper_threshold",
      "metric",
      "country_aggregate",
      "study_aggregate",
      "numerator_name",
      "denominator_name",
      "pt_cycle_id",
      "pt_data_dt",
      "gsm_analysis_date"
    )


# results_analysis >>> rpt_qtl_analysis -----------------------------------
  rpt_qtl_analysis <- lStackedSnapshots$results_analysis %>%
    mutate(
      snapshot_date = .data$gsm_analysis_date,
      pt_cycle_id = "",
      pt_data_dt = ""
    ) %>%
    select(
      "studyid",
      "snapshot_date",
      "workflowid",
      "param",
      "value",
      "pt_cycle_id",
      "pt_data_dt",
      "gsm_analysis_date"
    )

  lStackedSnapshots <- list(
    rpt_site_kri_details = rpt_site_kri_details,
    rpt_qtl_analysis = rpt_qtl_analysis
  )


  return(lStackedSnapshots)

}
