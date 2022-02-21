#' AE Wilcoxon Assessment - Analysis
#'
#' Creates Analysis results data for Adverse Event assessment using the Wilcoxon sign-ranked test
#'
#'  @details
#'
#' Fits a Wilcox Model to site-level data.
#'
#' @section Statistical Methods:
#'
#' TODO Coming soon ...
#'
#' @section Data Specification:
#'
#' The input data (` dfTransformed`) for the Analyze_Wilcoxon is typically created using \code{\link{Transform_EventCount}}  and should be one record per Site with columns for:
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `Count` - Number of Adverse Events
#' - `Exposure` - Number of days of exposure
#'
#'
#' @param  dfTransformed  data.frame in format produced by \code{\link{Transform_EventCount}}
#' @param  strOutcome required, name of column in dfTransformed dataset to perform Wilcoxon test on
#'
#' @importFrom stats wilcox.test
#' @importFrom purrr map map_df
#' @importFrom broom glance
#'
#' @return data.frame with one row per site, columns:   SiteID, N , ..., Estimate, PValue
#'
#' @examples
#' dfInput <- AE_Map_Adam( safetyData::adam_adsl, safetyData::adam_adae )
#' dfTransformed <- Transform_EventCount( dfInput, cCountCol = 'Count', cExposureCol = "Exposure" )
#' dfAnalyzed <- Analyze_Wilcoxon( dfTransformed , strOutcome ="Rate")
#'
#' @export

Analyze_Wilcoxon <- function(dfTransformed , strOutcome = "") {

    stopifnot(
        is.data.frame(dfTransformed),
        all(c("SiteID", "N", strOutcome) %in% names(dfTransformed))
    )


    colStrOutcome <- dfTransformed[[strOutcome]]


    dfAnalyzed <- dfTransformed %>%
        pull(.data$SiteID) %>%
        map_df(function(SiteName){
            model <- wilcox.test(
                colStrOutcome ~ SiteID == SiteName,
                exact = FALSE,
                conf.int = TRUE,
                data=dfTransformed
            ) %>%
                broom::glance() %>%
                mutate(SiteID = SiteName) %>%
                mutate(estimate = estimate*-1)

            return(model)
        })%>%
        rename(
            PValue = .data[['p.value']],
            Estimate = .data$estimate
        ) %>%
        select(.data$SiteID, .data$PValue, .data$Estimate) %>%
        left_join(dfTransformed, by="SiteID")%>%
        arrange(.data$PValue) %>%
        select( .data$SiteID, .data$N, .data$TotalCount, .data$TotalExposure, .data$Rate, .data$Estimate, .data$PValue)

    return(dfAnalyzed)
}
