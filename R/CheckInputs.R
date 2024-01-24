function (context, dfs, mapping = NULL, spec = NULL, bQuiet = TRUE) {
    if (!bQuiet) {
        cli::cli_h2("Checking Input Data for {.fn {context}}")
    }
    if (is.null(mapping)) {
        mapping <- c(yaml::read_yaml(system.file("mappings", 
            "mapping_rawplus.yaml", package = "gsm")), yaml::read_yaml(system.file("mappings", 
            "mapping_adam.yaml", package = "gsm")), yaml::read_yaml(system.file("mappings", 
            "mapping_edc.yaml", package = "gsm")))
    }
    if (is.null(spec)) {
        spec <- yaml::read_yaml(system.file("specs", paste0(context, 
            ".yaml"), package = "gsm"))
    }
    checks <- purrr::map(names(spec), function(domain) {
        domain_check <- list(df = dfs[[domain]], mapping = mapping[[domain]], 
            spec = spec[[domain]]) %>% purrr::map(~purrr::modify_if(.x, 
            is.null, ~NA))
        check <- gsm::is_mapping_valid(df = domain_check$df, 
            mapping = domain_check$mapping, spec = domain_check$spec, 
            bQuiet = bQuiet)
        return(check)
    }) %>% purrr::set_names(nm = names(spec))
    checks$status <- all(checks %>% purrr::map_lgl(~.x$status))
    checks$mapping <- mapping
    checks$spec <- spec
    if (checks$status) {
        if (!bQuiet) 
            cli::cli_alert_success("No issues found for {.fn {context}}")
    }
    else {
        if (!bQuiet) 
            cli::cli_alert_warning("Issues found for {.fn {context}}")
    }
    return(checks)
}
