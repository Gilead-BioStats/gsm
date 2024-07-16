`%|0|%` <- function(x, y) {
  if (length(x)) {
    return(x)
  } else {
    return(y)
  }
}


filter_by_latest_SnapshotDate <- function(dfResults, strSnapshotDate = NULL) {
  if (!nrow(dfResults)) {
    return(dfResults)
  }
  # use most recent snapshot date if strSnapshotDate is missing
  dfResults$SnapshotDate <- as.Date(dfResults$SnapshotDate) %|0|% Sys.Date()
  strSnapshotDate <- as.Date(strSnapshotDate) %|0|% max(dfResults$SnapshotDate)
  return(dplyr::filter(dfResults, .data$SnapshotDate == strSnapshotDate))
}

add_Groups_metadata <- function(dfResults,
                                dfGroups,
                                strGroupLevel = c("Site", "Study", "Country"),
                                strGroupDetailsParams) {
  if (nrow(dfResults)) {
    strGroupLevel <- rlang::arg_match(strGroupLevel)
    dfGroups_wide <- widen_dfGroups(dfGroups, strGroupLevel, strGroupDetailsParams)
    if (nrow(dfGroups)) {
      dfResults <- dplyr::left_join(
        dfResults,
        dfGroups_wide,
        by = "GroupID"
      )
    }
  }
  return(dfResults)
}

widen_dfGroups <- function(dfGroups, strGroupLevel, strGroupDetailsParams) {
  dfGroups <- dplyr::filter(dfGroups, .data$GroupLevel == strGroupLevel)
  if (nrow(dfGroups)) {
    if (is.null(strGroupDetailsParams)) {
      if (strGroupLevel == "Site") {
        strGroupDetailsParams <- c(
          "Country", "Status", "InvestigatorLastName", "ParticipantCount"
        )
      } else if (strGroupLevel == "Country") {
        strGroupDetailsParams <- c("SiteCount","ParticipantCount")
      }
    }
    dfGroups <- dfGroups %>%
      dplyr::filter(.data$Param %in% strGroupDetailsParams) %>%
      tidyr::pivot_wider(names_from = "Param", values_from = "Value")
  }
  return(dplyr::select(dfGroups, -"GroupLevel"))
}
