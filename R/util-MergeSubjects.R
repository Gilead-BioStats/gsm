#' Merge Domain data with subject-level data shell
#'
#' @param dfSubjects Subject level data often using ADSL-like data. Should include one record per participant for each participant included in the analysis population (all other participants should be dropped before calling mergeSubjects)
#' @param dfDomain Subject-level domain data containing one record per participant.
#' @param strIDCol name of ID Column - default='SubjectID'
#' @param vFillZero Columns from dfDomain to fill with zeros when no matching row is found in for an ID in dfSubject
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @return data set with one record per IDCol
#'
#' @importFrom dplyr left_join
#' @importFrom tidyr replace_na
#'
#' @examples
#' MergeSubjects(dfDomain = clindata::rawplus_consent,
#'               dfSubjects = clindata::rawplus_subj,
#'               strIDCol = "SubjectID")
#'
#' @export

MergeSubjects <- function(dfDomain, dfSubjects, strIDCol="SubjectID", vFillZero=NULL, bQuiet=TRUE){
  is_domain_valid <- gsm::is_mapping_valid(
    df = dfDomain,
    mapping = list('strIDCol'=strIDCol),
    spec=list(
      vUniqueCols = "strIDCol",
      vRequired = "strIDCol"
    ),
    bQuiet=bQuiet
  )

  is_subjects_valid <- gsm::is_mapping_valid(
    df = dfSubjects,
    mapping = list('strIDCol'=strIDCol),
    spec=list(
      vUniqueCols = "strIDCol",
      vRequired = "strIDCol"
    ),
    bQuiet=bQuiet
  )

  stopifnot(
    "Errors found in dfDomain" = is_domain_valid$status,
    "Errors found in dfSubjects" = is_subjects_valid$status,
    "bQuiet must be TRUE or FALSE" = is.logical(bQuiet)
  )

  if(!is.null(vFillZero)){
    stopifnot(
      "Columns specified in vFillZero not found in dfDomain" = all(vFillZero %in% names(dfDomain)),
      is.character(vFillZero)
    )
  }

  # Throw a warning if there are ID values in dfDomain that are not found in dfSubject
  subject_ids <- dfSubjects[[strIDCol]]
  domain_ids <- dfDomain[[strIDCol]]
  domain_only_ids <- domain_ids[!domain_ids %in% subject_ids]
  if(length(domain_only_ids > 0)){
    cli::cli_alert_warning(
      paste0(
        cli::col_br_red(
          length(domain_only_ids),
          cli::col_br_red(" ID(s) in domain data not found in subject data.\nAssociated rows will not be included in merged data.")
        )
      )
    )
  }

  # Print a message if rows in dfSubject are not found in dfDomain
  subject_only_ids <-  subject_ids[!subject_ids %in% domain_ids]
  if(length(subject_only_ids > 0)){
    if(!bQuiet){
      cli::cli_alert_warning(
        paste0(
          cli::col_br_red(
            length(subject_only_ids),
            " ID(s) in subject data not found in domain data."),
          ifelse(is.null(vFillZero),
                 cli::col_br_red("These participants will have NA values imputed for all domain data columns:"),
                 paste0(
                   cli::col_br_red("\nThese participants will have 0s imputed for the following domain data columns: "),
                   paste(vFillZero, sep=", "),
                   ". ",
                   cli::col_br_red("\nNA's will be imputed for all other columns.")
                 )
          )
        )
      )
    }
  }

  if (class(dfDomain[[strIDCol]]) != "character") {
    dfDomain[[strIDCol]] <- as.character(dfDomain[[strIDCol]])
  }

  if (class(dfSubjects[[strIDCol]]) != "character") {
    dfSubjects[[strIDCol]] <- as.character(dfSubjects[[strIDCol]])
  }

  dfOut <- left_join(dfSubjects, dfDomain, by=strIDCol)
  for(col in vFillZero){
    dfOut[[col]]<- tidyr::replace_na(dfOut[[col]], 0)
  }

  return(dfOut)
}
