#' Remove invalid Subject IDs
#'
#' @param df `data.frame` data frame with column for subject ID
#' @param strDomain `character` domain name of data frame
#' @param strIDCol `character` name of subject ID Column; Default: `"SubjectID"`
#' @param strInvalidValues `character` array of invalid subject ID values; Default: `""`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` input data frame with invalid subject ID values removed
#'
#' @examples
#' RemoveInvalidSubjectIDs(
#'   clindata::protdev,
#'   bQuiet = FALSE
#' )
#'
#' @importFrom cli cli_alert_info cli_alert_warning
#' @importFrom dplyr filter
#'
#' @export

RemoveInvalidSubjectIDs <- function(
    df,
    strDomain = 'input',
    strIDCol = "SubjectID",
    strInvalidValues = '',
    bQuiet = TRUE
) {
    message()
  if (!bQuiet)
    cli_alert_info(
      "Removing invalid subject ID values from [ {strDomain} ] data: {sub('^$', '\"\"', strInvalidValues)}."
    )

  stopifnot(
    "[ df ] is not a data frame" = is.data.frame(df),
    "[ strIDCol ] is not character" = is.character(strIDCol),
    "[ df ] does not contain [ strIDCol ]" = strIDCol %in% names(df),
    "[ strInvalidValues ] is not character" = is.character(strInvalidValues),
    "bQuiet must be TRUE or FALSE" = is.logical(bQuiet)
  )

  dfValid <- df %>%
    filter(
        !(.data[[ strIDCol ]] %in% strInvalidValues)
    )

  if (!bQuiet) {
    nInvalidRows <- nrow(df) - nrow(dfValid)

    if (nInvalidRows > 0)
        cli::cli_alert_warning('{nInvalidRows} rows with invalid subject IDs removed from [ {strDomain} ] data.')
    else
        cli::cli_alert_info('No invalid subject IDs found in [ {strDomain} ] data.')
  }

  dfValid
}
