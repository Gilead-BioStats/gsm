function (config = list(config_param = gsm::config_param, config_workflow = gsm::config_workflow), 
    ci_check = FALSE) {
    config <- config %>% purrr::imap(~.x %>% select(gsm_version) %>% 
        mutate(current_gsm_version = as.character(utils::packageVersion("gsm")), 
            data = .y, status = gsm_version == current_gsm_version) %>% 
        unique()) %>% bind_rows()
    if (any(config$status == FALSE)) {
        mismatch <- config %>% filter(.data$status == FALSE) %>% 
            mutate(warning = glue::glue("clindata table: `{data}` has gsm version {gsm_version} and the current gsm version is {current_gsm_version}"))
        for (warning in mismatch$warning) {
            cli::cli_alert_danger(warning)
        }
    }
    else {
        cli::cli_alert_success("gsm versions are equivalent for gsm and clindata.")
    }
    if (ci_check) {
        return(config)
    }
}
