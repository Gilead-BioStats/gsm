#' Get_Enrolled Calculated enrolled participants or sites.
#'
#' @description
#' Derive number of enrolled participants or sites by a given denominator (study or site).
#'
#' @param dfSUBJ `data.frame` Typically a DM dataset.
#' @param dfConfig `data.frame` Dataset containing configuration parameters: `studyid`, `workflowid`, `gsm_version`, `param`, `index`, and `value`.
#' @param lMapping `list` Mappings for the assessment(s) being run
#' @param strUnit `character` Type of enrollment; one of `participant` or `site`.
#' @param strBy `character` Domain of enrollment; one of `study` or `site`.
#'
#' @return `character` string or `data.frame`, depending on input parameters.
#'
#'
#' @examples
#' enrolled <- Get_Enrolled(
#'   dfSUBJ = clindata::rawplus_dm,
#'   dfConfig = clindata::config_param,
#'   lMapping = yaml::read_yaml(
#'     system.file("mappings",
#'       "mapping_rawplus.yaml",
#'       package = "gsm"
#'     )
#'   ),
#'   strUnit = "participant",
#'   strBy = "site"
#' )
#'
#' @export
Get_Enrolled <- function(dfSUBJ, dfConfig, lMapping, strUnit, strBy) {
  studyid <- unique(dfConfig$studyid)

  dm <- dfSUBJ %>%
    filter(.data[[lMapping$dfSUBJ$strStudyCol]] == studyid)

  if (strUnit == "participant" & strBy == "study") {
    enrolled <- dm %>%
      group_by(.data[[lMapping$dfSUBJ$strStudyCol]]) %>%
      summarize(n_enrolled = n()) %>%
      pull(.data$n_enrolled)
  } else if (strUnit == "site" & strBy == "study") {
    enrolled <- dm %>%
      summarize(n_enrolled_sites = n_distinct(.data[[lMapping$dfSUBJ$strSiteCol]])) %>%
      pull(.data$n_enrolled_sites)
  } else if (strUnit == "participant" & strBy == "site") {
    enrolled <- dm %>%
      group_by(SiteID = .data[[lMapping$dfSUBJ$strSiteCol]]) %>%
      summarize(enrolled_participants = n()) %>%
      ungroup()
  }

  return(enrolled)
}
