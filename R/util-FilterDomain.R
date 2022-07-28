#' Subset a data frame given a mapping
#'
#' @param df `data.frame` A data.frame to be filtered, likely within a mapping function.
#' @param strDomain `character` Domain step that is being filtered.
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name of the column.
#' @param strColParam `character` Domain in `lMapping` that references the column to filter on.
#' @param strValParam `character` Domain in `lMapping` that references the value to filter on.
#' @param bReturnChecks `logical` Return input checks from `is_mapping_valid`? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @examples
#' lMapping <- list(dfAE = list(
#'   strIDCol = "SubjectID", strTreatmentEmergentCol = "AE_TE_FLAG",
#'   strTreatmentEmergentVal = TRUE, strGradeCol = "AE_GRADE",
#'   strSeriousCol = "AE_SERIOUS", strSeriousVal = "Yes"
#' ))
#'
#' te_ae <- FilterDomain(
#'   df = clindata::rawplus_ae,
#'   lMapping = lMapping,
#'   strDomain = "dfAE",
#'   strColParam = "strSeriousCol",
#'   strValParam = "strSeriousVal"
#' )
#'
#' @return `data.frame` Data frame provided as `df` and filtered on `strColParam` == `strValParam`.
#' If `bReturnChecks` is `TRUE`, a `list` is returned with a filtered `df`, and a list of checks run on input data (`lChecks`).
#'
#' @importFrom cli cli_alert_info cli_alert_success cli_alert_warning cli_text
#'
#' @export

FilterDomain <- function(
  df,
  strDomain,
  lMapping,
  strColParam,
  strValParam,
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  if (!bQuiet) cli::cli_h2("Checking Input Data for {.fn FilterDomain}")
  lSpec <- list(vRequired = c(strColParam, strValParam), vNACols = strColParam)
  check <- gsm::is_mapping_valid(df = df, mapping = lMapping[[strDomain]], spec = lSpec, bQuiet = bQuiet)
  checks <- list()
  checks[[strDomain]] <- check
  checks$status <- check$status

  if (check$status) {
    if (!bQuiet) cli::cli_alert_success("No issues found for {strDomain} domain")
  } else {
    if (!bQuiet) cli::cli_alert_warning("Issues found for {strDomain} domain")
  }

  if (check$status) {
    col <- lMapping[[strDomain]][[strColParam]]
    vals <- lMapping[[strDomain]][[strValParam]]
    if (!bQuiet) cli::cli_text(paste0("Filtering on ", col, " == ", paste(vals, collapse = ",")))

    oldRows <- nrow(df)
    df <- df[df[[col]] %in% vals, ]
    newRows <- nrow(df)
    if (!bQuiet) {
      cli::cli_alert_success("Filtered on `{col}={paste(vals,sep=',')}`, to drop {oldRows-newRows} rows from {oldRows} to {newRows} rows.")
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
