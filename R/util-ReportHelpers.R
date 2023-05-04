
#' Create Status Study table in KRIReport.Rmd
#' @param status_study `data.frame` from `params` within `KRIReport.Rmd`
#' @noRd
MakeStudyStatusTable <- function(status_study) {

  parameterArrangeOrder <- c(
    "Unique Study ID",
    "Date that snapshot was created",
    "Risk-based monitoring flag",
    "Study Status",
    "Product",
    "Phase",
    "Therapeutic Area",
    "Indication",
    "Protocol title",
    "Protocol nickname",
    "Protocol type",
    "Protocol row ID",
    "Protocol product number",
    "# of planned sites",
    "# of enrolled sites",
    "# of enrolled sites from GILDA",
    "# of planned participants",
    "# of enrolled participants",
    "# of enrolled participants from GILDA",
    "First-patient first visit date",
    "Estimated first-patient first visit date from GILDA",
    "Last-patient first visit date",
    "Estimated last-patient first visit date from GILDA",
    "Last-patient last visit date",
    "Estimated last-patient last visit date from GILDA"
  )

  paramDescription <- gsm::rbm_data_spec %>%
    filter(
      .data$Table == "status_study"
    ) %>%
    rename(
      "Parameter" = "Column"
    )

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
      by = join_by(.data$Parameter)
    ) %>%
    select(
      "Parameter" = "Description",
      "Value"
    )

  print(htmltools::h2("Study Status"))
  print(htmltools::tagList(
    study_status_table %>%
      gt::gt(id = "study_table") %>%
      gt::tab_options(
        table.width = "80%",
        table.font.size = 14,
        table.font.names = c("Roboto", "sans-serif"),
        table.border.top.style = "hidden",
        table.border.bottom.style = "hidden",
        data_row.padding = gt::px(5),
        column_labels.font.weight = "bold"
      ) %>%
      gt::opt_row_striping()

  ))
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
          filter(Flag != 0) %>%
          arrange(desc(abs(Flag))) %>%
          mutate(FlagDirectionality = map(Flag, kri_directionality_logo),
                 across(where(is.numeric),
                        ~ round(.x, 3))) %>%
          DT::datatable()
      } else {
        htmltools::p("Nothing flagged for this KRI.")
      }

    } else {
      htmltools::strong("Workflow failed.")
    }

  })
}
