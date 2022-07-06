#' Chi-squared Test Analysis
#'
#' Creates Analysis results data for count data using the chi-squared test
#'
#' @details
#'
#' Analyzes count data using the chi-squared test
#'
#' @section Statistical Methods:
#'
#' TODO Coming soon ...
#'
#' @section Data Specification:
#'
#' The input data (`dfTransformed`) for Analyze_Chisq is typically created using \code{\link{Transform_EventCount}} and should be one record per site with required columns for:
#' - `SiteID` - Site ID
#' - `N` - Total number of participants at site
#' - `TotalCount` - Total number of participants at site with event of interest
#'
#'
#' @param dfTransformed `data.frame` in format produced by \code{\link{Transform_EventCount}}
#' @param strOutcome `character` required, name of column in dfTransformed dataset to perform the chi-squared test on. Default is "TotalCount".
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#'
#' @return `data.frame` with one row per site with columns: SiteID, TotalCount, TotalCount_Other, N, N_Other, Prop, Prop_Other, Statistic, PValue.
#'
#' @examples
#' dfInput <- Disp_Map_Raw()
#' dfTransformed <- Transform_EventCount(
#'                    dfInput,
#'                    strCountCol = "Count",
#'                    strKRILabel = "Discontinuations due to AE/Month"
#'                  )
#' dfAnalyzed <- Analyze_Chisq(dfTransformed)
#'
#' @import dplyr
#' @importFrom broom glance
#' @importFrom purrr map
#' @importFrom stats chisq.test
#' @importFrom tidyr unnest
#'
#' @export

Analyze_Chisq <- function(
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

  chisq_model <- function(site) {
    SiteTable <- dfTransformed %>%
      group_by(.data$SiteID == site) %>%
      summarize(
        Participants = sum(.data$N),
        Flag = sum(.data$TotalCount),
        NoFlag = sum(.data$Participants - .data$Flag)
      ) %>%
      select(.data$Flag, .data$NoFlag)

    stats::chisq.test(SiteTable)
  }

  dfAnalyzed <- dfTransformed %>%
    mutate(model = purrr::map(.data$SiteID, chisq_model)) %>%
    mutate(summary = purrr::map(.data$model, broom::glance)) %>%
    tidyr::unnest(summary) %>%
    rename(
      Statistic = .data$statistic,
      Score = .data[["p.value"]]
    ) %>%
    mutate(
      TotalCount_All = sum(.data$TotalCount),
      N_All = sum(.data$N),
      TotalCount_Other = .data$TotalCount_All - .data$TotalCount,
      N_Other = .data$N_All - .data$N,
      Prop = .data$TotalCount / .data$N,
      Prop_Other = .data$TotalCount_Other / .data$N_Other,
      ScoreLabel = "P value"
    ) %>%
    arrange(.data$Score) %>%
    select(
      .data$SiteID,
      .data$TotalCount,
      .data$TotalCount_Other,
      .data$N,
      .data$N_Other,
      .data$Prop,
      .data$Prop_Other,
      .data$KRI,
      .data$KRILabel,
      .data$Statistic,
      .data$Score,
      .data$ScoreLabel
    )

  return(dfAnalyzed)
}
