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
#' @param strFileFormat `character` The file format used to save all flat files. Default: `parquet`. Valid options: `parquet` or `csv`.
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
#' @importFrom arrow write_parquet
#'
#' @export
Save_Snapshot <- function(lSnapshot, cPath, bCreateDefaultFolder = FALSE, bQuiet = TRUE, strFileFormat = "parquet") {
  stopifnot(
    "[ cPath ] does not exist." = dir.exists(cPath),
    "Parameter `lSnapshot` must contain the named list `lSnapshot`" = "lSnapshot" %in% names(lSnapshot),
    "[ strFileFormat ] must be 'parquet' or 'csv'" = strFileFormat %in% c("parquet", "csv")
  )

  if (bCreateDefaultFolder) {
    folder_name <- as.character(Sys.Date())

    full_path <- paste0(cPath, "/", folder_name)

    dir.create(full_path)
  } else {
    full_path <- cPath
  }

  if (!bQuiet) cli::cli_alert_info("Saving { length(lSnapshot$lSnapshot) } snapshots to { cPath }")

  switch(strFileFormat,
    csv = {
      purrr::iwalk(lSnapshot$lSnapshot, ~ utils::write.csv(.x, file = paste0(full_path, "/", .y, ".csv"), row.names = FALSE))
    },
    parquet = {
      purrr::iwalk(lSnapshot$lSnapshot, ~ arrow::write_parquet(x = .x, sink = paste0(full_path, "/", .y, ".parquet")))
    }
  )

  if (!bQuiet) cli::cli_alert_info("Saving snapshot object as {.file snapshot.rds} to { cPath }")
  saveRDS(lSnapshot, file = paste0(full_path, "/snapshot.rds"), compress = TRUE)
}
