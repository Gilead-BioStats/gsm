#' Fisher's Exact Test Analysis
#'
#' @details
#' Creates analysis results data for count data using the Fisher's exact test.
#'
#' @details
#'
#' Analyzes count data using the Fisher's exact test.
#'
#' @section Statistical Methods:
#'
#' TODO Coming soon ...
#'
#' @section Data Specification:
#'
#' The input data (`dfTransformed`) for Analyze_Fisher is typically created using \code{\link{Transform_Rate}} and should be one record per site with required columns for:
#' - `GroupID` - Site ID
#' - `Numerator` - Total number of participants at site with event of interest
#' - `Denominator` - TBD
#' - `Metric` - TBD
#'
#' @param dfTransformed `data.frame` in format produced by \code{\link{Transform_Rate}}
#' @param strOutcome `character` required, name of column in dfTransformed dataset to perform Fisher's exact test on. Default is "Numerator".
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one row per site with columns: GroupID, Numerator, Numerator_Other, Denominator, Denominator_Other, Prop, Prop_Other, Metric, Estimate, Score.
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
    "GroupID or the value in strOutcome not found in dfTransformed" = all(c("GroupID", strOutcome) %in% names(dfTransformed)),
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
      select("NoFlag", "Flag")

    stats::fisher.test(SiteTable)
  }

  dfAnalyzed <- dfTransformed %>%
    mutate(model = map(.data$GroupID, fisher_model)) %>%
    mutate(summary = map(.data$model, broom::glance)) %>%
    tidyr::unnest(summary) %>%
    rename(
      Estimate = all_of("estimate"),
      Score = all_of("p.value")
    ) %>%
    mutate(
      Numerator_All = sum(.data$Numerator),
      Denominator_All = sum(.data$Denominator),
      Numerator_Other = .data$Numerator_All - .data$Numerator,
      Denominator_Other = .data$Denominator_All - .data$Denominator,
      Prop = .data$Numerator / .data$Denominator,
      Prop_Other = .data$Numerator_Other / .data$Denominator_Other
    ) %>%
    arrange(.data$Score) %>%
    select(
      "GroupID",
      "Numerator",
      "Numerator_Other",
      "Denominator",
      "Denominator_Other",
      "Prop",
      "Prop_Other",
      "Metric",
      "Estimate",
      "Score"
    )

  return(dfAnalyzed)
}
