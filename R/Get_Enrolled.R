function(dfSUBJ, dfConfig, lMapping, strUnit, strBy) {
  stopifnot(
    `studyid not found in dfConfig` = "studyid" %in%
      names(dfConfig), `dfSUBJ is not a data.frame` = is.data.frame(dfSUBJ),
    `dfConfig is not a data.frame` = is.data.frame(dfConfig),
    `strUnit is not \`participant\` or \`site\`` = strUnit %in%
      c("participant", "site"), `strBy is not \`study\` or \`site\`` = strBy %in%
      c("study", "site"), `lMapping does not contain strEnrollCol` = "strEnrollCol" %in%
      names(lMapping$dfSUBJ), `lMapping does not contain strEnrollVal` = "strEnrollVal" %in%
      names(lMapping$dfSUBJ)
  )
  studyid <- unique(dfConfig$studyid)
  dm <- dfSUBJ %>% filter(.data[[lMapping$dfSUBJ$strStudyCol]] ==
    studyid & .data[[lMapping$dfSUBJ$strEnrollCol]] == lMapping$dfSUBJ$strEnrollVal)
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
