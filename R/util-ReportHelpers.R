#' Create Status Study table in KRIReport.Rmd
#' @param dfStudy `data.frame` from `params` within `KRIReport.Rmd`
#' @param overview_raw_table `data.frame` non interactive output of `Overview_Table()` for the relevant report.
#' @param longitudinal `data.frame` optional argument for longitudinal study information
#' @import htmltools
#' @importFrom tibble rownames_to_column
#' @export
#' @keywords internal
MakeStudyStatusTable <- function(dfStudy, overview_raw_table, longitudinal = NULL) {

  rlang::check_installed("gt", reason = "to render table from `MakeStudyStatusTable`")

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
    "Estimated last-patient last visit date from GILDA",
    "Average snapshot interval",
    "Median snapshot interval"
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
  participants <- paste0(round(sum(as.numeric(overview_raw_table$Subjects))), " / ", round(as.numeric(dfStudy$planned_participants)))

  if (!is.null(longitudinal)) {
    snap_stats <- longitudinal$rpt_study_details %>%
      reframe(
        "Average snapshot interval" = mean(difftime(.data$gsm_analysis_date, lag(.data$gsm_analysis_date)), na.rm = TRUE),
        "Median snapshot interval" = median(difftime(.data$gsm_analysis_date, lag(.data$gsm_analysis_date)), na.rm = TRUE)
      )
  }


  study_status_table <- dfStudy %>%
    {
      if (!is.null(longitudinal)) cbind(., snap_stats) else .
    } %>%
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
    mutate(Description = ifelse(is.na(.data$Description), .data$Parameter, .data$Description)) %>%
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
#' @importFrom htmltools p strong
#' @importFrom DT datatable
#' @export
#' @keywords internal
MakeSummaryTable <- function(lAssessment, dfSite = NULL) {
  active <- lAssessment[!sapply(lAssessment, is.data.frame)]
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

  rlang::check_installed("gt", reason = "to use `add_table_theme`")

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
#' @param strWorkflowIDs `string` a string of KRI names to display in output
#' @param lStatus `data.frame` the KRI status output using `Augment_Snapshot`
#' @importFrom DT datatable
#' @export
#' @keywords internal
MakeKRIGlossary <- function(
  dfMetaWorkflow = gsm::meta_workflow,
  strWorkflowIDs = NULL,
  lStatus = NULL) {
  if (length(lStatus) != 0) {
    strDroppedWorkflowIDs <- lStatus %>%
      filter(!.data$`Currently Active`) %>%
      pull(.data$`Workflow ID`)
    combo_strWorkflowIDs <- c(strWorkflowIDs, strDroppedWorkflowIDs)
  } else {
    combo_strWorkflowIDs <- strWorkflowIDs
  }
  workflows <- dfMetaWorkflow %>%
    filter(
      .data$workflowid %in% combo_strWorkflowIDs
    ) %>%
    rename_with(~
      .x %>%
        gsub("_|(?=id)", " ", ., perl = TRUE) %>%
        gsub("(^.| .)", "\\U\\1", ., perl = TRUE) %>%
        gsub("(gsm|id)", "\\U\\1", ., ignore.case = TRUE, perl = TRUE))


  workflows %>%
    {
      if (length(lStatus) != 0) {
        left_join(., lStatus %>%
          select(.data$`Workflow ID`, .data$`Latest Snapshot`),
        by = "Workflow ID"
        ) %>%
          mutate(
            Status = case_when(
              .data$`Workflow ID` %in% strWorkflowIDs ~ "Active",
              .data$`Workflow ID` %in% strDroppedWorkflowIDs ~ paste0("Deactivated\n", .data$`Latest Snapshot`)
            ),
            .before = .data[["GSM Version"]]
          ) %>%
          select(-.data$`Latest Snapshot`)
      } else {
        .
      }
    } %>%
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

#' Create Study Results table for Report
#' @param assessment `list` a snapshot list containing the parameters to assess
#' @param summary_table `data.frame` a summary table created from `MakeSummaryTable`
#' @import htmltools
#' @import knitr
#' @importFrom purrr map
#' @export
#' @keywords internal
MakeResultsTable <- function(assessment, summary_table, lCharts) {
  for (i in seq_along(assessment)) {
    kri_key <- names(assessment)[i]
    kri <- assessment[[kri_key]]

    title <- gsm::meta_workflow %>%
      filter(.data$workflowid == kri_key) %>%
      pull(.data$metric)

    ### KRI section /
    print(htmltools::h3(title))

    #### charts tabset /
    cat("#### Summary Charts {.tabset} \n")

    charts <- lCharts[[kri_key]][
      names(lCharts[[kri_key]]) %in% c("scatterJS", "barMetricJS", "barScoreJS", "timeSeriesContinuousJS", "timeseriesQtl")
    ]

    for (j in seq_along(charts)) {
      chart_key <- names(charts)[j]
      chart <- charts[[chart_key]]
      chart_name <- switch(chart_key,
        scatterJS = "Scatter Plot",
        barScoreJS = "Bar Chart (KRI Score)",
        barMetricJS = "Bar Chart (KRI Metric)",
        timeSeriesContinuousJS = "Time Series (Continuous)"
      )

      ##### chart tab /
      chart_header <- paste("#####", chart_name, "\n")

      cat(chart_header)

      # need to initialize JS dependencies within loop in order to print correctly
      # see here: https://github.com/rstudio/rmarkdown/issues/1877#issuecomment-678996452
      purrr::map(
        charts,
        ~ .x %>%
          knitr::knit_print() %>%
          attr("knit_meta") %>%
          knitr::knit_meta_add() %>%
          invisible()
      )

      # Display chart.
      cat(paste0("<div class =", chart_key, ">"))
      cat(knitr::knit_print(htmltools::tagList(chart)))
      cat("</div>")
      ##### / chart tab
    }

    cat("#### {-} \n")
    #### / charts tabset

    #### table /
    if (!is.null(summary_table[[assessment[[i]]$name]])) {
      print(htmltools::h4("Summary Table"))
      print(htmltools::tagList(summary_table[[assessment[[i]]$name]]))
    }
    #### / table
    ### / KRI section
  }
}

#' Create Study Results table for Report
#' @param assessment `list` a snapshot list containing the parameters to assess
#' @param strType `string` a string defining what report to define: "kri", "cou", or "qtl"
#' @export
#' @keywords internal
AssessStatus <- function(assessment, strType) {
  any_dropped <- map(assessment, function(names) {
    "bActive" %in% names(names)
  }) %>%
    unlist(.data) %>%
    any()

  if (any_dropped) {
    active <- assessment[map_df(assessment, function(status) {
      status[["bActive"]] == TRUE
    }) %>%
      pivot_longer(everything()) %>%
      filter(.data$value) %>%
      pull(.data$name)]

    dropped <- assessment[map_df(assessment, function(status) {
      status[["bActive"]] == FALSE
    }) %>%
      pivot_longer(everything()) %>%
      filter(.data$value) %>%
      pull(.data$name)]

    output <- list(
      active = active[grep(strType, names(active))],
      dropped = dropped[grep(strType, names(dropped))]
    )
  } else {
    output <- assessment[
      grep(strType, names(assessment))
    ]
  }
  return(output)
}

#' Create Study Results table for Report
#' @param assessment `list` a snapshot list containing the parameters to assess
#' @param dfSite `data.frame` Site-level metadata containing within `params$status_site` of report
#' @importFrom purrr map
#' @export
#' @keywords internal
MakeReportSetup <- function(assessment, dfSite, strType) {
  if (strType == "cou") {
    type <- "country"
  } else if (strType == "kri") {
    type <- "site"
  } else if (tolower(strType) == "qtl") {
    type <- "qtl"
  }
  ## create output list
  output <- list()

  ## Study_Assess() output - KRIs only
  input <- AssessStatus(assessment, strType = strType)
  output$active <- if ("active" %in% names(input)) {
    input$active
  } else {
    input
  }
  output$dropped <- if ("dropped" %in% names(input)) {
    input$dropped
  } else {
    NULL
  }

  ## Overview Table - HTML object
  output$overview_table <- Overview_Table(
    lAssessments = output$active,
    dfSite = dfSite,
    strReportType = type,
  )

  ## Overview Table - data.frame/raw data
  output$overview_raw_table <- Overview_Table(
    lAssessments = output$active,
    dfSite = dfSite,
    strReportType = type,
    bInteractive = FALSE
  )

  output$red_kris <- output$overview_raw_table %>%
    pull(.data[["Red KRIs"]]) %>%
    sum()
  output$amber_kris <- output$overview_raw_table %>%
    pull(.data[["Amber KRIs"]]) %>%
    sum()

  ## Generate listing of flagged KRIs.
  output$summary_table <- MakeSummaryTable(
    output$active,
    dfSite
  )

  if (!is.null(output$dropped)) {
    output$dropped_summary_table <- MakeSummaryTable(
      output$dropped,
      dfSite
    )
  }

  ## StudyID
  output$study_id <- purrr::map(output$active, function(kri) {
    if (kri$bStatus) {
      return(kri$lData$dfInput$StudyID %>% unique())
    }
  }) %>%
    discard(is.null) %>%
    as.character() %>%
    unique()

  ## return output
  return(output)
}

#' Create message describing study summary for Report
#' @param report `string` type of report being run
#' @param status_study `data.frame` the snapshot status study output created with `Make_Snapshot()$lSnapshot$status_study`
#' @param overview_raw_table `data.frame` non interactive output of `Overview_Table()` for the relevant report.
#' @param red_kris `string` a string or number containing the count of red flags in kri's
#' @importFrom glue glue
#' @export
#' @keywords internal
MakeOverviewMessage <- function(report, status_study, overview_raw_table, red_kris) {
  if (report == "site") {
    cat(glue::glue("<div>As of {status_study$gsm_analysis_date}, {status_study$studyid} has {round(sum(as.numeric(overview_raw_table$Subjects)))} participants enrolled across
{nrow(overview_raw_table)} sites. {red_kris} Site-KRI combinations have been flagged as red across {overview_raw_table %>% filter(.data$`Red KRIs` != 0) %>% nrow()} sites as shown in the Study Overview Table above.</div>
  - <div>{overview_raw_table %>% filter(.data$`Red KRIs` != 0) %>% nrow()} sites have at least one red KRI</div>
  - <div>{overview_raw_table %>% filter(.data$`Red KRIs` != 0 | .data$`Amber KRIs` != 0) %>% nrow()} sites have at least one red or amber KRI</div>
  - <div>{overview_raw_table %>% filter(.data$`Red KRIs` == 0 & .data$`Amber KRIs` == 0) %>% nrow()} sites have neither red nor amber KRIs and are not shown</div>"), sep = "\n")
  } else if (report == "country") {
    cat(glue::glue("<div>As of {status_study$gsm_analysis_date}, {status_study$studyid} has {round(sum(as.numeric(overview_raw_table$Subjects)))} participants enrolled across
{nrow(overview_raw_table)} countries. {red_kris} Country-KRI combinations have been flagged as red across {overview_raw_table %>% filter(.data$`Red KRIs` != 0) %>% nrow()} countries as shown in the Study Overview Table above.</div>
  - <div>{overview_raw_table %>% filter(.data$`Red KRIs` != 0) %>% nrow()} countries have at least one red KRI</div>
  - <div>{overview_raw_table %>% filter(.data$`Red KRIs` != 0 | .data$`Amber KRIs` != 0) %>% nrow()} countries have at least one red or amber KRI</div>
  - <div>{overview_raw_table %>% filter(.data$`Red KRIs` == 0 & .data$`Amber KRIs` == 0) %>% nrow()} countries have neither red nor amber KRIs</div>"), sep = "\n")
  }
}

#' Extrapolate study snapshot date and number of patients in study
#' @param status_study `df` a dataframe containing status of study pulled from `params$status_study` in report
#' @importFrom glue glue
#' @export
#' @keywords internal
GetSnapshotDate <- function(status_study) {
  output <- list()
  output$subjects <- status_study[["enrolled_participants_ctms"]]
  if ("gsm_analysis_date" %in% names(status_study)) {
    output$snapshot_date <- status_study$gsm_analysis_date
  } else {
    output$snapshot_date <- Sys.Date()
  }

  cat(glue::glue(
    '\n
    ---
    date: "Snapshot Date: {output$snapshot_date}"
    ---
    \n
    '
  ))

  return(output)
}

#' Extrapolate study snapshot date and number of patients in study
#' @param data `list` a list containing active assessments
#' @export
#' @keywords internal
MakeErrorLog <- function(data) {
  error <- Study_AssessmentReport(data)

  error_table <- error$dfSummary %>%
    arrange(desc(.data$notes), .data$assessment) %>%
    rename(
      "Assessment" = "assessment",
      "Step" = "step",
      "Check" = "check",
      "Domain" = "domain",
      "Notes" = "notes"
    )

  return(DT::datatable(error_table))
}


#' Compile QTL summary results into data frame
#' @param lAssessments `list` a list containing active assessments
#' @importFrom purrr imap_dfr
#' @export
#' @keywords internal
qtl_summary <- function(lAssessments) {
  purrr::map_df(lAssessments, function(data) {
    data$lResults$lData$dfSummary %>%
      bind_rows()
  }, .id = "workflowid")
}


#' Compile QTL analysis results into data frame
#' @param lAssessments `list` a list containing active assessments
#' @param results_summary compiled results summary from `qtl_summary()`
#' @importFrom purrr imap_dfr
#' @export
#' @keywords internal
qtl_analysis <- function(lAssessments, results_summary) {
  output <- purrr::map_df(lAssessments, function(data) {
    data$lResults$lData$dfAnalyzed %>%
      bind_rows()
  }, .id = "workflowid") %>%
    left_join(results_summary) %>%
    rename_with(toTitleCase)

  output[sapply(output, is.numeric)] <- round(output[sapply(output, is.numeric)], digits = 2)

  return(output)
}
