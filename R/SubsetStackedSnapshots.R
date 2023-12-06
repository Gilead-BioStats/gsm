#' SubsetStackedSnapshots
#'
#' @description
#' This function is used to subset a list of stacked snapshots within [gsm::Make_Snapshot()].
#'
#' @param workflowid `character` workflow ID or `kri_id`.
#'
#'
#' @keywords internal
SubsetStackedSnapshots <- function(workflowid, lStackedSnapshots) {
  subset_snapshots <- purrr::map(lStackedSnapshots, function(x) {

    if ("kri_id" %in% names(x)) {
      x %>%
        filter(
          kri_id == workflowid
        )
    }

  }) %>%
    purrr::discard(is.null)

  return(subset_snapshots)
}

