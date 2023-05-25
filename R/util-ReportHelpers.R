#' Create Status Study table in KRIReport.Rmd
#' @param status_study `data.frame` from `params` within `KRIReport.Rmd`
#' @noRd
MakeStudyStatusTable <- function(status_study) {
  parameterArrangeOrder <- c(
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
    "# of enrolled sites from GILDA",
    "# of enrolled participants from GILDA",
    "First-patient first visit date",
    "Estimated first-patient first visit date from GILDA",
    "Last-patient first visit date",
    "Estimated last-patient first visit date from GILDA",
    "Last-patient last visit date",
    "Estimated last-patient last visit date from GILDA"
  )

  # if longitudinal snapshot is used, select the most recent row
  if (nrow(status_study) > 1) {
    status_study <- status_study %>%
      filter(
        .data$snapshot_date == max(.data$snapshot_date)
      )
  }

  paramDescription <- gsm::rbm_data_spec %>%
    filter(
      .data$Table == "status_study"
    ) %>%
    rename(
      "Parameter" = "Column"
    )



  sites <- paste0(status_study$enrolled_sites, " / ", status_study$planned_sites)
  participants <- paste0(status_study$enrolled_participants, " / ", status_study$planned_participants)

  study_status_table <- status_study %>%
    t() %>%
    as.data.frame() %>%
    tibble::rownames_to_column() %>%
    setNames(c("Parameter", "Value")) %>%
    mutate(
      Value = prettyNum(.data$Value, drop0trailing = TRUE)
    ) %>%
    left_join(
      paramDescription,
      by = join_by("Parameter")
    ) %>%
    select(
      "Parameter" = "Description",
      "Value"
    ) %>%
    add_row(
      Parameter = "Sites (Enrolled / Planned)",
      Value = sites
    ) %>%
    add_row(
      Parameter = "Participants (Enrolled / Planned)",
      Value = participants
    ) %>%
    filter(
      .data$Parameter %in% parameterArrangeOrder
    )

  study_status_table <- arrange(study_status_table, match(study_status_table$Parameter, parameterArrangeOrder))

  show_table <- study_status_table %>%
    slice(1:5) %>%
    gt::gt(id = "study_table") %>%
    add_table_theme()

  hide_table <- study_status_table %>%
    gt::gt(id = "study_table_hide") %>%
    add_table_theme()

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


#' Create Summary table in KRIReport.Rmd for each KRI
#' @param assessment `data.frame` from `params` within `KRIReport.Rmd`
#' @noRd
MakeSummaryTable <- function(assessment) {
  map(assessment, function(kri) {
    if (kri$bStatus) {
      dfSummary <- kri$lResults$lData$dfSummary

      if (nrow(dfSummary) > 0 &
        any(c(-2, -1, 1, 2) %in% unique(dfSummary$Flag))) {
        dfSummary %>%
          filter(.data$Flag != 0) %>%
          arrange(desc(abs(.data$Flag))) %>%
          mutate(
            FlagDirectionality = map(.data$Flag, kri_directionality_logo),
            across(
              where(is.numeric),
              ~ round(.x, 3)
            )
          ) %>%
          DT::datatable()
      } else {
        htmltools::p("Nothing flagged for this KRI.")
      }
    } else {
      htmltools::strong("Workflow failed.")
    }
  })
}


add_table_theme <- function(x) {
  x %>%
    gt::tab_options(
      table.width = "80%",
      table.font.size = 14,
      table.font.names = c("Roboto", "sans-serif"),
      table.border.top.style = "hidden",
      table.border.bottom.style = "hidden",
      data_row.padding = gt::px(5),
      column_labels.font.weight = "bold"
    ) %>%
    gt::cols_width(
      Parameter ~ gt::pct(60),
      Value ~ gt::pct(40)
    ) %>%
    gt::opt_row_striping()
}
