#' Report Study Information
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' This function generates a table summarizing study metadata as an interactive
#' [gt::gt()] wrapped in HTML.
#'
#' @param lStudy A list containing study information.
#' @param lStudyLabels A list containing study labels. Default is NULL.
#'
#' @export
#'
#' @return None
#'
#' @keywords internal

Report_StudyInfo <- function(
  lStudy,
  lStudyLabels = NULL
) {
  rlang::check_installed("gt", reason = "to render table from `Report_StudyInfo`")

  study_status_table <- MakeStudyInfo(lStudy, lStudyLabels)

  show_table <- study_status_table %>%
    dplyr::filter(
      .data$Param %in% c("GroupID", "nickname", "Status", "SiteCount", "ParticipantCount")
    ) %>%
    dplyr::select("Description", "Value") %>%
    gsm_gt(id = "study_table")


  hide_table <- study_status_table %>%
    dplyr::select("Description", "Value") %>%
    gsm_gt(id = "study_table_hide")

  toggle_switch <- glue::glue('<label class="toggle">
  <input class="toggle-checkbox btn-show-details" type="checkbox">
  <div class="toggle-switch"></div>
  <span class="toggle-label">Show Details</span>
</label>')
  show_details_button <- HTML(toggle_switch)

  htmltools::tagList(
    htmltools::h2("Study Status"),
    show_details_button,
    show_table,
    hide_table
  )
}
