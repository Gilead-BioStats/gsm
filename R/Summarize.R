#' Make Summary Data Frame
#'
#' Create a concise summary of assessment results that is easy to aggregate across assessments
#'
#' @param dfFlagged data frame in format produced by \code{\link{Flag}}
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

Summarize <- function( dfFlagged , cAssessment="", cLabel=""){
    stopifnot(
        is.data.frame(dfFlagged),
        is.character(cAssessment),
        is.character(cLabel),
        all(c("SiteID", "N", "PValue", "Flag") %in% names(dfFlagged))
    )
    dfSummary <- dfFlagged %>%
        mutate(Assessment = cAssessment) %>%
        mutate(Label = cLabel) %>%
        select(.data$Assessment,.data$Label, .data$SiteID,.data$N, .data$PValue, .data$Flag) %>%
        arrange(.data$PValue)

    return(dfSummary)
}
