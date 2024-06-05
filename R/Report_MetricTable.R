#' Generate a summary table for a report
#'
#' This function generates a summary table for a report by joining the provided
#' summary data frame with the site data frame. It then filters and arranges the
#' data based on certain conditions and displays the result in a datatable.
#'
#' @param dfSummary The summary data frame
#' @param dfSite The site data frame
#'
#' @return A datatable containing the summary table
#'
#' @export

Report_MetricTable <- function(dfSummary, dfSite, strSnapshotDate = NULL) { 
    rlang::check_installed("DT", reason = "to run `Study_Report()`")

    # Check for multiple snapshots --------------------------------------------
    # if snapshot_date is missing set it to today for all records
    if (!"snapshot_date" %in% colnames(dfSummary)) {
        dfSummary$snapshot_date <- as.Date(Sys.Date())
    }

    # use most recent snapshot date if strSnapshotDate is missing
    if(is.null(strSnapshotDate)){
        strSnapshotDate <- max(dfSummary$snapshot_date)
    }

    dfSummary <- dfSummary %>% filter(snapshot_date == strSnapshotDate)

    # Add Site Metadata ------------------------------------------------------------
    dfSummary <- dfSummary %>%
        left_join(
            dfSite %>% select("SiteID", "pi_last_name","country", "site_status"),
            c("GroupID" = "SiteID")
        )

    # Select Flagged metrics and format table -----------------------------------
    if (nrow(dfSummary) > 0 & any(c(-2, -1, 1, 2) %in% unique(dfSummary$Flag))) {
        SummaryTable <- dfSummary %>%
            filter(.data$Flag != 0) %>%
            arrange(desc(abs(.data$Score))) %>%
            mutate(
                Flag = map(.data$Flag, Report_FormatFlag),
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
            select(-MetricID) %>%
            kbl(format="html", escape=FALSE) %>%
            kable_styling("striped", full_width = FALSE)
            
    } else {
        SummaryTable<- "Nothing flagged for this KRI."
    }
    
    return(SummaryTable)
}
