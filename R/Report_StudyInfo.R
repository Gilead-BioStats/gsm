#' Report Study Information
#'
#' This function generates a table summarizing study metadata.
#'
#' @param dfStudy A data frame containing study information.
#' @param dfStudyLabels A data frame containing study labels. Default is NULL.
#'
#' @return None


Report_StudyInfo <- function(
    dfStudy, 
    dfStudyLabels=NULL
) {
  rlang::check_installed("gt", reason = "to render table from `MakeStudyStatusTable`")

  # default study labels - also used to sort the meta datatable
  if(is.null(dfStudyLabels)){
    dfStudyLabels <- data.frame(
      Parameter = c(
        "studyid",
        "title",
        "nickname",
        "site_summary",
        "participant_summary",
        "snapshot_date",
        "rbm_flag",
        "status",
        "product",
        "phase",
        "ta",
        "indication",
        "protocol_type",
        "protocol_row_id",
        "protocol_product_number",
        "est_fpfv",
        "est_lpfv",
        "est_lplv"
      ),
      Description = c(
        "Unique Study ID",
        "Protocol title",
        "Protocol nickname",
        "Sites (Enrolled / Planned)",
        "Participants (Enrolled / Planned)",
        "Date that snapshot was created",
        "Risk-based monitoring flag",
        "Study Status",
        "Product",
        "Phase",
        "Therapeutic Area",
        "Indication",
        "Protocol type",
        "Protocol row ID",
        "Protocol product number",
        "First-patient first visit date (CTMS)",
        "Last-patient first visit date (CTMS)",
        "Last-patient last visit date (CTMS)"
      )
    )
  }


  # -- the `sites` and `participants` variables below are used to show a nicely-formatted version of (# Enrolled / # Planned)

  dfStudy$site_summary <- paste0(round(as.numeric(dfStudy$enrolled_sites)), " / ", round(as.numeric(dfStudy$planned_sites)))
  dfStudy$participant_summary <- paste0(round(sum(as.numeric(dfStudy$enrolled_participants))), " / ", round(as.numeric(dfStudy$planned_participants)))

  study_status_table <- dfStudy %>%
    t() %>%
    as.data.frame() %>%
    tibble::rownames_to_column() %>%
    setNames(c("Parameter", "Value")) %>%
    rowwise() %>%
    mutate(
      Value = ifelse(
        is.na(.data$Value),
        .data$Value,
        prettyNum(.data$Value, drop0trailing = TRUE)
      )
    ) %>%
    ungroup() %>%
    right_join(
      dfStudyLabels,
      by = join_by("Parameter")
    ) %>%
    select(
      "Parameter" = "Description",
      "Value"
    ) 

  show_table <- study_status_table %>%
    slice(1:5) %>%
    gt::gt(id = "study_table")

  hide_table <- study_status_table %>%
    gt::gt(id = "study_table_hide") 

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