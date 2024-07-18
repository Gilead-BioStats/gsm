#' Report Study Information
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
  lStudyLabels=NULL
) {
  rlang::check_installed("gt", reason = "to render table from `MakeStudyStatusTable`")

  # default study labels - also used to sort the meta datatable
  if(is.null(lStudyLabels)){
    lStudyLabels <- list(
      StudyID = "Unique Study ID",
      protocol_title = "Protocol title",
      nickname = "Protocol nickname",
      SiteCount = "Sites Enrolled",
      num_site_plan = "Sites Planned",
      ParticipantCount = "Participants Enrolled",
      num_plan_subj = "Participants Planned",
      participant_summary = "Participants (Enrolled / Planned)",
      status = "Study Status",
      product = "Product",
      phase = "Phase",
      therapeutic_area = "Therapeutic Area",
      protocol_indication = "Indication",
      protocol_type = "Protocol type",
      protocol_row_id = "Protocol row ID",
      protocol_product_number = "Protocol product number",
      est_fpfv = "First-patient first visit date (CTMS)",
      est_lpfv = "Last-patient first visit date (CTMS)",
      est_lplv = "Last-patient last visit date (CTMS)"
    )
  }

  study_status_table <- lStudy %>% imap_dfr(function(value,param){
    data.frame(
      Description = ifelse(
        param %in% names(lStudyLabels),
        lStudyLabels[[param]],
        param
      ),
      Value = ifelse(
        is.na(value),
        value,
        prettyNum(value, drop0trailing = TRUE)
      )
    )
  })

  show_table <- study_status_table %>%
    slice(1:5) %>%
    gsm_gt(id = "study_table")

  hide_table <- study_status_table %>%
    gsm_gt(id = "study_table_hide")

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
