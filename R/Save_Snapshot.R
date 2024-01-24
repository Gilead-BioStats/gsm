function(lSnapshot, cPath, bCreateDefaultFolder = FALSE, bQuiet = TRUE) {
  stopifnot(
    `[ cPath ] does not exist.` = dir.exists(cPath),
    `Parameter \`lSnapshot\` must contain the named list \`lSnapshot\`` = "lSnapshot" %in%
      names(lSnapshot)
  )
  if (bCreateDefaultFolder) {
    folder_name <- as.character(Sys.Date())
    full_path <- paste0(cPath, "/", folder_name)
    dir.create(full_path)
  } else {
    full_path <- cPath
  }
  if (!bQuiet) {
    cli::cli_alert_info("Saving { length(lSnapshot$lSnapshot) } snapshots to { .file { cPath } }")
  }
  purrr::iwalk(lSnapshot$lSnapshot, ~ utils::write.csv(.x, file = paste0(
    full_path,
    "/", .y, ".csv"
  ), row.names = FALSE))
  if (!bQuiet) {
    cli::cli_alert_info("Saving snapshot object as { .file snapshot.rds } to { .file { cPath } }")
  }
  saveRDS(lSnapshot,
    file = paste0(full_path, "/snapshot.rds"),
    compress = TRUE
  )
}
