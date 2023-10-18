#' `r lifecycle::badge("stable")`
#'
#' Overview Table - Create summary of red and amber KRIs for a study.
#'
#' @param lAssessments `list` The output of running [gsm::Study_Assess()].
#' @param dfSite `data.frame`
#' @param strReportType `character` The type of report to be generated. Valid values:
#'   - `"site"` for site-level KRI summary (default)
#'   - `"country"` for country-level KRI summary
#' @param bInteractive `logical` Display interactive widget? Default: `TRUE`.
#'
#' @importFrom DT datatable
#' @importFrom glue glue
#' @importFrom purrr map reduce
#' @importFrom stats na.omit
#' @importFrom tidyr unite
#'
#' @examples
#' \dontrun{
#' lAssessments <- Study_Assess()
#' Overview_Table(lAssessments)
#' Overview_Table(lAssessments, strReportType = "country")
#' }
#'
#' @export
Overview_Table <- function(
  lAssessments = Study_Assess(),
  dfSite = Site_Map_Raw(),
  strReportType = "site",
  bInteractive = TRUE
) {
  # input check
  stopifnot(
    "strReportType is not 'site', 'country', or 'QTL'" = strReportType %in% c("site", "country", "QTL", "qtl"),
    "strReportType must be length 1" = length(strReportType) == 1
  )


  # filter based on report type ---------------------------------------------
  if (strReportType == "site") {
    grep_value <- "kri"
    table_dropdown_label <- "Flags"
  }

  if (strReportType == "country") {
    grep_value <- "cou"
    table_dropdown_label <- NULL
  }

  if (strReportType %in% c("QTL", "qtl")) {
    grep_value <- "qtl"
    table_dropdown_label <- NULL
  }

  study <- lAssessments[grep(grep_value, names(lAssessments))]

  # only keep KRIs that were successfully run
  study <- keep(study, function(x) x$bStatus == TRUE)

  # create reference table --------------------------------------------------
  reference_table <- make_reference_table(study)

  # create overview table ---------------------------------------------------
  overview_table <- make_overview_table(study)

  # add `Active` column if CTMS data exists ---------------------------------
  # if study_site data.frame is passed through from CTMS.
  # add `Active` column
  if (!is.null(dfSite)) {
    overview_table <- overview_table %>%
      mutate(
        Site = as.character(.data$Site)
      ) %>%
      left_join(
        dfSite %>%
          mutate(site_num = as.character(.data[[Read_Mapping()$dfSITE$strSiteCol]])) %>%
          select("site_num", "Country" = "country", "Status" = "status"),
        by = c("Site" = "site_num")
      ) %>%
      select(
        "Site",
        "Country",
        "Status",
        everything()
      )

    # `Country` and `Status` columns are joined on siteid
    # -- CTMS data does not have a standard derivation for siteid yet
    # -- this ensures that columns will not be passed through with all NA
    # -- current (arbitrary) limit is to drop column if >50% of rows are NA
    overview_table <- drop_column_with_several_na(overview_table, "Country")
    overview_table <- drop_column_with_several_na(overview_table, "Status")

    site_status_tooltip_hover_info <- dfSite %>%
      purrr::transpose() %>%
      purrr::set_names(dfSite$site_num) %>%
      purrr::imap(function(site_data, site_number) {
        site_data_variables_to_pull <- c(
          "pi_number",
          "pi_first_name",
          "pi_last_name",
          "status",
          "site_active_dt",
          "is_satellite",
          "city",
          "state",
          "country"
        )

        site_data_variables_to_rename <- c(
          "PI Number",
          "PI First Name",
          "PI Last Name",
          "Site Status",
          "Site Active Date",
          "Satellite",
          "City",
          "State",
          "Country"
        )

        tooltip_site_data <- Filter(length, site_data[names(site_data) %in% site_data_variables_to_pull]) %>%
          bind_rows() %>%
          mutate(across(everything(), ~ as.character(.))) %>%
          rename(any_of(setNames(site_data_variables_to_pull, site_data_variables_to_rename))) %>%
          pivot_longer(everything()) %>%
          mutate(
            string = glue::glue("{name}: {value}", sep = "\n")
          ) %>%
          summarise(
            string = paste(.data$string, collapse = "\n")
          ) %>%
          pull(.data$string)

        return(
          list(
            info = tooltip_site_data
          )
        )
      })
  }

  # create lookup tables ----------------------------------------------------
  abbreviation_lookup <- create_lookup_table(
    table = overview_table,
    select_columns = c("abbreviation", "value")
  )

  metric_lookup <- create_lookup_table(
    table = overview_table,
    select_columns = c("metric", "value")
  )

  hovertext_lookup <- tibble::enframe(abbreviation_lookup) %>%
    mutate(
      name = paste0(.data$name, "_hovertext")
    ) %>%
    tibble::deframe()

  reference_table <- reference_table %>%
    rename(any_of(hovertext_lookup)) %>%
    select(
      "Site",
      ends_with("_hovertext")
    )

  # Rename columns from KRI name to KRI abbreviation.
  overview_table <- overview_table %>%
    rename(any_of(abbreviation_lookup)) %>%
    arrange(.data$Site) %>%
    left_join(
      reference_table,
      by = "Site"
    )

  # TODO: this could disagree with `status_site$enrolled_participants`
  # Add # of subjects to overview table.
  if (!is.null(dfSite)) {
    if ("enrolled_participants" %in% names(dfSite)) {
      if (strReportType == "site") {
        overview_table[["Subjects"]] <- overview_table$Site %>%
          map_int(~ {
            if (.x %in% dfSite$siteid) {
              dfSite %>%
                filter(.data$siteid == .x) %>%
                pull(.data$enrolled_participants)
            } else {
              return(NA)
            }
          })
      } else if (strReportType == "country") {
        dfCountry <- Country_Map_Raw(dfSite)

        overview_table[["Subjects"]] <- overview_table$Site %>%
          map_int(~ {
            if (.x %in% dfCountry$country) {
              dfCountry %>%
                filter(.data$country == .x) %>%
                pull(.data$enrolled_participants)
            } else {
              return(NA)
            }
          })
      } else if (strReportType %in% c("QTL", "qtl")) {
        overview_table[["Subjects"]] <- sum(dfSite$enrolled_participants, na.rm = TRUE)
      }

      overview_table <- relocate(
        overview_table,
        "Subjects",
        .before = "Red KRIs"
      )
    }
  }

  # HTML table --------------------------------------------------------------
  if (bInteractive) {
    n_headers <- ncol(overview_table %>% select(-ends_with("_hovertext")))
    kri_index <- n_headers - length(study)

    # Add tooltips to column headers.
    headerCallback <- glue::glue(
      "
    function(thead, data, start, end, display) {
      var tooltips = ['{{paste(names(metric_lookup), collapse = \"', '\")}'];
      for (var i={{kri_index}; i<{{n_headers}; i++) {
        $('th:eq('+i+')', thead).attr('title', tooltips[i-{{kri_index}]);
      }
    }
    ",
      .open = "{{"
    )

    # Enable tooltips for cells
    tooltipCallback <- "
    function() {
      let overviewTable = document.querySelector('.tbl-rbqm-study-overview')
      let tdElements = overviewTable.querySelectorAll('td')

      tdElements.forEach(function(td) {
        var titleElement = td.querySelector('title');
        if (titleElement) {
          td.setAttribute('title', titleElement.innerHTML);
        }
      });
    }
  "

    # add hovertext to KRI signals
    overview_table <- overview_table %>%
      mutate(across(
        names(abbreviation_lookup),
        ~ purrr::imap(.x, function(value, index) {
          kri_directionality_logo(value, title = overview_table[[paste0(cur_column(), "_hovertext")]][[index]])
        })
      ))

    # if CTMS data exists...
    if (!is.null(dfSite)) {
      # ... and `Country` and `Status` columns were correctly merged
      if (all(c("Country", "Status") %in% names(overview_table))) {
        # assign hovertext to `Site` column
        overview_table <- overview_table %>%
          mutate(
            across(
              "Site",
              ~ purrr::imap(.x, function(value, index) {
                # add hovertext containing site information to Site rows
                paste0(
                  value,
                  htmltools::tags$title(site_status_tooltip_hover_info[[value]]$info)
                )
              })
            )
          )
      }
    }

    overview_table <- overview_table %>%
      arrange(desc(.data$`Red KRIs`), desc(.data$`Amber KRIs`)) %>%
      select(-ends_with("_hovertext"))

    if (strReportType == "country") {
      overview_table <- overview_table %>%
        rename("Country" = "Site")
    }

    # find the index of the first occurance of `Amber KRIs` == 0 & `Red KRIs` == 0
    # -- this happens after the table is sorted (descending) on these columns
    # -- this will only show the sites with flagged KRIs in the table, with a "show all" option

    end_of_red_kris <- which(overview_table$`Red KRIs` == 0)[1] - 1
    end_of_red_and_amber_kris <- which(overview_table$`Amber KRIs` == 0 & overview_table$`Red KRIs` == 0)[1] - 1

    # caption to show number of flagged out of total
    group_type_for_caption <- ifelse(strReportType == "country", "countries", "sites")

    # calculate and format the percentage of flagged sites of the total
    percentage_red <- sprintf("%0.1f%%", end_of_red_kris / nrow(overview_table) * 100)
    percentage_red_amber <- sprintf("%0.1f%%", end_of_red_and_amber_kris / nrow(overview_table) * 100)

    # construct the caption with this format:
    # -- 'X' of 'Y' 'GROUP's flagged. (Z% of total).
    overview_table_flagged_caption <- glue::glue("
        {end_of_red_kris} of {nrow(overview_table)} {group_type_for_caption} with at least one <strong>red</strong> KRI ({percentage_red} of total).<br>
        {end_of_red_and_amber_kris} of {nrow(overview_table)} {group_type_for_caption} with at least one <strong>red or amber</strong> KRI ({percentage_red_amber} of total).
    ")


    # let's just show all countries in the drop-down for now
    # countries will probably have less flagged KRIs and are easier to sort/read through
    if (strReportType %in% c("country", "qtl", "QTL")) {
      lengthMenuOptions <- NULL
    } else {
      lengthMenuOptions <- list(
        c(end_of_red_kris, end_of_red_and_amber_kris, -1),
        c("Red", "Red & Amber", "All")
      )
    }


    # HTML/JS options for DT
    overview_table <- overview_table %>%
      DT::datatable(
        class = "compact tbl-rbqm-study-overview",
        rownames = FALSE,
        escape = FALSE,
        caption = HTML(overview_table_flagged_caption),
        options = list(
          language = list(
            lengthMenu = paste0(if (strReportType == "site") {
              "Sites Containing _MENU_ "
            } else if (strReportType == "country") {
              "View _MENU_  Countries"
            }, table_dropdown_label)
          ),
          columnDefs = list(
            list(
              className = "dt-center",
              targets = 0:(n_headers - 1),
              orderable = FALSE
            )
          ),
          headerCallback = JS(headerCallback),
          drawCallback = JS(tooltipCallback),
          pageLength = ifelse(strReportType == "site", end_of_red_kris, nrow(overview_table)),
          lengthMenu = lengthMenuOptions,
          searching = FALSE,
          dom = "lf",
          info = FALSE
        )
      )
  } else {
    overview_table <- overview_table %>%
      select(-ends_with("_hovertext"))

    if (strReportType == "country") {
      overview_table <- overview_table %>%
        rename("Country" = "Site")
    }

    if (strReportType == "QTL") {
      overview_table <- overview_table %>%
        rename("Study" = "Site")
    }
  }

  return(overview_table)
}

assign_tooltip_labels <- function(name) {
  cur_kri <- gsm::meta_workflow %>%
    filter(.data$workflowid == name)

  if (nrow(cur_kri) > 0) {
    return(
      list(
        numerator = cur_kri$numerator,
        denominator = cur_kri$denominator
      )
    )
  } else {
    return(NULL)
  }
}


create_lookup_table <- function(table, select_columns) {
  as_tibble(names(table)) %>%
    left_join(gsm::meta_workflow, by = c("value" = "workflowid")) %>%
    select(all_of(select_columns)) %>%
    stats::na.omit() %>%
    tibble::deframe()
}


drop_column_with_several_na <- function(table, column) {
  if (sum(is.na(table[[column]])) > nrow(table) / 2) {
    cli::cli_alert_info("Detected error during CTMS data merging: {sum(is.na(table[[column]]))} `NA` rows found.")
    cli::cli_alert_info("Dropping `{column}` column from table and proceeding...")

    table <- table %>%
      select(
        -.data[[column]]
      )
  }

  return(table)
}

make_reference_table <- function(study) {
  reference_table <- study %>%
    purrr::map(function(kri) {
      name <- kri$name

      # driven by gsm::meta_workflow
      # if custom workflowids are used, custom labels will not be added
      # TODO: can possibly refine to be driven by custom meta_workflow, but will need some refactoring
      kri_labels <- assign_tooltip_labels(name)

      kri$lResults$lData$dfSummary %>%
        mutate(across(where(is.numeric), function(x) round(x, digits = 3))) %>%
        imap_dfr(function(x, y) {
          if (!is.null(kri_labels)) {
            if (y == "Numerator") {
              y <- kri_labels$numerator
            }

            if (y == "Denominator") {
              y <- kri_labels$denominator
            }
          }

          paste0(y, ": ", x)
        }) %>%
        rowwise() %>%
        tidyr::unite("summary", sep = "\n", remove = FALSE) %>%
        mutate(GroupID = as.character(gsub("GroupID: ", "", .data$GroupID))) %>%
        select("GroupID", "summary") %>%
        rename(!!name := summary)
    }) %>%
    purrr::reduce(left_join, by = "GroupID") %>%
    rowwise() %>%
    mutate("Red KRIs" = {
      x <- c_across(-"GroupID")
      sum(grepl("*Flag: 2|*Flag: -2", x), na.rm = TRUE)
    }) %>%
    mutate("Amber KRIs" = {
      x <- c_across(-c("GroupID", "Red KRIs"))
      sum(grepl("*Flag: 1|*Flag: -1", x), na.rm = TRUE)
    }) %>%
    ungroup() %>%
    mutate(
      "Subjects" = 0
    ) %>%
    select(
      "Site" = "GroupID",
      "Subjects",
      "Red KRIs",
      "Amber KRIs",
      everything()
    ) %>%
    arrange(desc(.data$`Red KRIs`), desc(.data$`Amber KRIs`))

  return(reference_table)
}

make_overview_table <- function(study) {
  overview_table <- study %>%
    purrr::map(function(kri) {
      name <- kri$name

      kri$lResults$lData$dfSummary %>%
        select("GroupID", "Flag") %>%
        rename(!!name := Flag)
    }) %>%
    purrr::reduce(left_join, by = "GroupID") %>%
    rowwise() %>%
    mutate("Red KRIs" = {
      x <- c_across(-"GroupID")
      sum(x %in% c(2, -2))
    }) %>%
    mutate("Amber KRIs" = {
      x <- c_across(-c("GroupID", "Red KRIs"))
      sum(x %in% c(1, -1))
    }) %>%
    ungroup() %>%
    select(
      "Site" = "GroupID",
      "Red KRIs",
      "Amber KRIs",
      everything()
    ) %>%
    arrange(desc(.data$`Red KRIs`), desc(.data$`Amber KRIs`))

  return(overview_table)
}
