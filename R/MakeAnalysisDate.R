#' Make Analysis Date
#'
#' @param strAnalysisDate `character` Date that analysis was run. Formatted as YYYY-MM-DD.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#'
#' @examples
#' analysis_date <- MakeAnalysisDate()
#'
#' @return `Date` A date in the format `YYYY-MM-DD`.
#'
#' @importFrom cli cli_alert_warning
#'
#' @export
MakeAnalysisDate <- function(strAnalysisDate = NULL, bQuiet = FALSE) {
  # add gsm_analysis_date to all outputs except {gsm} metadata
  # -- if date is provided, it should be the date that the data was pulled/wrangled.
  # -- if date is NOT provided, it will default to the date that the analysis was run.
  if (!is.null(strAnalysisDate)) {
    # date validation check
    date_is_valid <- try(as.Date(strAnalysisDate), silent = TRUE)

    if (!"try-error" %in% class(date_is_valid) && !is.na(date_is_valid)) {
      gsm_analysis_date <- as.Date(strAnalysisDate)
    } else {
      if (!bQuiet) cli::cli_alert_warning("strAnalysisDate does not seem to be in format YYYY-MM-DD. Defaulting to current date of {Sys.Date()}")
      gsm_analysis_date <- Sys.Date()
    }
  } else {
    gsm_analysis_date <- Sys.Date()
  }

  return(gsm_analysis_date)
}
