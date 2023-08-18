#' Create Status Study table in KRIReport.Rmd
#' @param dfStudy `data.frame` from `params` within `KRIReport.Rmd`
#' @export
#' @keywords internal
MakeStudyStatusTable <- function(dfStudy) {
  # -- this vector is used to define a custom sort order for the
  #    Study Status Table in KRIReport.Rmd
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

  # -- if a longitudinal snapshot is provided, select the most recent row
  #    of study metadata
  if (nrow(dfStudy) > 1) {
    dfStudy <- dfStudy %>%
      filter(
        .data$snapshot_date == max(.data$snapshot_date)
      )
  }

  # -- this table defines the expected parameters found in `study_status`
  #    this table then serves as a lookup table to give meaningful descriptions to the parameters
  #    e.g., `fpfv` is modified for the table as `First-patient first visit date`.
  paramDescription <- gsm::rbm_data_spec %>%
    filter(
      .data$Table == "status_study"
    ) %>%
    rename(
      "Parameter" = "Column"
    )



  # -- the `sites` and `participants` variables below are used to show a nicely-formatted version of (# Enrolled / # Planned)
  #    these values were being formatted with a lot of trailing zeroes, so they are rounded here before pasting as a character vector
  sites <- paste0(round(as.numeric(dfStudy$enrolled_sites)), " / ", round(as.numeric(dfStudy$planned_sites)))
  participants <- paste0(round(as.numeric(dfStudy$enrolled_participants)), " / ", round(as.numeric(dfStudy$planned_participants)))


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
#' @param lAssessment `list` List of KRI assessments from `params` within `KRIReport.Rmd`.
#' @param dfSite `data.frame` Optional site-level metadata.
#' @export
#' @keywords internal
MakeSummaryTable <- function(lAssessment, dfSite = NULL) {
  active <- lAssessments[!sapply(lAssessments, is.data.frame)]
  map(active, function(kri) {
    if (kri$bStatus) {
      dfSummary <- kri$lResults$lData$dfSummary

      if (!is.null(dfSite)) {
        dfSummary <- dfSummary %>%
          left_join(
            dfSite %>% select("siteid", "country", "status", "enrolled_participants"),
            c("GroupID" = "siteid")
          )
      }

      if (nrow(dfSummary) > 0 &
        any(c(-2, -1, 1, 2) %in% unique(dfSummary$Flag))) {
        dfSummary %>%
          filter(
            .data$Flag != 0
          ) %>%
          arrange(desc(abs(.data$Score))) %>%
          mutate(
            Flag = map(.data$Flag, kri_directionality_logo),
            across(
              where(is.numeric),
              ~ round(.x, 3)
            )
          ) %>%
          select(
            any_of(c(
              "Site" = "GroupID",
              "Country" = "country",
              "Status" = "status",
              "Subjects" = "enrolled_participants"
            )),
            everything()
          ) %>%
          DT::datatable(
            rownames = FALSE
          )
      } else {
        htmltools::p("Nothing flagged for this KRI.")
      }
    } else {
      htmltools::strong("Workflow failed.")
    }
  })
}

#' Add a standard theme to a `gt` table.
#' @param x `data.frame` A data.frame that will be converted to a `gt` table.
#' @export
#' @keywords internal
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

#' Create KRI metadata table in KRIReport.Rmd
#' @param dfMetaWorkflow `data.frame` Workflow metadata from `params` within `KRIReport.Rmd`
#' @export
#' @keywords internal
MakeKRIGlossary <- function(
    strWorkflowIDs = NULL,
    strDroppedWorkflowIDs = NULL,
    dfMetaWorkflow = gsm::meta_workflow
) {
  workflows <- dfMetaWorkflow %>%
    filter(
      .data$workflowid %in% c(strWorkflowIDs, strDroppedWorkflowIDs)
    ) %>%
    rename_with(~
                  .x %>%
                  gsub("_|(?=id)", " ", ., perl = TRUE) %>%
                  gsub("(^.| .)", "\\U\\1", ., perl = TRUE) %>%
                  gsub("(gsm|id)", "\\U\\1", ., ignore.case = TRUE, perl = TRUE))

  workflows %>%
    {if(!is.null(strDroppedWorkflowIDs)) mutate(., Status = case_when(`Workflow ID` %in% strWorkflowIDs ~ "Active",
                                                                      `Workflow ID` %in% strDroppedWorkflowIDs ~ paste0("Deactivated\n",
                                                                                                                        unique(dropped$kri0001$snapshot_date))),
                                                .before = `GSM Version`) else .} %>%
    DT::datatable(
      class = "compact",
      options = list(
        columnDefs = list(list(
          className = "dt-center",
          targets = 0:(ncol(workflows) - 1)
        )),
        paging = FALSE,
        searching = FALSE
      ),
      rownames = FALSE
    )
}

