#' {experimental} Update parameters for workflow
#'
#' @param lWorkflow `list` Object returned by `MakeWorkflowList()`
#' @param dfConfig `data.frame` Configuration parameters data.frame; `clindata::config_param`
#' @param dfMeta `data.frame` Metadata parameters data.frame; `gsm::meta_param`
#'
#' @return `list` lWorkflow - modified list.
#'
#' @importFrom purrr map
#'
#'
#' @export
UpdateParams <- function(lWorkflow, dfConfig, dfMeta) {
  # join config_param and meta_param ----------------------------------------
  # filter all_params for value (user-provided value) that is not equal to the default value (gsm-recommended value)
  # mutate as character because clindata version of gsm_version is of class() == "package version" - need to update to character.

  all_param <- left_join(
    dfConfig %>% mutate(index = as.character(.data$index)),
    dfMeta %>% mutate(index = as.character(.data$index)),
    by = c("workflowid", "gsm_version", "param", "index")
  ) %>%
    group_by(.data$workflowid, .data$param) %>%
    mutate(
      value = as.character(.data$value),
      default = as.character(.data$default),
      flag = any(.data$value != .data$default)
    ) %>%
    ungroup() %>%
    filter(.data$flag) %>%
    select(-.data$flag)


  # update list -------------------------------------------------------------
  # lWorkflow list is only updated when different values are found
  # loop through different values and modify list

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
            params_to_change_values <- split(params_to_change_values, params_to_change_values$param) %>%
              purrr::map(~ .x %>% pull(value))

            if (any(params_to_change %in% names(lWorkflow[[kri]]$steps[[index]]$params))) {
              params <- params_to_change[params_to_change %in% names(lWorkflow[[kri]]$steps[[index]]$params)]

              for (param_name in params) {
                lWorkflow[[kri]]$steps[[index]]$params[[param_name]] <-
                  as.numeric(params_to_change_values[[param_name]]) %>% sort()
              }
            }
          }
        }
      }
    }
  }

  return(lWorkflow)
}
