#' Make Summary Data Frame
#'
#' Create a concise summary of assessment results that is easy to aggregate across assessments
#'
#' @details
#'
#' @section Data Specification:
#'
#' \code{Summarize} supports the input data (`dfFlagged`) from the \code{Flag} function.
#'
#' (`dfFlagged`) has the following required columns:
#' - `SiteID` - Site ID
#' - `N` - Total number of participants at site
#' - `Flag` - Flagging value of -1, 0, or 1
#' - `strScoreCol` - Column from analysis results. Default is "PValue".
#'
#' @param dfFlagged data frame in format produced by \code{\link{Flag}}
#' @param strScoreCol column from analysis results to be copied to `dfSummary$Score`
#' @param cAssessment brief description of current assessment
#' @param cLabel brief description of line item in current assessment
#'
#' @return Simplified finding data frame with columns: Assessment, Label, SiteID, N, Pvalue, Flag
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
        "dfFlagged is not a data frame" = is.data.frame(dfFlagged),
        "cAssessment is not character" = is.character(cAssessment),
        "cLabel is not character" = is.character(cLabel),
        "One or more of these columns: SiteID, N, Flag not found in dfFlagged" = all(c("SiteID", "N", "Flag",strScoreCol) %in% names(dfFlagged)),
        "cAssessment must be length of 1" = length(cAssessment) == 1,
        "cLabel must be length of 1" = length(cLabel) == 1
    )
    dfSummary <- dfFlagged %>%
        mutate(Assessment = cAssessment) %>%
        mutate(Label = cLabel) %>%
        rename(Score = strScoreCol)%>%
        select(.data$Assessment,.data$Label, .data$SiteID,.data$N, .data$Score, .data$Flag) %>%
        arrange(.data$Score)

    return(dfSummary)
}
