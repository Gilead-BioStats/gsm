#' Site-level visualization of site-level Inclusion/Exclusion results
#'
#' @param dfAnalyzed Map results from IE or Consent assessments.
#' @param strTotalCol Column containing total of site-level participants. Default is "N" from \code{\link{Transform_EventCount}}.
#' @param strCountCol Column containing total number of site-level occurances. Default is "TotalCount" from \code{\link{Transform_EventCount}}.
#' @param strTitle Title of plot. NULL by default.
#'
#' @return site level plot object
#'
#' @examples
#' ie_input <- IE_Map_Raw(
#'    clindata::raw_ie_all ,
#'    clindata::rawplus_rdsl,
#'    strCategoryCol = 'IECAT_STD',
#'    vCategoryValues= c("EXCL","INCL"),
#'    strResultCol = 'IEORRES',
#'    vExpectedResultValues=c(0,1)
#')
#'
#' ie_assess <- IE_Assess(ie_input, bDataList=TRUE)
#' Visualize_Count(ie_assess$dfAnalyzed)
#'
#' consent_input <- Consent_Map_Raw(
#'   dfConsent = clindata::raw_consent,
#'   dfRDSL = clindata::rawplus_rdsl,
#'   strConsentReason = NULL
#' )
#'
#' consent_assess <- Consent_Assess(consent_input, bDataList=TRUE)
#' Visualize_Count(consent_assess$dfAnalyzed)
#'
#' @import ggplot2
#' @importFrom stats reorder
#'
#' @export

Visualize_Count <- function(dfAnalyzed, strTotalCol="N", strCountCol="TotalCount", strTitle="") {
    stopifnot(
        "strTotalCol must be character" = is.character(strTotalCol),
        "strTotalCol not found in dfAnalyzed" = strTotalCol %in% names(dfAnalyzed),
        "strCountCol must be character" = is.character(strCountCol),
        "strCountCol not found in dfAnalyzed" = strCountCol %in% names(dfAnalyzed),
        "strTitle must be character" = is.character(strTitle)
    )

p <- ggplot(
        data = dfAnalyzed,
        aes(x = reorder(.data$SiteID, -.data$N))
    ) +
    geom_bar(aes(y = .data[[strTotalCol]]), stat = "identity", color = "black", fill = "white") +
    geom_bar(aes(y = .data[[strCountCol]]), stat = "identity", fill = "red") +
    ggtitle(strTitle) +
    labs(
        x = "Site ID",
        y = "Event Count"
    ) +
    theme(
        panel.grid.major.x = element_blank(),
        axis.text.x = element_text(angle=90, vjust = 0.5),
        legend.position="none"
    )

    return(p)
}
