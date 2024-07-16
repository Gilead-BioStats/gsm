#' Generate a summary table for a report
#'
#' This function generates a summary table for a report by joining the provided
#' results data frame with the site-level metadata from dfGroups. It then filters and arranges the
#' data based on certain conditions and displays the result in a datatable.
#'
#' @param dfResults The summary data frame
#' @param dfGroups The site data frame
#' @param strSnapshotDate user specified snapshot date as string
#' @param strGroupLevel  group level for the table
#' @param strGroupDetailParams one or more parameters from dfGroups to be added as columns in the table
#'
#' @return A datatable containing the summary table
#'
#' @export

Report_MetricTable <- function(
    dfResults,
    dfGroups,
    strSnapshotDate = NULL,
    strGroupLevel = "Site",
    strGroupDetailsParams = NULL
) {

    # Check for multiple snapshots --------------------------------------------
    # use most recent snapshot date if strSnapshotDate is missing
    if(is.null(strSnapshotDate)){
        if ("SnapshotDate" %in% colnames(dfResults) & nrow(dfResults) > 0) {
            strSnapshotDate <- max(dfResults$SnapshotDate)
        } else if (!"SnapshotDate" %in% colnames(dfResults) & nrow(dfResults) > 0){
            strSnapshotDate <- as.Date(Sys.Date())
            dfResults$SnapshotDate <- strSnapshotDate
        }
    } else {
        strSnapshotDate <- as.Date(strSnapshotDate)
    }

    if(nrow(dfResults) > 0){
        dfResults <- dfResults %>% filter(.data$SnapshotDate == strSnapshotDate)
    }

    # Add Group Metadata ------------------------------------------------------------
    if(is.null(strGroupDetailsParams)){
        if(strGroupLevel == "Site"){
            strGroupDetailsParams <- c("Country", "Status", "InvestigatorLastName", "ParticipantCount")
        } else if(strGroupLevel == "Country"){
            strGroupDetailsParams <- c("SiteCount","ParticipantCount")
        }
    }

    dfGroups_wide <- dfGroups %>%
        filter(.data$GroupLevel == strGroupLevel) %>%
        filter(.data$Param %in% strGroupDetailsParams) %>%
        pivot_wider(names_from="Param", values_from="Value") %>%
        select(-GroupLevel)

    if(nrow(dfResults) > 0 & nrow(dfGroups_wide) > 0){
        dfResults <- dfResults %>% left_join(dfGroups_wide, by = c("GroupID" = "GroupID"))
    }

    # Select Flagged metrics and format table -----------------------------------
    if (nrow(dfResults) > 0 & any(c(-2, -1, 1, 2) %in% unique(dfResults$Flag))) {
        SummaryTable <- dfResults %>%
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
                    "Country",
                    "Status",
                    "PI" = "InvestigatorLastName",
                    "Subjects" = "ParticipantCount"
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
