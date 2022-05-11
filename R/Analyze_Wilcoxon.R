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
#' A Wilcoxon model is used to generate estimates and p-values for each site (as specified with the `strOutcome` parameter).
#'
#' @section Data Specification:
#'
#' The input data (dfTransformed) for Analyze_Wilcoxon is typically created using \code{\link{Transform_EventCount}} and should be one record per site with required columns for:
#' - `SiteID` - Site ID
#' - `N` - Number of participants
#' - `TotalCount` - Number of Adverse Events
#' - `TotalExposure` - Number of days of exposure
#' - `Rate` - Rate of exposure (TotalCount / TotalExposure)
#'
#'
#' @param  dfTransformed  data.frame in format produced by \code{\link{Transform_EventCount}}
#' @param  strOutcome required, name of column in dfTransformed dataset to perform Wilcoxon test on. Default="Rate"
#'
#' @import dplyr
#' @importFrom stats wilcox.test as.formula
#' @importFrom purrr map
#' @importFrom broom glance
#' @importFrom tidyr unnest
#'
#' @return data.frame with one row per site, columns: SiteID, N, TotalCount, TotalExposure, Rate, Estimate, PValue
#'
#' @examples
#' dfInput <- AE_Map_Raw()
#' dfTransformed <- Transform_EventCount(dfInput, strCountCol = "Count", strExposureCol = "Exposure")
#' dfAnalyzed <- Analyze_Wilcoxon(dfTransformed, strOutcome = "Rate")
#'
#' @export

Analyze_Wilcoxon <- function(dfTransformed, strOutcome = "Rate") {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "One or more of these columns: SiteID, N, or the value in strOutcome not found in dfTransformed" = all(c("SiteID", "N", strOutcome) %in% names(dfTransformed)),
    "NA value(s) found in SiteID" = all(!is.na(dfTransformed[["SiteID"]])),
    "strOutcome must be length 1" = length(strOutcome) == 1,
    "strOutcome is not character" = is.character(strOutcome)
  )

  wilcoxon_model <- function(site) {
    form <- as.formula(paste0(strOutcome, " ~ as.character(SiteID) =='", site, "'"))
    stats::wilcox.test(form, exact = FALSE, conf.int = TRUE, data = dfTransformed)
  }

  dfAnalyzed <- dfTransformed %>%
    mutate(model = map(.data$SiteID, wilcoxon_model)) %>%
    mutate(summary = map(.data$model, broom::glance)) %>%
    tidyr::unnest(summary) %>%
    mutate(Estimate = .data$estimate * -1) %>%
    rename(PValue = .data[["p.value"]]) %>%
    arrange(.data$PValue) %>%
    select(.data$SiteID, .data$N, .data$TotalCount, .data$TotalExposure, .data$Rate, .data$Estimate, .data$PValue)

  return(dfAnalyzed)
}
