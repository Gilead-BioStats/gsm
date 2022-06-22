#' Utility function for creating analysis strata
#'
#' @param df `data.frame` A data.frame to be filtered, likely within a mapping function.
#' @param strDomain `character` Domain step that is being stratified.
#' @param strCol `character` Domain in `lMapping` that references the column to filter on.
#' @param strVal `character` Domain in `lMapping` that references the value to filter on.
#' @param bReturnChecks `logical` Return input checks from `is_mapping_valid`? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @examples
#' 
#' strata1 <- MakeStrata(
#'   df = clindata::rawplus_ae,
#'   strDomain = 'dfAE'
#'   strCol = "AE_SERIOUS",
#'   strVal = "No"
#' )
#'
#' @return `data.frame` Data frame provided as `df` and filtered on `strCol` == `strVal`.
#' If `bReturnChecks` is `TRUE`, a `list` is returned with a filtered `df`, and a list of checks run on input data (`lChecks`).
#'
#' @importFrom cli cli_alert_info cli_alert_success cli_alert_warning cli_text
#'
#' @export

MakeStrata <- function(df, strDomain, strCol, strVal, bReturnChecks = FALSE, bQuiet = TRUE) {

  # TODO think about if we should keep this or just do a custom check of some kind. 
  lMapping <- list(strStrataCol=strCol, strStrataVal=strVal)
  lSpec <- list(vRequired = c('strStrataCol'))
  check <- gsm::is_mapping_valid(
    df = df, 
    mapping = lMapping, 
    spec = lSpec, 
    bQuiet = bQuiet
  )
  
  checks <- list()
  checks[[strDomain]] <- check
  checks$status <- check$status

  if (check$status) {
    if (!bQuiet) cli::cli_alert_success("No issues found for {strDomain} domain")
  } else {
    if (!bQuiet) cli::cli_alert_warning("Issues found for {strDomain} domain")
  }
  
  if (check$status) {
    if (!bQuiet) cli::cli_text(paste0("Creating Strata for `", strCol, " == '", paste(strVal, collapse = ","),"'`"))

    oldRows <- nrow(df)
    df <- df[df[[strCol]] %in% strVal, ]
    newRows <- nrow(df)
    if (!bQuiet) {
      cli::cli_alert_success("Creating strata for `{strCol}={paste(strVal,sep=',')}`, to drop {oldRows-newRows} rows from {oldRows} to {newRows} rows.")
      if (newRows == 0) cli::cli_alert_warning("WARNING: Filtered data has 0 rows.")
      if (newRows == oldRows) cli::cli_alert_info("NOTE: No rows dropped.")
    }
  }

  if (bReturnChecks) {
    return(list(df = df, lChecks = checks))
  } else {
    return(df)
  }
}
