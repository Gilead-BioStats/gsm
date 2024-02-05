#' SaveQTL
#'
#' `r lifecycle::badge("experimental")`
#'
#' @description
#' Save QTL analysis results to a directory location. The `strPath` argument specifies the filepath, including filename, of the current QTL analysis.
#' Running `SaveQTL` will save a new file with an added row for the single specified QTL analysis. The new file will be named the same as the original file,
#' but will incorporate the run date for version control.
#'
#' @param lSnapshot `list` List returned by [gsm::RunQTL()]
#' @param strPath `character` Path to historical QTL data.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @examples
#' \dontrun{
#' dispQTL <- RunQTL("qtl0006")
#' SaveQTL(dispQTL)
#' }
#'
#' @export
SaveQTL <- function(lSnapshot,
  strPath = "./inst/qtl_dummy_data/dummyqtldata.csv",
  bQuiet = TRUE) {
  if (file.exists(strPath) & lSnapshot$bStatus) {
    # read historical .csv
    qtl_old <- utils::read.csv(strPath)

    # grab dfFlagged
    qtl_new <- lSnapshot$lResults$lData$dfFlagged

    # add date to dfAnalyzed
    qtl_new$snapshot_date <- as.character(Sys.Date())

    # bind rows
    qtl_all <- bind_rows(qtl_old, qtl_new)

    # overwrite
    utils::write.csv(qtl_all, strPath, row.names = FALSE)

    # save recent
    utils::write.csv(qtl_all,
      paste0(
        tools::file_path_sans_ext(strPath),
        " ",
        Sys.Date(),
        ".csv"
      ),
      row.names = FALSE
    )
  } else if (!file.exists(strPath)) {
    message("csv file not found. Check value provided to `strPath`.")
  } else if (!lSnapshot$bStatus) {
    message("QTL was not run successfully. Check `lSnapshot$bStatus`.")
  }

  if (!bQuiet) cli::cli_alert_success(paste0("File: ", strPath, " updated."))
  if (!bQuiet) {
    cli::cli_alert_success(paste0("File: ", paste0(
      tools::file_path_sans_ext(strPath),
      " ",
      Sys.Date(),
      ".csv"
    ), " created."))
  }
}
