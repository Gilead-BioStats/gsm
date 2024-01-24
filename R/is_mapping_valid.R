function (df, mapping, spec, bQuiet = TRUE) {
    tests_if <- list(is_data_frame = list(status = NA, warning = NA), 
        has_required_params = list(status = NA, warning = NA), 
        spec_is_list = list(status = NA, warning = NA), mapping_is_list = list(status = NA, 
            warning = NA), mappings_are_character = list(status = NA, 
            warning = NA), has_expected_columns = list(status = NA, 
            warning = NA), columns_have_na = list(status = NA, 
            warning = NA), columns_have_empty_values = list(status = NA, 
            warning = NA), cols_are_unique = list(status = NA, 
            warning = NA))
    if (!is.data.frame(df)) {
        tests_if$is_data_frame$status <- FALSE
        tests_if$is_data_frame$warning <- "df is not a data.frame()"
        dim <- NA
    }
    else {
        tests_if$is_data_frame$status <- TRUE
        dim <- dim(df)
    }
    if (!is.list(mapping)) {
        tests_if$mapping_is_list$status <- FALSE
        tests_if$mapping_is_list$warning <- "mapping is not a list()"
    }
    else {
        tests_if$mapping_is_list$status <- TRUE
    }
    if (!is.list(spec)) {
        tests_if$spec_is_list$status <- FALSE
        tests_if$mappings_are_character$status <- FALSE
        tests_if$has_expected_columns$status <- FALSE
        tests_if$spec_is_list$warning <- "spec is not a list()"
        tests_if$mappings_are_character$warning <- "spec is not a list()"
        tests_if$has_expected_columns$warning <- "spec is not a list()"
    }
    else {
        tests_if$spec_is_list$status <- TRUE
    }
    if (tests_if$spec_is_list$status) {
        if (!all(spec$vRequired %in% names(mapping))) {
            missing_params <- paste(spec$vRequired[!(spec$vRequired %in% 
                names(mapping))], collapse = ", ")
            tests_if$has_required_params$status <- FALSE
            tests_if$has_required_params$warning <- paste0("\"mapping\" does not contain required parameters: ", 
                missing_params)
        }
        else {
            tests_if$has_required_params$status <- TRUE
        }
        colParams <- spec$vRequired %>% stringr::str_subset("[c|C]ol$")
        colNames <- unlist(unname(mapping[colParams]))
        if (!all(is.character(colNames))) {
            tests_if$mappings_are_character$status <- FALSE
            warning <- "Non-character column names found in mapping"
            warning_cols <- colNames[!is.character(colNames)]
            tests_if$mappings_are_character$warning <- paste0(warning, 
                ": ", paste(warning_cols, collapse = ", "))
        }
        else {
            tests_if$mappings_are_character$status <- TRUE
        }
        if (!all(colNames %in% names(df))) {
            tests_if$has_expected_columns$status <- FALSE
            warning_cols <- paste(colNames[!colNames %in% names(df)], 
                collapse = ", ")
            warning <- paste0("the following columns not found in df: ", 
                warning_cols)
            tests_if$has_expected_columns$warning <- warning
        }
        else {
            tests_if$has_expected_columns$status <- TRUE
        }
    }
    if (tests_if$has_expected_columns$status) {
        no_check_na <- mapping[spec$vNACols] %>% unname() %>% 
            unlist()
        check_na <- colNames[!colNames %in% no_check_na]
        if (any(is.na(df[check_na]))) {
            warning <- df %>% summarize(across(all_of(check_na), 
                ~sum(is.na(.)))) %>% tidyr::pivot_longer(everything()) %>% 
                filter(.data$value > 0) %>% mutate(warning = paste0(.data$value, 
                " NA values found in column: ", .data$name))
            tests_if$columns_have_na$status <- FALSE
            warning <- paste(warning$warning, collapse = "\n")
            tests_if$columns_have_na$warning <- warning
        }
        else {
            tests_if$columns_have_na$status <- TRUE
        }
        empty_strings <- sum(purrr::map_dbl(df[check_na], ~sum(as.character(.x) == 
            "" & !is.na(.x))))
        if (empty_strings > 0) {
            warning <- df %>% summarize(across(all_of(check_na), 
                ~sum(as.character(.) == ""))) %>% tidyr::pivot_longer(everything()) %>% 
                filter(.data$value > 0) %>% mutate(warning = paste0(.data$value, 
                " empty string values found in column: ", .data$name))
            tests_if$columns_have_empty_values$status <- FALSE
            warning <- paste(warning$warning, collapse = "\n")
            tests_if$columns_have_empty_values$warning <- warning
        }
        else {
            tests_if$columns_have_empty_values$status <- TRUE
        }
        if (!is.null(spec$vUniqueCols)) {
            unique_cols <- mapping[spec$vUniqueCols] %>% unname() %>% 
                unlist()
            dupes <- purrr::map_lgl(df[unique_cols], ~any(duplicated(.)))
            if (any(dupes)) {
                tests_if$cols_are_unique$status <- FALSE
                warning <- paste0("Unexpected duplicates found in column: ", 
                  names(dupes))
                tests_if$cols_are_unique$warning <- warning
            }
            else {
                tests_if$cols_are_unique$status <- TRUE
            }
        }
        else {
            tests_if$cols_are_unique$status <- TRUE
        }
    }
    else {
        tests_if$cols_are_unique$status <- FALSE
        tests_if$columns_have_na$status <- FALSE
        tests_if$columns_have_empty_values$status <- FALSE
        tests_if$cols_are_unique$warning <- "Unique Column Check not run"
        tests_if$columns_have_na$warning <- "NA check not run"
        tests_if$columns_have_empty_values$warning <- "Empty Value check not run"
    }
    if (bQuiet == FALSE) {
        all_warnings <- tests_if %>% purrr::map(~.x$warning) %>% 
            purrr::keep(~!is.na(.x))
        if (length(all_warnings) > 0) {
            all_warnings <- unlist(unname(all_warnings))
            x <- map(all_warnings, ~cli::cli_alert_danger(cli::col_br_yellow(.)))
        }
    }
    is_valid <- list(status = all(purrr::map_lgl(tests_if, ~.$status)), 
        tests_if = tests_if, dim = dim)
    return(is_valid)
}
