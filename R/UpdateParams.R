function(lWorkflow, dfConfig, dfMeta) {
  all_param <- left_join(dfConfig %>% mutate(index = as.character(.data$index)),
    dfMeta %>% mutate(index = as.character(.data$index)),
    by = c("workflowid", "gsm_version", "param", "index")
  ) %>%
    group_by(.data$workflowid, .data$param) %>%
    mutate(
      value = as.character(.data$value),
      default = as.character(.data$default), flag = any(.data$value !=
        .data$default)
    ) %>%
    ungroup() %>%
    filter(.data$flag) %>%
    select(-"flag")
  if (nrow(all_param) > 0) {
    all_param <- split(all_param, all_param$workflowid)
    for (kri in names(lWorkflow)) {
      for (index in 1:length(lWorkflow[[kri]]$steps)) {
        if ("params" %in% names(lWorkflow[[kri]]$steps[[index]])) {
          if (!is.null(all_param[[kri]])) {
            params_to_change <- all_param[[kri]] %>%
              pull(.data$param) %>%
              unique()
            params_to_change_values <- all_param[[kri]]
            params_to_change_values <- split(
              params_to_change_values,
              params_to_change_values$param
            ) %>% purrr::map(~ .x %>%
              pull(value))
            if (any(params_to_change %in% names(lWorkflow[[kri]]$steps[[index]]$params))) {
              params <- params_to_change[params_to_change %in%
                names(lWorkflow[[kri]]$steps[[index]]$params)]
              for (param_name in params) {
                lWorkflow[[kri]]$steps[[index]]$params[[param_name]] <- as.numeric(params_to_change_values[[param_name]]) %>%
                  sort()
              }
            }
          }
        }
      }
    }
  }
  return(lWorkflow)
}
