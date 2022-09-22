#' Fisher's Exact Test Analysis
#'
#' @details
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
#' The input data (`dfTransformed`) for Analyze_Fisher is typically created using \code{\link{Transform_Rate}} and should be one record per site with required columns for:
#' - `GroupID` - GroupID from `dfTransformed`
#' - `N` - Total number of participants at site
#' - `Numerator` - Total number of participants at site with event of interest
#'
#'
#' @param dfTransformed `data.frame` in format produced by \code{\link{Transform_Rate}}
#' @param strOutcome `character` required, name of column in dfTransformed dataset to perform Fisher test on. Default is "Numerator".
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one row per site with columns: GroupID, Numerator, Numerator_Other, N, N_Other, Prop, Prop_Other, Estimate, PValue.
#'
#' @examples
#' dfInput <- Disp_Map_Raw()
#' dfTransformed <- Transform_Rate(
#'   dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Total"
#' )
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
  strOutcome = "Numerator",
  bQuiet = TRUE
) {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "One or more of these columns: GroupID, or the value in strOutcome not found in dfTransformed" = all(c("GroupID", strOutcome) %in% names(dfTransformed)),
    "NA value(s) found in GroupID" = all(!is.na(dfTransformed[["GroupID"]])),
    "strOutcome must be length 1" = length(strOutcome) == 1,
    "strOutcome is not character" = is.character(strOutcome)
  )

  fisher_model <- function(site) {
    SiteTable <- dfTransformed %>%
      group_by(.data$GroupID == site) %>%
      summarize(
        Participants = sum(.data$Denominator),
        Flag = sum(.data$Numerator),
        NoFlag = sum(.data$Participants - .data$Flag)
      ) %>%
      select(.data$NoFlag, .data$Flag)

    stats::fisher.test(SiteTable)
  }

  dfAnalyzed <- dfTransformed %>%
    mutate(model = map(.data$GroupID, fisher_model)) %>%
    mutate(summary = map(.data$model, broom::glance)) %>%
    tidyr::unnest(summary) %>%
    rename(
      Estimate = .data$estimate,
      Score = .data[["p.value"]]
    ) %>%
    mutate(
      Numerator_All = sum(.data$Numerator),
      Denominator_All = sum(.data$Denominator),
      Numerator_Other = .data$Numerator_All - .data$Numerator,
      Denominator_Other = .data$Denominator_All - .data$Denominator,
      Prop = .data$Numerator / .data$Denominator,
      Prop_Other = .data$Numerator_Other / .data$Denominator_Other,
      ScoreLabel = "P value"
    ) %>%
    arrange(.data$Score) %>%
    select(
      .data$GroupID,
      .data$Numerator,
      .data$Numerator_Other,
      .data$Denominator,
      .data$Denominator_Other,
      .data$Prop,
      .data$Prop_Other,
      .data$Metric,
      .data$Estimate,
      .data$Score,
      .data$ScoreLabel
    )

  return(dfAnalyzed)
}
