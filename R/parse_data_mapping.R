function(content = NULL, file = NULL) {
  if (is.null(content)) {
    if (file.exists(file)) {
      content <- yaml::read_yaml(file)
    } else {
      warning(paste0("[ ", file, " ] does not exist."))
      return(NULL)
    }
  }
  domains <- names(content)
  domain_list <- vector("list", length(domains))
  for (domain in domains) {
    mapping <- content[[domain]]
    mapping_tbl <- mapping %>%
      tibble::enframe(
        name = "col_key",
        value = "col_value"
      ) %>%
      dplyr::mutate(col_value = as.character(.data$col_value)) %>%
      tidyr::unnest(cols = "col_value") %>%
      dplyr::mutate(domain = domain) %>%
      dplyr::select("domain", "col_key", "col_value")
    domain_list[[domain]] <- mapping_tbl
  }
  mapping <- domain_list %>% purrr::reduce(dplyr::bind_rows)
  mapping
}
