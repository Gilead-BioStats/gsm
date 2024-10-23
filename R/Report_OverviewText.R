#' Create message describing study summary for Report
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' @inheritParams shared-params
#' @param lSetup `list` that is produced by `Report_StudyInfo()`.
#' @param lStudy `list` contains study-level metadata.
#' @export
#' @keywords internal
Report_OverviewText <- function(lSetup, dfResults, lStudy) {
  red_KRI_groups <- dfResults %>%
    filter(Flag %in% c(-2, 2)) %>%
    select("GroupID") %>%
    .$GroupID
  amber_or_red_KRI_groups <- dfResults %>%
    filter(Flag %in% c(-2, 2, -1, 1)) %>%
    select("GroupID") %>%
    .$GroupID
  no_alert_groups <- setdiff(dfResults$GroupID, amber_or_red_KRI_groups)

  if (lSetup$GroupLevel == "Site") {
    group_type <- "sites"
    group_count <- lStudy$SiteCount
  } else if (lSetup$GroupLevel == "Country") {
    group_type <- "countries"
    group_count <- lStudy$CountryCount
  }

  glue("
        <div style = 'margin-top: 1em;'>As of {lSetup$SnapshotDate}, {lSetup$StudyID} has {as.numeric(lStudy$ParticipantCount)} participants enrolled across {group_count} {group_type}. {length(amber_or_red_KRI_groups)} {lSetup$GroupLevel}-KRI combinations have been flagged across {length(unique(amber_or_red_KRI_groups))} {group_type} as shown in the Study Overview Table above.</div>
       - <div>{length(unique(red_KRI_groups))} {group_type} have at least one red KRI</div>
       - <div>{length(unique(amber_or_red_KRI_groups))} {group_type} have at least one red or amber KRI</div>
       - <div>{length(unique(no_alert_groups))} {group_type} have neither red nor amber KRIS and are not shown</div>") %>% cat()
}
