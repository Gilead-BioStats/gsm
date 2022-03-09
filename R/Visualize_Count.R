#' Site-level visualization of site-level Inclusion/Exclusion results
#'
#' @param dfInput Map results from IE or Consent assessments.
#' @param strTitle Title of plot. NULL by default.
#'
#' @return site level plot object
#'
#' @examples
#' ie_input <- IE_Map_Raw(
#'    clindata::raw_ie_all , 
#'    clindata::rawplus_rdsl,
#'    strCategoryCol = 'IECAT_STD', 
#'    vCategoryResults=c("EXCL","INCL"),
#'    strResultCol = 'IEORRES'
#' )
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
#' consent_assess<-Consent_Assess(dfInput, bDataList=TRUE)
#' Visualize_Count(consent_assess$dfAnalyzed)
#'
#' @import ggplot2
#' @importFrom stats reorder
#'
#' @export

Visualize_Count <- function(dfAnalyzed, strTotalCol="N", strCountCol="TotalCount", strFlagCol="Flag", strTitle="") {

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
