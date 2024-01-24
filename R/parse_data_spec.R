function (content = NULL, file = NULL) {
    if (is.null(content)) {
        if (file.exists(file)) {
            content <- yaml::read_yaml(file)
        }
        else {
            warning(paste0("[ ", file, " ] does not exist."))
            return(NULL)
        }
    }
    domains <- names(content)
    domain_list <- list()
    for (domain in domains) {
        spec <- content[[domain]]
        col_keys <- spec %>% unlist() %>% unique()
        spec_tbl <- tibble::tibble(domain = domain, col_key = col_keys)
        for (metadatum in names(spec)) {
            spec_tbl[[metadatum]] <- spec_tbl$col_key %in% spec[[metadatum]]
        }
        domain_list[[domain]] <- spec_tbl
    }
    spec <- domain_list %>% dplyr::bind_rows()
    spec[is.na(spec)] <- FALSE
    spec
}
