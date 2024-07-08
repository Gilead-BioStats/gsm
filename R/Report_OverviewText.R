#' Create message describing study summary for Report
#' @param lSetup `list` that is produced by `Report_StudyInfo(dfStudy = params$dfStudy)`.
#' @param dfSummary `data.frame` containing summary information.
#' @param dfStudy `data.frame` contains site-level metadata.
#' @export
#' @keywords internal
Report_OverviewText <- function(lSetup, dfSummary, dfStudy) {

    red_KRI_groups <- dfSummary %>% filter(Flag %in% c(-2,2)) %>% select('GroupID') %>% .$GroupID
    amber_or_red_KRI_groups <- dfSummary %>% filter(Flag %in% c(-2,2,-1,1)) %>% select('GroupID') %>% .$GroupID
    no_alert_groups <- dfSummary %>% filter(Flag %in% !c(-2,2,1,-1)) %>% select('GroupID') %>% .$GroupID

    if (lSetup$Group == "Site") {
      group_type = "sites"
    } else if (lSetup$Group == "Country") {
      group_type = "countries"
    }

    cat(glue::glue("
        <div style = 'margin-top: 2em;'>As of {lSetup$SnapshotDate}, {lSetup$StudyID} has {as.numeric(dfStudy$num_enrolled_subj_m)} participants enrolled across {dfStudy$num_site_actl} {group_type}. {length(red_KRI_groups)} Site-KRI combinations have been flagged across {length(unique(red_KRI_groups))} {group_type} as shown in the Study Overview Table above.</div>
       - <div>{length(unique(red_KRI_groups))} {group_type} have at least one red KRI</div>
       - <div>{length(unique(amber_or_red_KRI_groups))} {group_type} have at least one red or amber KRI</div>
       - <div>{length(unique(no_alert_groups))} {group_type} have neither red nor amber KRIS and are not shown</div>"))

}
