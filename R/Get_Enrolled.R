#' Get_Enrolled
#'
#' @description
#' Derive number of enrolled participants or sites by a given denominator (study or site).
#'
#' @param dfSUBJ
#' @param dfConfig
#' @param lMapping
#' @param strUnit
#' @param strBy
#'
#' @return
#'
#' @export
#'
#' @examples
#'
#' Get_Enrolled(dfSUBJ = clindata::rawplus_dm,
#'              dfConfig = config_param,
#'              lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
#'              strUnit = "participant",
#'              strBy = "site")
#'
Get_Enrolled <- function(dfSUBJ, dfConfig, lMapping, strUnit, strBy) {

  studyid <- unique(dfConfig$studyid)

  dm <- dfSUBJ %>%
    filter(.data[[lMapping$dfSUBJ$strStudyCol]] == studyid)

  if (strUnit == "participant" & strBy == "study") {
    enrolled <- dm %>%
      group_by(.data[[lMapping$dfSUBJ$strStudyCol]]) %>%
      summarize(n_enrolled = n()) %>%
      pull(n_enrolled)
  } else if (strUnit == "site" & strBy == "study") {
    enrolled <- dm %>%
      summarize(n_enrolled_sites = n_distinct(.data[[lMapping$dfSUBJ$strSiteCol]])) %>%
      pull(n_enrolled_sites)
  } else if (strUnit == "participant" & strBy == "site") {
    enrolled <- dm %>%
      group_by(SiteID = .data[[lMapping$dfSUBJ$strSiteCol]]) %>%
      summarize(n_enrolled_participants = n()) %>%
      ungroup() %>%
      mutate(StudyID = studyid) %>%
      select(StudyID, everything())
  }

  return(enrolled)

}
