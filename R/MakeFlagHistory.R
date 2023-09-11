#' MakeFlagHistory
#'
#' @param lStackedSnapshots `list` the return from calling [gsm::]
#'
#' @return `data.frame` of flag and score results by date of snapshot.
#'
#' @importFrom glue glue
#' @importFrom purrr map
#' @importFrom tidyr pivot_longer pivot_wider
#'
#' @export
#'
#' @examples
#'
#' lSnapshot <- Make_Snapshot()
#'
#' lStackedSnapshots <- StackSnapshots(
#'   cPath = system.file("snapshots", "AA-AA-000-0000", package = "gsm"),
#'   lSnapshot = lSnapshot,
#' )
#'
#' dfFlagHistory <- MakeFlagHistory(lStackedSnapshots = lStackedSnapshots)
#'
MakeFlagHistory <- function(lStackedSnapshots) {

  flag_history <- lStackedSnapshots$results_summary %>%
    split(.$workflowid) %>%
    purrr::map(~ {
      .x %>% select(
        workflowid,
        groupid,
        score,
        flag,
        snapshot_date
      ) %>%
        group_by(
          workflowid, groupid
        ) %>%
        mutate(
          snapshot_date = as.Date(snapshot_date),
          snapshot_order = rank(snapshot_date)
        ) %>%
        arrange(
          groupid,
          snapshot_order
        ) %>%
        ungroup() %>%
        tidyr::pivot_longer(
          cols = c("score", "flag")
        ) %>%
        mutate(
          name = glue::glue("prev{name}{snapshot_order}")
        ) %>%
        tidyr::pivot_wider(
          id_cols = c(workflowid, groupid),
          names_from = name,
          values_from = value
        )}) %>%
    purrr::list_rbind()

  return(flag_history)

}
