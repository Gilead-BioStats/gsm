function(
    lSnapshot, strPath = "./inst/qtl_dummy_data/dummyqtldata.csv",
    bQuiet = TRUE) {
  if (file.exists(strPath) & lSnapshot$bStatus) {
    qtl_old <- utils::read.csv(strPath)
    qtl_new <- lSnapshot$lResults$lData$dfFlagged
    qtl_new$snapshot_date <- as.character(Sys.Date())
    qtl_all <- bind_rows(qtl_old, qtl_new)
    utils::write.csv(qtl_all, strPath, row.names = FALSE)
    utils::write.csv(qtl_all, paste0(
      tools::file_path_sans_ext(strPath),
      " ", Sys.Date(), ".csv"
    ), row.names = FALSE)
  } else if (!file.exists(strPath)) {
    message("csv file not found. Check value provided to `strPath`.")
  } else if (!lSnapshot$bStatus) {
    message("QTL was not run successfully. Check `lSnapshot$bStatus`.")
  }
  if (!bQuiet) {
    cli::cli_alert_success(paste0("File: ", strPath, " updated."))
  }
  if (!bQuiet) {
    cli::cli_alert_success(paste0("File: ", paste0(
      tools::file_path_sans_ext(strPath),
      " ", Sys.Date(), ".csv"
    ), " created."))
  }
}
