function (snapshot_paths) {
    acceptable_files <- c("meta_param.csv", "meta_workflow.csv", 
        "results_analysis.csv", "results_bounds.csv", "results_summary.csv", 
        "status_param.csv", "status_site.csv", "status_study.csv", 
        "status_workflow.csv")
    output <- purrr::map(snapshot_paths, ~paste0(., "/", acceptable_files)) %>% 
        purrr::set_names(stringr::str_extract(snapshot_paths, 
            "([^/]+$)")) %>% purrr::imap(., ~read.csv(.[file.exists(.)][1], 
        nrows = 1) %>% mutate(foldername = .y)) %>% bind_rows() %>% 
        mutate(snapshot_date = as.Date(.data$gsm_analysis_date)) %>% 
        select("foldername", "snapshot_date")
    return(output)
}
