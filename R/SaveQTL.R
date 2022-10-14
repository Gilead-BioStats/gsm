#' Title
#'
#' @param lSnapshot
#' @param strPath
#' @param bQuiet
#'
#' @return
#' @export
#'
#' @examples
SaveQTL <- function(lSnapshot,
                    strPath = './inst/dummyqtldata.csv',
                    bQuiet = TRUE) {

  qtl_path <- strPath


    if (file.exists(qtl_path) & lSnapshot$bStatus) {
      # read historical .csv
      qtl_old <- read.csv(qtl_path)

      # grab dfAnalyzed
      qtl_new <- lSnapshot$lResults$lData$dfAnalyzed

      # add date to dfAnalyzed
      qtl_new$date <- as.character(Sys.Date())

      # bind rows
      qtl_all <- bind_rows(qtl_old,qtl_new)

      # overwrite
      write.csv(qtl_all, qtl_path, row.names = FALSE)

      # save recent
      write.csv(qtl_all, paste0(qtl_path, " ", Sys.Date()), row.names = FALSE)
    }

  if (!bQuiet) cli::cli_alert_success(paste0("File: ", basename(qtl_path), " updated."))
  if (!bQuiet) cli::cli_alert_success(paste0("File: ", basename(paste0(qtl_path, " ", Sys.Date())), " created."))

}

