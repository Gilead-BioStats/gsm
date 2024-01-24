function(dfStudy, overview_raw_table, longitudinal = NULL) {
  parameterArrangeOrder <- c(
    "Unique Study ID", "Protocol title",
    "Protocol nickname", "Sites (Enrolled / Planned)", "Participants (Enrolled / Planned)",
    "Date that snapshot was created", "Risk-based monitoring flag",
    "Study Status", "Product", "Phase", "Therapeutic Area",
    "Indication", "Protocol type", "Protocol row ID", "Protocol product number",
    "# of enrolled sites from GILDA", "# of enrolled participants from GILDA",
    "First-patient first visit date", "Estimated first-patient first visit date from GILDA",
    "Last-patient first visit date", "Estimated last-patient first visit date from GILDA",
    "Last-patient last visit date", "Estimated last-patient last visit date from GILDA",
    "Average snapshot interval", "Median snapshot interval"
  )
  if (nrow(dfStudy) > 1) {
    dfStudy <- dfStudy %>% filter(.data$snapshot_date ==
      max(.data$snapshot_date))
  }
  paramDescription <- gsm::rbm_data_spec %>%
    filter(.data$Table ==
      "status_study") %>%
    rename(Parameter = "Column")
  sites <- paste0(nrow(overview_raw_table), " / ", round(as.numeric(dfStudy$planned_sites)))
  participants <- paste0(
    round(sum(as.numeric(overview_raw_table$Subjects))),
    " / ", round(as.numeric(dfStudy$planned_participants))
  )
  if (!is.null(longitudinal)) {
    snap_stats <- longitudinal$status_study %>% reframe(`Average snapshot interval` = mean(difftime(
      .data$snapshot_date,
      lag(.data$snapshot_date)
    ), na.rm = TRUE), `Median snapshot interval` = median(difftime(
      .data$snapshot_date,
      lag(.data$snapshot_date)
    ), na.rm = TRUE))
  }
  study_status_table <- dfStudy %>%
    {
      if (!is.null(longitudinal)) {
        cbind(., snap_stats)
      } else {
        .
      }
    } %>%
    t() %>%
    as.data.frame() %>%
    tibble::rownames_to_column() %>%
    setNames(c("Parameter", "Value")) %>%
    rowwise() %>%
    mutate(Value = ifelse(is.na(.data$Value),
      .data$Value, prettyNum(.data$Value, drop0trailing = TRUE)
    )) %>%
    ungroup() %>%
    left_join(paramDescription, by = join_by("Parameter")) %>%
    mutate(Description = ifelse(is.na(.data$Description),
      .data$Parameter, .data$Description
    )) %>%
    select(
      Parameter = "Description",
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
    filter(.data$Parameter %in%
      parameterArrangeOrder)
  study_status_table <- arrange(study_status_table, match(
    study_status_table$Parameter,
    parameterArrangeOrder
  ))
  show_table <- study_status_table %>%
    slice(1:5) %>%
    gt::gt(id = "study_table") %>%
    add_table_theme()
  hide_table <- study_status_table %>%
    gt::gt(id = "study_table_hide") %>%
    add_table_theme()
  toggle_switch <- glue::glue("<label class=\"toggle\">\n  <input class=\"toggle-checkbox btn-show-details\" type=\"checkbox\">\n  <div class=\"toggle-switch\"></div>\n  <span class=\"toggle-label\">Show Details</span>\n</label>")
  show_details_button <- HTML(toggle_switch)
  print(htmltools::h2("Study Status"))
  print(htmltools::tagList(show_details_button))
  print(htmltools::tagList(show_table))
  print(htmltools::tagList(hide_table))
}
