#' Fisher's Exact Test Analysis
#'
#' Creates Analysis results data for count data using the Fisher's exact test
#'
#'  @details
#'
#' Analyzes count data using the Fisher's exact test
#'
#' @section Statistical Methods:
#'
#' TODO Coming soon ...
#'
#' @section Data Specification:
#'
#' The input data (` dfTransformed`) for the Analyze_Fisher is typically created using \code{\link{Transform_EventCount}}  and should be one record per Site with columns for:
#' - `SiteID` - Site ID
#' - `N` - Total number of participants at site
#' - `Count` - Total number of participants at site with event of interest
#'
#'
#' @param  dfTransformed  data.frame in format produced by \code{\link{Transform_EventCount}}
#' @param  strOutcome required, name of column in dfTransformed dataset to perform Fisher test on
#'
#' @importFrom stats fisher.test as.formula
#' @importFrom purrr map map_df
#' @importFrom broom glance
#'
#' @return data.frame with one row per site, columns:   SiteID, N , ..., Estimate, PValue
#'
#' @examples
#' dfInput <- Disp_Map(dfDisp = safetyData::adam_adsl, strCol = "DCREASCD",strReason = "Adverse Event")
#' dfTransformed <- Transform_EventCount( dfInput, cCountCol = 'Count' )
#' dfAnalyzed <- Analyze_Fisher( dfTransformed )
#'
#' @export

Analyze_Fisher <- function( dfTransformed , strOutcome = "TotalCount") {

    stopifnot(
        is.data.frame(dfTransformed),
        all(c("SiteID", "N", strOutcome) %in% names(dfTransformed))
    )

    dfAnalyzed <- dfTransformed %>%
        pull(.data$SiteID) %>%
        map_df(function(SiteName) {

            tablein <- dfTransformed %>%
                mutate(SiteIndicator = .data$SiteID == SiteName) %>%
                group_by(.data$SiteIndicator) %>%
                summarise(across(c(.data$N, .data$TotalCount), sum),
                          SiteID = min(.data$SiteID),
                          TotalCount = .data$TotalCount) %>%
                mutate(Prop = .data$TotalCount / .data$N )

            tablein %>%
                select(.data$N, .data$TotalCount) %>%
                fisher.test() %>%
                broom::glance() %>%
                mutate(SiteProp = tablein$Prop[tablein$SiteIndicator],
                       OtherProp = tablein$Prop[!tablein$SiteIndicator],
                       SiteID = SiteName) %>%
                left_join(tablein, by = "SiteID")

        }) %>% rename(PValue = .data[['p.value']],
                      Estimate = .data$estimate) %>%
        arrange(.data$PValue) %>%
        select(
            .data$SiteID,
            .data$N,
            .data$TotalCount,
            .data$SiteProp,
            .data$OtherProp,
            .data$Estimate,
            .data$PValue
        )

    return(dfAnalyzed)
}
