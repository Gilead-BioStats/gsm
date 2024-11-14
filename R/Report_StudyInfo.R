#' Report Study Information
#'
#' @description `r lifecycle::badge("stable")`
#'
#' This function generates a table summarizing study metadata as an interactive
#' [gt::gt()] wrapped in HTML.
#'
#' @inheritParams shared-params
#' @param lStudyLabels `list` A list containing study labels. Default is NULL.
#' @param strId `character` A string to identify the output table.
#' @param tagHeader `shiny.tag` An HTML tag or tags to use as a header for the
#'   table.
#' @param lStudy `deprecated` Study information as a named list.
#'
#' @export
#'
#' @return A [htmltools::tagList()] to display a table of study information.

Report_StudyInfo <- function(
  dfGroups,
  lStudyLabels = NULL,
  strId = "study_table",
  tagHeader = htmltools::h2("Study Status"),
  lStudy = deprecated()
) {
  rlang::check_installed("gt", reason = "to render table from `Report_StudyInfo`")

  study_status_table <- MakeStudyInfo(dfGroups, lStudyLabels, lStudy = lStudy)

  subcols <- c(
      "GroupID",
      "nickname",
      "Status",
      "SiteActivation",
      "ParticipantEnrollment"
    )
  show_table <- study_status_table %>%
    dplyr::filter(.data$Param %in% subcols) %>%
    gt_StudyInfo(id = strId)

  strId_hide <- paste0(strId, "_hide")
  hide_table <- htmltools::div(
    id = strId_hide,
    style = "display: none;",
    gt_StudyInfo(study_status_table, id = paste0(strId_hide, "_gt"))
  )

  htmltools::tagList(
    tagHeader,
    htmlDetailsButton(strId, strId_hide),
    show_table,
    hide_table,
    htmlDependency_toggleTables()
  )
}

htmlDetailsButton <- function(strId, strId_hide) {
  HTML(glue::glue(
    '<label class="toggle">',
    '  <input class="toggle-checkbox btn-show-details" type="checkbox"',
    '    data-shown-table="{strId}"',
    '    data-hidden-table="{strId_hide}"',
    '    data-hidden="false"',
    '    onclick="toggleTables(this)">',
    '  <div class="toggle-switch"></div>',
    '  <span class="toggle-label">Show Details</span>',
    "</label>",
    .sep = "\n"
  ))
}

htmlDependency_toggleTables <- function() {
  htmltools::tagList(
    htmltools::htmlDependency(
      name = "toggleTables",
      version = "1.0.0",
      src = "report/lib",
      package = "gsm",
      script = "toggleTables.js"
    ),
    htmltools::htmlDependency(
      name = "toggleButton",
      version = "1.0.0",
      src = "report",
      package = "gsm",
      stylesheet = "toggleButton.css"
    )
  )
}

gt_StudyInfo <- function(data, ...) {
  data %>%
    dplyr::select("Description", "Value") %>%
    gsm_gt(...) %>%
    gt::cols_align(columns = "Value", align = "right") %>%
    gt::tab_options(
      column_labels.hidden = TRUE
    )
}
