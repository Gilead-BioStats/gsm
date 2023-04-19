#' `r lifecycle::badge("experimental")`
#'
#' Save Snapshot
#'
#' @description
#' Save the output of [gsm::Make_Snapshot()] or [gsm::Augment_Snapshot()].
#'
#' @param lSnapshot `list` the output of [gsm::Make_Snapshot()] or [gsm::Augment_Snapshot()].
#' @param cPath `character` a character string indicating a directory to save .csv files; the output of the snapshot.
#' @param bCreateDefaultFolder `logical` default: `FALSE`. If `TRUE`, creates a new folder in the `cPath` directory with the current date (YYYY-MM-DD).
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#'
#' @return `.csv` files and `.rds` file saved to a specified directory.
#'
#' @examples
#' \dontrun{
#'
#' snapshot <- Make_Snapshot()
#' Save_Snapshot(lSnapshot = snapshot, cPath = here::here("data"))
#' }
#'
#' @export
Save_Snapshot <- function(lSnapshot, cPath, bCreateDefaultFolder = FALSE, bQuiet = TRUE) {
  stopifnot(
    "[ cPath ] does not exist." = dir.exists(cPath),
    "Parameter `lSnapshot` must contain the named list `lSnapshot`" = "lSnapshot" %in% names(lSnapshot)
  )

  if (bCreateDefaultFolder) {
    folder_name <- as.character(Sys.Date())

    full_path <- paste0(cPath, "/", folder_name)

    dir.create(full_path)
  } else {
    full_path <- cPath
  }

  if (!bQuiet) cli::cli_alert_info("Saving { length(lSnapshot$lSnapshot) } snapshots to { .file { cPath } }")
  purrr::iwalk(lSnapshot$lSnapshot, ~ utils::write.csv(.x, file = paste0(full_path, "/", .y, ".csv"), row.names = FALSE))

  if (!bQuiet) cli::cli_alert_info("Saving snapshot object as { .file snapshot.rds } to { .file { cPath } }")
  saveRDS(lSnapshot, file = paste0(full_path, "/snapshot.rds"), compress = TRUE)
}
