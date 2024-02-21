#' Make dataframe of covariate workflow mapping
#'
#' @param kri `vector` vector containing kri's to include in data frame ex. `c("kri0001", "kri0002")` defaults to kri's 1:12
#'
#' @export
#'
Covariate_Workflow <- function(kri = sprintf("kri00%02d", 01:12)){
  workflows <- MakeWorkflowList(strNames = kri)

  config <- purrr::map(workflows, function(x) {
    x$config
  }) %>%
    purrr::map(function(x) {
      x$covariates %>% purrr::map( ~ data.frame(.)) %>% purrr::list_rbind()
    }) %>%
    purrr::list_rbind(names_to = "workflowid")

  return(config)
}

