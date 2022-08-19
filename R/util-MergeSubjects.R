#' Merge Domain data with subject-level data
#'
#' @param dfDomain Subject-level domain data containing one record per participant.
#' @param dfSUBJ Subject level data often using ADSL-like data. Should include one record per participant for each participant included in the analysis population (all other participants should be dropped before calling mergeSubjects)
#' @param strIDCol name of ID Column - default='SubjectID'
#' @param vFillZero Columns from dfDomain to fill with zeros when no matching row is found in for an ID in dfSUBJ
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one record per strIDCol.
#'
#'
#' @examples
#' MergeSubjects(
#'   dfDomain = clindata::rawplus_consent,
#'   dfSUBJ = clindata::rawplus_dm,
#'   strIDCol = "SubjectID"
#' )
#'
#' @importFrom cli cli_alert_info cli_alert_warning
#' @importFrom tidyr replace_na
#'
#' @export

MergeSubjects <- function(
    dfDomain,
    dfSUBJ,
    strIDCol = "SubjectID",
    vFillZero = NULL,
    bQuiet = TRUE
) {
  if (!bQuiet) cli_alert_info("Intializing merge of domain and subject data")

  is_domain_valid <- gsm::is_mapping_valid(
    df = dfDomain,
    mapping = list("strIDCol" = strIDCol),
    spec = list(
      vUniqueCols = "strIDCol",
      vRequired = "strIDCol"
    ),
    bQuiet = bQuiet
  )

  is_subjects_valid <- gsm::is_mapping_valid(
    df = dfSUBJ,
    mapping = list("strIDCol" = strIDCol),
    spec = list(
      vUniqueCols = "strIDCol",
      vRequired = "strIDCol"
    ),
    bQuiet = bQuiet
  )

  stopifnot(
    "Errors found in dfDomain" = is_domain_valid$status,
    "Errors found in dfSUBJ" = is_subjects_valid$status,
    "bQuiet must be TRUE or FALSE" = is.logical(bQuiet)
  )

  if (!is.null(vFillZero)) {
    stopifnot(
      "Columns specified in vFillZero not found in dfDomain" = all(vFillZero %in% names(dfDomain)),
      is.character(vFillZero)
    )
  }

  # Throw a warning if there are ID values in dfDomain that are not found in dfSUBJ
  subject_ids <- dfSUBJ[[strIDCol]]
  domain_ids <- dfDomain[[strIDCol]]
  domain_only_ids <- domain_ids[!domain_ids %in% subject_ids]
  if (length(domain_only_ids > 0)) {
    if (!bQuiet) {
      cli::cli_alert_warning(
        paste0(
          length(domain_only_ids),
          " ID(s) in domain data not found in subject data.\nAssociated rows will not be included in merged data."
        )
      )
    }
  }

  # Print a message if rows in dfSUBJ are not found in dfDomain
  subject_only_ids <- subject_ids[!subject_ids %in% domain_ids]
  if (length(subject_only_ids > 0)) {
    if (!bQuiet) {
      cli::cli_alert_info(
        paste0(
          length(subject_only_ids),
          " ID(s) in subject data not found in domain data.",
          ifelse(
            is.null(vFillZero),
            "These participants will have NA values imputed for all domain data columns:",
            paste0(
              "\nThese participants will have 0s imputed for the following domain data columns: ",
              paste(vFillZero, sep = ", "),
              ".\nNA's will be imputed for all other columns."
            )
          )
        )
      )
    }
  }

  if (class(dfDomain[[strIDCol]]) != "character") {
    dfDomain[[strIDCol]] <- as.character(dfDomain[[strIDCol]])
  }

  if (class(dfSUBJ[[strIDCol]]) != "character") {
    dfSUBJ[[strIDCol]] <- as.character(dfSUBJ[[strIDCol]])
  }

  dfOut <- left_join(dfSUBJ, dfDomain, by = strIDCol)
  for (col in vFillZero) {
    dfOut[[col]] <- tidyr::replace_na(dfOut[[col]], 0)
  }

  return(dfOut)
}
