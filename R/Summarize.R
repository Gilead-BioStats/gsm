#' Make Summary Data Frame
#'
#' Create a concise summary of assessment results that is easy to aggregate across assessments
#'
#' @param dfFlagged data frame in format produced by \code{\link{Flag}}
#' @param strScoreCol column from analysis results to be copied to `dfSummary$Score`
#' @param cAssessment brief description of current assessment
#' @param cLabel brief description of line item in current assessment
#'
#' @return Simplified finding data frame with columns for "SiteID", "N", "PValue", "Flag".
#'
#' @examples
#' dfInput <- AE_Map_Adam( safetyData::adam_adsl, safetyData::adam_adae )
#' dfTransformed <- Transform_EventCount( dfInput, cCountCol = 'Count', cExposureCol = "Exposure" )
#' dfAnalyzed <- Analyze_Wilcoxon( dfTransformed)
#' dfFlagged <- Flag( dfAnalyzed ,  strColumn = 'PValue', strValueColumn = 'Rate')
#' dfSummary <- Summarize(dfFlagged, cAssessment="Safety", cLabel= "")
#'
#' @import dplyr
#'
#' @export

Summarize <- function( dfFlagged , strScoreCol="PValue", cAssessment="", cLabel=""){
    stopifnot(
        is.data.frame(dfFlagged),
        is.character(cAssessment),
        is.character(cLabel),
        all(c("SiteID", "N", "Flag",strScoreCol) %in% names(dfFlagged))
    )
    dfSummary <- dfFlagged %>%
        mutate(Assessment = cAssessment) %>%
        mutate(Label = cLabel) %>%
        rename(Score = strScoreCol)%>%
        select(.data$Assessment,.data$Label, .data$SiteID,.data$N, .data$Score, .data$Flag) %>%
        arrange(.data$Score)

    return(dfSummary)
}
