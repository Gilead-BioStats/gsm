#' Parse warnings from the result of Study_Assess.
#'
#' @param lResults
#'
#' @return
#'
#' @examples
#'
#' study <- Study_Assess()
#'
#' warnings <- ParseWarnings(study)
#'
#' @export
ParseWarnings <- function(lResults) {
  lResults %>%
    map(function(kri) {
    kri$checks %>%
      imap(function(workflow, workflow_name) {
        data_checks <- names(workflow)[grep('df', names(workflow))]
        map(data_checks, function(this_data) {
          map_df(workflow[[this_data]]$tests_if, function(x){tibble(status = x$status, warning = x$warning)})
        })

      })
  }) %>%
    imap(function(data, index) {
      bind_rows(unname(data), .id = index) %>%
        pull(warning) %>%
        discard(is.na) %>%
        paste(collapse = "\n")
    }) %>%
    imap_dfr(function(x, y) {
      tibble(notes = x, workflowid = y)
    }) %>%
    filter(notes != "")
}
