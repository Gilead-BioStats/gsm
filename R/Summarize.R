#' Make Summary Data Frame
#'
#' Create a concise summary of assessment results that is easy to aggregate across assessments
#'
#' @details
#'
#' \code{Summarize} supports the input data (`dfFlagged`) from the \code{Flag} function.
#'
#' @section Data Specification:
#'
#' (`dfFlagged`) has the following required columns:
#' - `SiteID` - Site ID
#' - `N` - Total number of participants at site
#' - `Flag` - Flagging value of -1, 0, or 1
#' - `strScoreCol` - Column from analysis results. Default is "PValue".
#'
#' @param dfFlagged data frame in format produced by \code{\link{Flag}}
#' @param strScoreCol column from analysis results to be copied to `dfSummary$Score`
#' @param lTags List of tags containing metadata to add to the data frame.
#'
#' @return Simplified finding data frame with columns for SiteID, N, Pvalue, Flag and any metadata specified in lTags.
#'
#' @examples
#' dfInput <- AE_Map_Adam()
#' dfTransformed <- Transform_EventCount( dfInput, strCountCol = 'Count', strExposureCol = "Exposure" )
#' dfAnalyzed <- Analyze_Wilcoxon( dfTransformed)
#' dfFlagged <- Flag( dfAnalyzed ,  strColumn = 'PValue', strValueColumn = 'Rate')
#' dfSummary <- Summarize(dfFlagged)
#'
#' @import dplyr
#'
#' @export

Summarize <- function( dfFlagged , strScoreCol="PValue", lTags=NULL){

    stopifnot(
        "dfFlagged is not a data frame" = is.data.frame(dfFlagged),
        "One or more of these columns: SiteID, N, Flag , strScoreCol, not found in dfFlagged" = all(c("SiteID", "N", "Flag",strScoreCol) %in% names(dfFlagged))
    )

    if(!is.null(lTags)){
        stopifnot(
            "lTags is not named"=(!is.null(names(lTags))),
            "lTags has unnamed elements"=all(names(lTags)!="")
        )
    }

    dfSummary <- dfFlagged %>%
        rename(Score = strScoreCol)%>%
        select(.data$SiteID,.data$N, .data$Score, .data$Flag) %>%
        arrange(desc(abs(.data$Score)))  %>%
        arrange(match(.data$Flag, c(1, -1, 0))) %>%
        bind_cols(lTags)

    return(dfSummary)
}
