#' Make Summary Data Frame
#' 
#' Adds columns flagging sites that represent possible statistical outliers
#'
#' @param dfFlagged data frame in format produced by \code{\link{Flag}}
#' @param cAssessment brief description of current assessment
#' @param cLabel brief description of line item in current assessment

#' @return Simplified finding data frame with columns for "SiteID", "N", "PValue", "Flag". 
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
