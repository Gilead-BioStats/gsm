#' Fisher's Exact Test Analysis
#'
#' Creates Analysis results data for count data using the Fisher's exact test
#'
#' @details
#'
#' Analyzes count data using the Fisher's exact test
#'
#' @section Statistical Methods:
#'
#' TODO Coming soon ...
#'
#' @section Data Specification:
#'
#' The input data (`dfTransformed`) for Analyze_Fisher is typically created using \code{\link{Transform_EventCount}} and should be one record per site with required columns for:
#' - `SiteID` - Site ID
#' - `N` - Total number of participants at site
#' - `TotalCount` - Total number of participants at site with event of interest
#'
#'
#' @param dfTransformed `data.frame` in format produced by \code{\link{Transform_EventCount}}
#' @param strOutcome `character` required, name of column in dfTransformed dataset to perform Fisher test on. Default is "TotalCount".
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one row per site with columns: SiteID, TotalCount, TotalCount_Other, N, N_Other, Prop, Prop_Other, Estimate, PValue.
#'
#' @examples
#' dfInput <- Disp_Map(dfDisp = safetyData::adam_adsl, strCol = "DCREASCD", strReason = "Adverse Event")
#' dfTransformed <- Transform_EventCount(dfInput, strCountCol = "Count", strKRILabel = "Discontinuations due to AE")
#' dfAnalyzed <- Analyze_Fisher(dfTransformed)
#'
#' @import dplyr
#' @importFrom broom glance
#' @importFrom purrr map
#' @importFrom stats fisher.test
#' @importFrom tidyr unnest
#'
#' @export

Analyze_Fisher <- function(
  dfTransformed,
  strOutcome = "TotalCount",
  bQuiet = TRUE
) {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "One or more of these columns: SiteID, N, or the value in strOutcome not found in dfTransformed" = all(c("SiteID", "N", strOutcome) %in% names(dfTransformed)),
    "NA value(s) found in SiteID" = all(!is.na(dfTransformed[["SiteID"]])),
    "strOutcome must be length 1" = length(strOutcome) == 1,
    "strOutcome is not character" = is.character(strOutcome)
  )

  fisher_model <- function(site) {
    SiteTable <- dfTransformed %>%
      group_by(.data$SiteID == site) %>%
      summarize(
        Participants = sum(.data$N),
        Flag = sum(.data$TotalCount),
        NoFlag = sum(.data$Participants - .data$Flag)
      ) %>%
      select(.data$NoFlag, .data$Flag)

    stats::fisher.test(SiteTable)
  }

  dfAnalyzed <- dfTransformed %>%
    mutate(model = map(.data$SiteID, fisher_model)) %>%
    mutate(summary = map(.data$model, broom::glance)) %>%
    tidyr::unnest(summary) %>%
    rename(
      Estimate = .data$estimate,
      PValue = .data[["p.value"]]
    ) %>%
    mutate(
      TotalCount_All = sum(.data$TotalCount),
      N_All = sum(.data$N),
      TotalCount_Other = .data$TotalCount_All - .data$TotalCount,
      N_Other = .data$N_All - .data$N,
      Prop = .data$TotalCount / .data$N,
      Prop_Other = .data$TotalCount_Other / .data$N_Other
    ) %>%
    arrange(.data$PValue) %>%
    select(.data$SiteID, .data$TotalCount, .data$TotalCount_Other, .data$N, .data$N_Other, .data$Prop, .data$Prop_Other, .data$Estimate, .data$PValue)

  return(dfAnalyzed)
}
