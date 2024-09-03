#' Report Study Information
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' This function generates a table summarizing study metadata.
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
  rlang::check_installed("gt", reason = "to render table from `MakeStudyStatusTable`")

  # default study labels - also used to sort the meta datatable
  if (is.null(lStudyLabels)) {
    lStudyLabels <- list(
      SiteCount = "Sites Enrolled",
      ParticipantCount = "Participants Enrolled",
      Status = "Study Status"
    )
  }

  lLabels <- MakeParamLabelsList(names(lStudy), lStudyLabels)
  dfLabels <- data.frame(
    Param = names(lLabels),
    Description = unname(unlist(lLabels))
  )

  study_status_table <- data.frame(
    Param = names(lStudy),
    Value = unname(unlist(lStudy))
  ) %>%
    dplyr::left_join(dfLabels, by = "Param") %>%
    dplyr::mutate(
      Value = dplyr::if_else(
        is.na(.data$Value),
        .data$Value,
        prettyNum(.data$Value, drop0trailing = TRUE)
      )
    )

  show_table <- study_status_table %>%
    dplyr::filter(Param %in% c("StudyID", "nickname", "enrolled_sites", "enrolled_participants")) %>%
    gsm_gt(id = "study_table") %>%
    dplyr::select("Description", "Value")


  hide_table <- study_status_table %>%
    gsm_gt(id = "study_table_hide") %>%
    dplyr::select("Description", "Value")

  toggle_switch <- glue::glue('<label class="toggle">
  <input class="toggle-checkbox btn-show-details" type="checkbox">
  <div class="toggle-switch"></div>
  <span class="toggle-label">Show Details</span>
</label>')
  show_details_button <- HTML(toggle_switch)

  print(htmltools::h2("Study Status"))
  print(htmltools::tagList(show_details_button))
  print(htmltools::tagList(show_table))
  print(htmltools::tagList(hide_table))
}
