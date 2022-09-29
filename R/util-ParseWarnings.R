#' Parse warnings from the result of Study_Assess.
#'
#' @param lResults `list` List returned from `gsm::Study_Assess()`.
#'
#' @return `data.frame` With columns `notes` and `workflowid`.
#'
#' @examples
#'
#' study <- Study_Assess()
#'
#' warnings <- ParseWarnings(study)
#'
#' @importFrom purrr map imap map_df discard imap_dfr
#'
#' @export
ParseWarnings <- function(lResults) {

  lResults %>%
   purrr::map(function(kri) {
    kri$lChecks %>%
      purrr::imap(function(workflow, workflow_name) {
        data_checks <- names(workflow)[grep('df', names(workflow))]
        purrr::map(data_checks, function(this_data) {
          purrr::map_df(workflow[[this_data]]$tests_if, function(x){dplyr::tibble(status = x$status, warning = x$warning)})
        })

      })
  }) %>%
    purrr::imap(function(data, index) {
      dplyr::bind_rows(unname(data), .id = index) %>%
        dplyr::pull(warning) %>%
        purrr::discard(is.na) %>%
        paste(collapse = "\n")
    }) %>%
    purrr::imap_dfr(function(x, y) {
      dplyr::tibble(notes = x, workflowid = y)
    }) %>%
    dplyr::filter(notes != "")
}
