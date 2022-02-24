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
#' @importFrom stats wilcox.test as.formula
#' @importFrom purrr map map_df
#' @importFrom broom glance
#' @importFrom tidyr unnest
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

    wilcoxon_model <- function(site){
        form <- as.formula(paste0(strOutcome," ~ SiteID ==", site)) 
        wilcox.test(form, exact = FALSE, conf.int = TRUE, data=dfTransformed)
    }

    dfAnalyzed <- dfTransformed %>% 
        mutate(model = map(.data$SiteID, wilcoxon_model)) %>%
        mutate(summary = map(.data$model, broom::glance)) %>%
        unnest(summary) %>%
        rename(
            PValue = .data[['p.value']],
            Estimate = .data$estimate
        ) %>%
        arrange(.data$PValue) %>%
        select( .data$SiteID, .data$N, .data$TotalCount, .data$TotalExposure, .data$Rate, .data$Estimate, .data$PValue)

    return(dfAnalyzed)
}
