#' {experimental} SaveQTL
#'
#' @description
#' Save QTL analysis results to a directory location. The file specified in `strPath` will have an additional row appended for the current QTL analysis,
#' and a separate file will be saved for the single QTL analysis result.
#'
#' @param lSnapshot `list` List returned by [gsm::RunQTL()]
#' @param strPath `character` Path to historical QTL data.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @importFrom cli cli_alert_success
#' @importFrom utils read.csv write.csv
#'
#' @examples
#'
#' \dontrun{
#' dispQTL <- RunQTL('qtl0007')
#' SaveQTL(dispQTL)
#' }
#'
#' @export
SaveQTL <- function(lSnapshot,
                    strPath = './inst/dummyqtldata.csv',
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
      write.csv(qtl_all, strPath, row.names = FALSE)

      # save recent
      utils::write.csv(qtl_all, paste0(strPath, " ", Sys.Date()), row.names = FALSE)
    } else if (!file.exists(strPath)) {
      message('csv file not found. Check value provided to `strPath`.')
    } else if (!lSnapshot$bStatus) {
      message('QTL was not run successfully. Check `lSnapshot$bStatus`.')
    }

  if (!bQuiet) cli::cli_alert_success(paste0("File: ", basename(strPath), " updated."))
  if (!bQuiet) cli::cli_alert_success(paste0("File: ", basename(paste0(strPath, " ", Sys.Date())), " created."))

}

