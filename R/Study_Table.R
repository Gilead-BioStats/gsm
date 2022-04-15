#' Make Assessment overview table
#'
#' Make overview table with one row per assessment and one column per site showing flagged assessments.
#'
#' @param dfFindings dataframe containing one or more stacked findings. Findings are one record per assessment per site and have the following columns: Assessment, Label, SiteID, N, PValue, Flag. PValue is ignored in the summary table.
#' @param bFormat Use html-friendly icons in table cells. -1 is converted to a down arrow. 1 is converted to an up arrow. 0 is not shown. Other values are left as is.
#' @param showSiteScore Show a "Score" row with total number of flagged assessments for each site. TODO:  add method for custom scoring in future release)
#' @param siteScoreThreshold Hide sites with a site score less than this value (1 by default).
#' @param showCounts Show site counts? Uses first value of N for each site given in dfFindings.
#' @param colCollapse Combine the Assessment and Label columns into a single "Title Column"
#'
#' @import tidyr
#' @import dplyr
#' @importFrom fontawesome fa
#' @importFrom stringr str_pad
#'
#' @export
#'
#' @return returns a dataframe giving assessment status (rows) by Site (column)

Study_Table <- function(dfFindings, bFormat=TRUE, showCounts=TRUE, showSiteScore=TRUE, siteScoreThreshold=1, colCollapse = TRUE){
    stopifnot(
        is.data.frame(dfFindings),
        is.logical(bFormat)
    )

    # TODO: Add check for unique Site + Label + SiteID
    # Get site counts
    df_counts <- dfFindings %>%
    group_by(.data$SiteID) %>%
    summarize(
        Flag = first(.data$N)
    )%>%
    mutate(
        Assessment="Number of Subjects" ,
        Label="Number of Subjects"
    )%>%
    select(.data$Assessment, .data$Label, .data$SiteID, .data$Flag)

    # create site score for a site across all assessments
    df_score <- dfFindings %>%
        group_by(.data$SiteID) %>%
        summarize(Flag=sum(abs(.data$Flag))) %>%
        mutate(Assessment="Score") %>%
        mutate(Label="Score")

    # create subheaders for each assessment
    df_assessment <- dfFindings %>%
        group_by(.data$Assessment, .data$SiteID) %>%
        summarize(Flag=ifelse(any(.data$Flag!=0),"*","")) %>%
        mutate(Label="Subtotal")

    # create rows for each KRI
    df_tests <- dfFindings %>%
    select(.data$Assessment, .data$Label, .data$SiteID, .data$Flag) %>%
    mutate(Flag = case_when(
        Flag =="-1" ~ "-",
        Flag =="1" ~ "+",
        Flag =="0" ~ " ")
    )

    # combine score, subheaders, tests and counts
    df_combined <- rbind(df_tests, df_assessment, df_score)
    if(showCounts) df_combined <- rbind(df_combined, df_counts)

    # reformat standard flags to html icons if bFormat = TRUE
    if(bFormat){
        df_combined<- df_combined %>%
        mutate(Flag = case_when(
            Flag =="-" ~ as.character(fa("arrow-down", fill="red")),
            Flag =="+" ~ as.character(fa("arrow-up", fill="blue")),
            Flag =="*" ~ as.character(fa("asterisk")),
            is.na(Flag) ~ " ",
            TRUE ~ as.character(Flag)
        ))
    }

    # Create table view with one column per site
    df_summary<-df_combined %>%
        select(.data$Assessment, .data$Label, .data$SiteID, .data$Flag) %>%
        spread(.data$SiteID, .data$Flag, fill="")

    # Sort the table - maintain order of assessments/labels from dfFindings
    assessment_order <- unique(dfFindings$Assessment)
    label_order <- unique(paste0(dfFindings$Assessment,dfFindings$Label))
    nPad <- nchar(nrow(dfFindings))+1
    df_summary <- df_summary %>%
        mutate(assessment_index = str_pad(
            match(.data$Assessment,assessment_order),
            nPad,
            pad="0"
        )) %>%
        mutate(label_index = str_pad(
            match(paste0(.data$Assessment,.data$Label), label_order),
            nPad,
            pad="0"
        )) %>%
        mutate(index = case_when(
            Assessment == "Score" ~ '0.1',
            Assessment == "Number of Subjects" ~ '0.0',
            Label == "Subtotal" ~ assessment_index,
            TRUE ~ paste0(assessment_index,".",label_index)
        ))%>%
        arrange(.data$index) %>%
        select(-.data$index, -.data$assessment_index, -.data$label_index)

    # Basic logic to collapse Assessment and Label if requested
    if(colCollapse){
        df_summary<- df_summary %>%
        mutate(Title = ifelse(
            .data$Label=="Subtotal",
            .data$Assessment,
            ifelse(
                .data$Label %in% c("Number of Subjects","Score"),
                .data$Label,
                paste0("--",.data$Label)
            )
        ))%>%
        relocate(.data$Title) %>%
        select(-.data$Assessment, -.data$Label)
    }

    # Hide sites below siteScoreThreshold & sort sites by score and then N
    if(showSiteScore > 0 ){
        noOutlierSites <- df_score %>% filter(Flag < siteScoreThreshold) %>% pull(.data$SiteID)
        if(length(noOutlierSites)>0){
            footnote <- paste0("Note: Data not shown for ", length(noOutlierSites), " site(s) with site score less than ",siteScoreThreshold)
        }
    }

    siteCols <- df_score %>%
        rename(score = Flag) %>%
        filter(.data$score >= siteScoreThreshold) %>%
        select(.data$SiteID, .data$score) %>%
        left_join(df_counts) %>%
        rename(count = Flag) %>%
        arrange(-as.numeric(.data$score), -as.numeric(.data$count)) %>%
        pull(.data$SiteID)

    if(colCollapse){
        allCols <-  c("Title", siteCols)
    } else {
        allCols <- c('Assessment', "Label", siteCols)
    }

    df_summary <- df_summary %>% select(allCols)

    return(df_summary)
}
