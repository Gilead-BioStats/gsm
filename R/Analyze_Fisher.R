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
#' @param  ... additional arguments to pass to \code{\link{fisher.test}}
#'
#' @importFrom stats fisher.test as.formula
#' @importFrom purrr map 
#' @importFrom broom glance
#' @importFrom tidyr unnest
#'
#' @return data.frame with one row per site, columns:   SiteID, N , ..., SiteProp, OtherProp, Estimate, PValue
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
    
    fisher_model<- function(site){
        SiteTable <- dfTransformed %>%
            group_by(.data$SiteID == site) %>%
            summarize(
                N = sum(.data$N),
                TotalCount = sum(.data$TotalCount)
            ) 
        fisher.test(SiteTable)
    }

    dfAnalyzed <- dfTransformed %>%
        mutate(model = map(.data$SiteID, fisher_model)) %>%
        mutate(summary = map(.data$model, broom::glance)) %>%
        unnest(summary) %>%
        rename(
            PValue = .data[['p.value']],
            TotalCount_Site = .data$TotalCount,
            N_Site = .data$N
        ) %>%
        mutate(
            TotalCount_All = sum(.data$TotalCount_Site),
            N_All = sum(.data$N_Site),
            TotalCount_Other = .data$TotalCount_All - .data$TotalCount_Site,
            N_Other = .data$N_All - .data$N_Site,
            Prop_Site = .data$TotalCount_Site/.data$N_Site,
            Prop_Other = .data$TotalCount_Other/.data$N_Other
        )%>%
        arrange(.data$PValue) %>%
        select( .data$SiteID, .data$TotalCount_Site, .data$TotalCount_Other, .data$N_Site, .data$N_Other, .data$Prop_Site, .data$Prop_Other, .data$PValue)

    return(dfAnalyzed)
}
