#' Create message describing study summary for Report
#' @param report `string` type of report being run
#' @param status_study `data.frame` the snapshot status study output created with `Make_Snapshot()$lSnapshot$status_study`
#' @param overview_raw_table `data.frame` non interactive output of `Overview_Table()` for the relevant report.
#' @param red_kris `string` a string or number containing the count of red flags in kri's

#' @export
#' @keywords internal
Report_OverviewText <- function(strType, dfSummary, dfStudy) {
    #TODO: Implement this function
    cat('Nice summary coming soon')
#   if (strType == "site") {
#     cat(glue::glue("<div>As of {status_study$gsm_analysis_date}, {status_study$studyid} has {round(sum(as.numeric(overview_raw_table$Subjects)))} participants enrolled across
# {nrow(overview_raw_table)} sites. {red_kris} Site-KRI combinations have been flagged as red across {overview_raw_table %>% filter(.data$`Red KRIs` != 0) %>% nrow()} sites as shown in the Study Overview Table above.</div>
#   - <div>{overview_raw_table %>% filter(.data$`Red KRIs` != 0) %>% nrow()} sites have at least one red KRI</div>
#   - <div>{overview_raw_table %>% filter(.data$`Red KRIs` != 0 | .data$`Amber KRIs` != 0) %>% nrow()} sites have at least one red or amber KRI</div>
#   - <div>{overview_raw_table %>% filter(.data$`Red KRIs` == 0 & .data$`Amber KRIs` == 0) %>% nrow()} sites have neither red nor amber KRIs and are not shown</div>"), sep = "\n")
#   } else if (report == "country") {
#     cat(glue::glue("<div>As of {status_study$gsm_analysis_date}, {status_study$studyid} has {round(sum(as.numeric(overview_raw_table$Subjects)))} participants enrolled across
# {nrow(overview_raw_table)} countries. {red_kris} Country-KRI combinations have been flagged as red across {overview_raw_table %>% filter(.data$`Red KRIs` != 0) %>% nrow()} countries as shown in the Study Overview Table above.</div>
#   - <div>{overview_raw_table %>% filter(.data$`Red KRIs` != 0) %>% nrow()} countries have at least one red KRI</div>
#   - <div>{overview_raw_table %>% filter(.data$`Red KRIs` != 0 | .data$`Amber KRIs` != 0) %>% nrow()} countries have at least one red or amber KRI</div>
#   - <div>{overview_raw_table %>% filter(.data$`Red KRIs` == 0 & .data$`Amber KRIs` == 0) %>% nrow()} countries have neither red nor amber KRIs</div>"), sep = "\n")
#   }
}