#' Generate a summary table for a report
#'
#' This function generates a summary table for a report by joining the provided
#' summary data frame with the site data frame. It then filters and arranges the
#' data based on certain conditions and displays the result in a datatable.
#'
#' @param dfSummary The summary data frame
#' @param dfSite The site data frame
#' @param strSnapshotDate user specified snapshot date as string
#'
#' @return A datatable containing the summary table
#'
#' @export

Report_MetricTable <- function(dfSummary, dfSite, strSnapshotDate = NULL) {
    rlang::check_installed("DT", reason = "to run `Study_Report()`")
    rlang::check_installed("kableExtra", reason = "to run `Study_Report()`")

    # Check for multiple snapshots --------------------------------------------
    # use most recent snapshot date if strSnapshotDate is missing
    if(is.null(strSnapshotDate)){
        if ("snapshot_date" %in% colnames(dfSummary) & nrow(dfSummary) > 0) {
            strSnapshotDate <- max(dfSummary$snapshot_date)
        } else if (!"snapshot_date" %in% colnames(dfSummary) & nrow(dfSummary) > 0){
            strSnapshotDate <- as.Date(Sys.Date())
            dfSummary$snapshot_date <- strSnapshotDate
        }
    } else {
        strSnapshotDate <- as.Date(strSnapshotDate)
    }

    if(nrow(dfSummary) > 0){
        dfSummary <- dfSummary %>% filter(.data$snapshot_date == strSnapshotDate)
    }
    # Add Site Metadata ------------------------------------------------------------
    if(nrow(dfSummary) > 0 & nrow(dfSite) > 0){
        dfSummary <- dfSummary %>%
            left_join(
                dfSite %>% select("SiteID", "pi_last_name","country", "site_status"),
                c("GroupID" = "SiteID")
            )
    }

    # Select Flagged metrics and format table -----------------------------------
    if (nrow(dfSummary) > 0 & any(c(-2, -1, 1, 2) %in% unique(dfSummary$Flag))) {
        SummaryTable <- dfSummary %>%
            filter(.data$Flag != 0) %>%
            arrange(desc(abs(.data$Score))) %>%
            mutate(
                'Flag' = map(.data$Flag, Report_FormatFlag),
                across(
                    where(is.numeric),
                    ~ round(.x, 3)
                )
            ) %>%
            select(
                any_of(c(
                    "Site" = "GroupID",
                    "Country" = "country",
                    "Status" = "site_status",
                    "PI" = "pi_last_name",
                    "Subjects" = "enrolled_participants"
                )),
                everything()
            ) %>%
            select(-'MetricID') %>%
            kableExtra::kbl(format="html", escape=FALSE) %>%
            kableExtra::kable_styling("striped", full_width = FALSE)

    } else {
        SummaryTable<- "Nothing flagged for this KRI."
    }

    return(SummaryTable)
}
