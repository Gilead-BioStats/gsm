function (strDomain = NULL) {
    file_names <- list.files(system.file("mappings", package = "gsm"), 
        pattern = "^mapping_.*\\.yaml$", full.names = TRUE)
    file_names <- setNames(file_names, tools::file_path_sans_ext(basename(file_names)))
    if (is.null(strDomain)) {
        file_names <- file_names[!names(file_names) %in% "mapping_domain"]
    }
    else {
        file_names <- file_names[names(file_names) %in% paste0("mapping_", 
            tolower(strDomain))]
    }
    if (length(file_names) > 0) {
        purrr::map(file_names, ~yaml::read_yaml(.x)) %>% purrr::list_flatten(name_spec = "{inner}")
    }
    else {
        if (is.null(strDomain)) {
            cli::cli_alert_danger("No mappings found.")
        }
        else {
            cli::cli_alert_danger("No mappings found with name{?s}: {.arg {strDomain}}.")
        }
    }
}
