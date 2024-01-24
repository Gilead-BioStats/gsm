function (lAssessments = Study_Assess(), dfSite = Site_Map_Raw(), 
    strReportType = "site", bInteractive = TRUE) {
    stopifnot(`strReportType is not 'site', 'country', or 'QTL'` = strReportType %in% 
        c("site", "country", "QTL", "qtl"), `strReportType must be length 1` = length(strReportType) == 
        1)
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
    study <- keep(study, function(x) x$bStatus == TRUE)
    reference_table <- make_reference_table(study)
    overview_table <- make_overview_table(study)
    if (!is.null(dfSite)) {
        overview_table <- overview_table %>% mutate(Site = as.character(.data$Site)) %>% 
            left_join(dfSite %>% select("siteid", Country = "country", 
                Status = "status"), by = c(Site = "siteid")) %>% 
            select("Site", "Country", "Status", everything())
        overview_table <- drop_column_with_several_na(overview_table, 
            "Country")
        overview_table <- drop_column_with_several_na(overview_table, 
            "Status")
        site_status_tooltip_hover_info <- dfSite %>% purrr::transpose() %>% 
            purrr::set_names(dfSite$siteid) %>% purrr::imap(function(site_data, 
            site_number) {
            site_data_variables_to_pull <- c("pi_number", "pi_first_name", 
                "pi_last_name", "status", "site_active_dt", "is_satellite", 
                "city", "state", "country")
            site_data_variables_to_rename <- c("PI Number", "PI First Name", 
                "PI Last Name", "Site Status", "Site Active Date", 
                "Satellite", "City", "State", "Country")
            tooltip_site_data <- Filter(length, site_data[names(site_data) %in% 
                site_data_variables_to_pull]) %>% bind_rows() %>% 
                mutate(across(everything(), ~as.character(.))) %>% 
                rename(any_of(setNames(site_data_variables_to_pull, 
                  site_data_variables_to_rename))) %>% pivot_longer(everything()) %>% 
                mutate(string = glue::glue("{name}: {value}", 
                  sep = "\n")) %>% summarise(string = paste(.data$string, 
                collapse = "\n")) %>% pull(.data$string)
            return(list(info = tooltip_site_data))
        })
    }
    abbreviation_lookup <- create_lookup_table(table = overview_table, 
        select_columns = c("abbreviation", "value"))
    metric_lookup <- create_lookup_table(table = overview_table, 
        select_columns = c("metric", "value"))
    hovertext_lookup <- tibble::enframe(abbreviation_lookup) %>% 
        mutate(name = paste0(.data$name, "_hovertext")) %>% tibble::deframe()
    reference_table <- reference_table %>% rename(any_of(hovertext_lookup)) %>% 
        select("Site", ends_with("_hovertext"))
    overview_table <- overview_table %>% rename(any_of(abbreviation_lookup)) %>% 
        arrange(.data$Site) %>% left_join(reference_table, by = "Site")
    if (!is.null(dfSite)) {
        if ("enrolled_participants" %in% names(dfSite)) {
            if (strReportType == "site") {
                overview_table[["Subjects"]] <- overview_table$Site %>% 
                  map_int(~{
                    if (.x %in% dfSite$siteid) {
                      dfSite %>% filter(.data$siteid == .x) %>% 
                        pull(.data$enrolled_participants)
                    }
                    else {
                      return(NA)
                    }
                  })
            }
            else if (strReportType == "country") {
                dfCountry <- Country_Map_Raw(dfSite)
                overview_table[["Subjects"]] <- overview_table$Site %>% 
                  map_int(~{
                    if (.x %in% dfCountry$country) {
                      dfCountry %>% filter(.data$country == .x) %>% 
                        pull(.data$enrolled_participants)
                    }
                    else {
                      return(NA)
                    }
                  })
            }
            else if (strReportType %in% c("QTL", "qtl")) {
                overview_table[["Subjects"]] <- sum(dfSite$enrolled_participants, 
                  na.rm = TRUE)
            }
            overview_table <- relocate(overview_table, "Subjects", 
                .before = "Red KRIs")
        }
    }
    if (bInteractive) {
        n_headers <- ncol(overview_table %>% select(-ends_with("_hovertext")))
        kri_index <- n_headers - length(study)
        headerCallback <- glue::glue("\n    function(thead, data, start, end, display) {\n      var tooltips = ['{{paste(names(metric_lookup), collapse = \"', '\")}'];\n      for (var i={{kri_index}; i<{{n_headers}; i++) {\n        $('th:eq('+i+')', thead).attr('title', tooltips[i-{{kri_index}]);\n      }\n    }\n    ", 
            .open = "{{")
        tooltipCallback <- "\n    function() {\n      let overviewTable = document.querySelector('.tbl-rbqm-study-overview')\n      let tdElements = overviewTable.querySelectorAll('td')\n\n      tdElements.forEach(function(td) {\n        var titleElement = td.querySelector('title');\n        if (titleElement) {\n          td.setAttribute('title', titleElement.innerHTML);\n        }\n      });\n    }\n  "
        overview_table <- overview_table %>% mutate(across(names(abbreviation_lookup), 
            ~purrr::imap(.x, function(value, index) {
                kri_directionality_logo(value, title = overview_table[[paste0(cur_column(), 
                  "_hovertext")]][[index]])
            })))
        if (!is.null(dfSite)) {
            if (all(c("Country", "Status") %in% names(overview_table))) {
                overview_table <- overview_table %>% mutate(across("Site", 
                  ~purrr::imap(.x, function(value, index) {
                    paste0(value, htmltools::tags$title(site_status_tooltip_hover_info[[value]]$info))
                  })))
            }
        }
        overview_table <- overview_table %>% arrange(desc(.data$`Red KRIs`), 
            desc(.data$`Amber KRIs`)) %>% select(-ends_with("_hovertext"))
        if (strReportType == "country") {
            overview_table <- overview_table %>% rename(Country = "Site")
        }
        end_of_red_kris <- which(overview_table$`Red KRIs` == 
            0)[1] - 1
        end_of_red_and_amber_kris <- which(overview_table$`Amber KRIs` == 
            0 & overview_table$`Red KRIs` == 0)[1] - 1
        group_type_for_caption <- ifelse(strReportType == "country", 
            "countries", "sites")
        percentage_red <- sprintf("%0.1f%%", end_of_red_kris/nrow(overview_table) * 
            100)
        percentage_red_amber <- sprintf("%0.1f%%", end_of_red_and_amber_kris/nrow(overview_table) * 
            100)
        overview_table_flagged_caption <- glue::glue("\n        {end_of_red_kris} of {nrow(overview_table)} {group_type_for_caption} with at least one <strong>red</strong> KRI ({percentage_red} of total).<br>\n        {end_of_red_and_amber_kris} of {nrow(overview_table)} {group_type_for_caption} with at least one <strong>red or amber</strong> KRI ({percentage_red_amber} of total).\n    ")
        if (strReportType %in% c("country", "qtl", "QTL")) {
            lengthMenuOptions <- NULL
        }
        else {
            lengthMenuOptions <- list(c(end_of_red_kris, end_of_red_and_amber_kris, 
                -1), c("Red", "Red & Amber", "All"))
        }
        overview_table <- overview_table %>% DT::datatable(class = "compact tbl-rbqm-study-overview", 
            rownames = FALSE, escape = FALSE, caption = HTML(overview_table_flagged_caption), 
            options = list(language = list(lengthMenu = paste0(if (strReportType == 
                "site") {
                "Sites Containing _MENU_ "
            } else if (strReportType == "country") {
                "View _MENU_  Countries"
            }, table_dropdown_label)), columnDefs = list(list(className = "dt-center", 
                targets = 0:(n_headers - 1), orderable = FALSE)), 
                headerCallback = JS(headerCallback), drawCallback = JS(tooltipCallback), 
                pageLength = ifelse(strReportType == "site", 
                  end_of_red_kris, nrow(overview_table)), lengthMenu = lengthMenuOptions, 
                searching = FALSE, dom = "lf", info = FALSE))
    }
    else {
        overview_table <- overview_table %>% select(-ends_with("_hovertext"))
        if (strReportType == "country") {
            overview_table <- overview_table %>% rename(Country = "Site")
        }
        if (strReportType == "QTL") {
            overview_table <- overview_table %>% rename(Study = "Site")
        }
    }
    return(overview_table)
}
