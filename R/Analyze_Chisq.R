#' Chi-squared Test Analysis
#'
#' Creates Analysis results data for count data using the chi-squared test
#'
#'  @details
#'
#' Analyzes count data using the chi-squared test
#'
#' @section Statistical Methods:
#'
#' TODO Coming soon ...
#'
#' @section Data Specification:
#'
#' The input data (` dfTransformed`) for the Analyze_Chisq is typically created using \code{\link{Transform_EventCount}}  and should be one record per Site with columns for:
#' - `SiteID` - Site ID
#' - `N` - Total number of participants at site
#' - `Count` - Total number of participants at site with event of interest
#'
#'
#' @param  dfTransformed  data.frame in format produced by \code{\link{Transform_EventCount}}
#' @param  strOutcome required, name of column in dfTransformed dataset to perform the chi-squared test on
#' @param  ... optional, additional arguments to be passed to \code{\link{chisq.test}}. Includes options for: x, y, correct, p, rescale.p, simulate.p.value, B
#'
#' @importFrom stats chisq.test as.formula
#' @importFrom purrr map map_df
#' @importFrom broom glance
#'
#' @return data.frame with one row per site, columns: SiteID, TotalCount, TotalCount_Other, N, N_Other, Prop, Prop_Other, Statistic, PValue
#'
#' @examples
#' dfInput <- Disp_Map(dfDisp = safetyData::adam_adsl, strCol = "DCREASCD",strReason = "Adverse Event")
#' dfTransformed <- Transform_EventCount( dfInput, cCountCol = 'Count' )
#' dfAnalyzed <- Analyze_Chisq( dfTransformed )
#'
#' @export

Analyze_Chisq <- function( dfTransformed , strOutcome = "TotalCount", ...) {

    stopifnot(
        is.data.frame(dfTransformed),
        all(c("SiteID", "N", strOutcome) %in% names(dfTransformed)),
        all(names(list(...)) %in% c("x", "y", "correct", "p", "rescale.p", "simulate.p.value", "B"))
    )

    chisq_model<- function(site){
        SiteTable <- dfTransformed %>%
            group_by(.data$SiteID == site) %>%
            summarize(
                Participants = sum(.data$N),
                Flag = sum(.data$TotalCount),
                NoFlag = sum(.data$Participants - .data$Flag)
            ) %>%
            select(.data$Flag, .data$NoFlag)

        stats::chisq.test(SiteTable, ...)
    }

    dfAnalyzed <- dfTransformed %>%
        mutate(model = map(.data$SiteID, chisq_model)) %>%
        mutate(summary = map(.data$model, broom::glance)) %>%
        unnest(summary) %>%
        rename(
            Statistic = .data$statistic,
            PValue = .data[['p.value']]
        ) %>%
        mutate(
            TotalCount_All = sum(.data$TotalCount),
            N_All = sum(.data$N),
            TotalCount_Other = .data$TotalCount_All - .data$TotalCount,
            N_Other = .data$N_All - .data$N,
            Prop = .data$TotalCount/.data$N,
            Prop_Other = .data$TotalCount_Other/.data$N_Other
        )%>%
        arrange(.data$PValue) %>%
        select( .data$SiteID, .data$TotalCount, .data$TotalCount_Other, .data$N, .data$N_Other, .data$Prop, .data$Prop_Other, .data$Statistic, .data$PValue)

    return(dfAnalyzed)
}
