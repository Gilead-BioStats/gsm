#' Fisher's Exact Test Analysis.
#'
#' `r lifecycle::badge("stable")`
#'
#' @details
#' Analyzes count data using the Fisher's exact test.
#'
#' More information can be found in [The Fisher's Exact Method Section](https://gilead-biostats.github.io/gsm/articles/KRI%20Method.html#the-fishers-exact-method)
#' of the KRI Method vignette.
#'
#' @section Statistical Methods:
#'
#' The function `Analyze_Fisher` utilizes `stats::fisher.test` to generate an
#' estimate of odds ratio as well as a p-value using the Fisher’s exact test with site-level count
#' data. For each site, the Fisher’s exact test is conducted by comparing the given site to all other sites combined
#' in a 2×2 contingency table. The p-values are then used as a scoring metric in `{gsm}` to flag
#' possible outliers. The default in `stats::fisher.test` uses a two-sided test (equivalent to testing
#' the null of OR = 1) and does not compute p-values by Monte Carlo simulation unless `simulate.p.value = TRUE`.
#' Sites with p-values less than 0.05 from the Fisher’s exact test analysis are flagged by default.
#' The significance level was set at a common choice.
#'
#' @section Data Specification:
#'
#' The input data (`dfTransformed`) for `Analyze_Fisher` is typically created using \code{\link{Transform_Rate}} and should be one record per site with required columns for:
#' - `GroupID` - Site ID
#' - `Numerator` - Total number of participants at site with event of interest.
#' - `Denominator` - Total number of participants at site/Total number of days of exposure at site.
#' - `Metric` - Proportion of participants at site with event of interest/Rate of events at site (Numerator / Denominator).
#'
#' @param dfTransformed `data.frame` in format produced by \code{\link{Transform_Rate}}.
#' @param strOutcome `character` required, name of column in `dfTransformed` dataset to perform Fisher's exact test on. Default is "Numerator".
#'
#' @return `data.frame` with one row per site with columns: GroupID, Numerator, Numerator_Other, Denominator, Denominator_Other, Prop, Prop_Other, Metric, Estimate, and Score.
#'
#' @examples
#' dfInput <- tibble::tribble(
#'   ~SubjectID, ~SiteID, ~StudyID, ~CountryID, ~CustomGroupID, ~Exposure, ~Count, ~Rate,
#'   "0496", "5", "AA-AA-000-0000", "US", "0X167", 730, 5, 5/720,
#'   "1350", "78", "AA-AA-000-0000", "US", "0X002", 50, 2, 2/50,
#'   "0539", "139", "AA-AA-000-0000", "US", "0X052", 901, 5, 5/901,
#'   "0329", "162", "AA-AA-000-0000", "US", "0X049", 370, 3, 3/370,
#'   "0429", "29", "AA-AA-000-0000", "Japan", "0X116", 450, 2, 2/450,
#'   "1218", "143", "AA-AA-000-0000", "US", "0X153", 170, 3, 3/170,
#'   "0808", "173", "AA-AA-000-0000", "US", "0X124", 680, 6, 6/680,
#'   "1314", "189", "AA-AA-000-0000", "US", "0X093", 815, 4, 4/815,
#'   "1236", "58", "AA-AA-000-0000", "China", "0X091", 225, 1, 1/225,
#'   "0163", "167", "AA-AA-000-0000", "US", "0X059", 360, 3, 3/360
#' )

#' dfTransformed <- Transform_Rate(
#'   dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
#' dfAnalyzed <- Analyze_Fisher(dfTransformed)
#'
#' @export

Analyze_Fisher <- function(
  dfTransformed,
  strOutcome = "Numerator"
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
    mutate(model = purrr::map(.data$GroupID, fisher_model)) %>%
    mutate(summary = purrr::map(.data$model, broom::glance)) %>%
    tidyr::unnest(summary) %>%
    mutate(
      Estimate = .data$estimate,
      Score = .data$p.value,
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
