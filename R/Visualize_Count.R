#' Site-level visualization of site-level Inclusion/Exclusion results
#'
#' @param dfAnalyzed Map results from IE or Consent assessments.
#' @param strTotalCol Column containing total of site-level participants. Default is "N" from \code{\link{Transform_EventCount}}.
#' @param strCountCol Column containing total number of site-level occurrences. Default is "TotalCount" from \code{\link{Transform_EventCount}}.
#' @param strTitle Title of plot. NULL by default.
#'
#' @return site-level plot object.
#'
#' @examples
#' IE_Input <- IE_Map_Raw()
#' IE_Assess <- IE_Assess(IE_Input)
#' Visualize_Count(IE_Assess$dfAnalyzed)
#'
#' Consent_Input <- Consent_Map_Raw()
#' Consent_Assess <- Consent_Assess(Consent_Input)
#' Visualize_Count(Consent_Assess$dfAnalyzed)
#'
#' @import ggplot2
#' @importFrom stats reorder
#'
#' @export

Visualize_Count <- function(dfAnalyzed, strTotalCol = "N", strCountCol = "TotalCount", strTitle = "") {
  stopifnot(
    "strTotalCol must be character" = is.character(strTotalCol),
    "strTotalCol not found in dfAnalyzed" = strTotalCol %in% names(dfAnalyzed),
    "strCountCol must be character" = is.character(strCountCol),
    "strCountCol not found in dfAnalyzed" = strCountCol %in% names(dfAnalyzed),
    "strTitle must be character" = is.character(strTitle)
  )

  p <- ggplot(
    data = dfAnalyzed,
    aes(x = reorder(.data$GroupID, -.data$N))
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
      axis.text.x = element_text(angle = 90, vjust = 0.5),
      legend.position = "none"
    )

  return(p)
}
