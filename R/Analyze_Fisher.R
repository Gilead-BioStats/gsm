#' Fisher's Exact Test Analysis.
#'
#' @description `r lifecycle::badge("stable")`
#'
#'   Analyzes count data using the Fisher's exact test.
#'
#'   More information can be found in [The Fisher's Exact Method
#'   Section](https://gilead-biostats.github.io/gsm/articles/KRI%20Method.html#the-fishers-exact-method)
#'   of the KRI Method vignette.
#'
#' @section Statistical Methods:
#'
#'   The function `Analyze_Fisher` utilizes `stats::fisher.test` to generate an
#'   estimate of odds ratio as well as a p-value using the Fisher’s exact test
#'   with site-level count data. For each site, the Fisher’s exact test is
#'   conducted by comparing the given site to all other sites combined in a 2×2
#'   contingency table. The p-values are then used as a scoring metric in
#'   `{gsm}` to flag possible outliers. The default in `stats::fisher.test` uses
#'   a two-sided test (equivalent to testing the null of OR = 1) and does not
#'   compute p-values by Monte Carlo simulation unless `simulate.p.value =
#'   TRUE`. Sites with p-values less than 0.05 from the Fisher’s exact test
#'   analysis are flagged by default. The significance level was set at a common
#'   choice.
#'
#' @param dfTransformed `data.frame` Transformed data for analysis. Data should
#'   have one record per site with expected columns: `GroupID`, `GroupLevel`,
#'   `Numerator`, `Denominator`, and `Metric`. For more details see the Data
#'   Model vignette: `vignette("DataModel", package = "gsm")`. For this
#'   function, `dfTransformed` should typically be created using
#'   [Transform_Rate()].
#' @param strOutcome `character` required, name of column in `dfTransformed`
#'   dataset to perform Fisher's exact test on. Default is "Numerator".
#'
#' @return `data.frame` with one row per site with columns: GroupID, Numerator,
#'   Numerator_Other, Denominator, Denominator_Other, Prop, Prop_Other, Metric,
#'   Estimate, and Score.
#'
#' @examples
#' dfTransformed <- Transform_Rate(
#'   analyticsInput
#' )
#' dfAnalyzed <- Analyze_Fisher(dfTransformed)
#'
#' @export

Analyze_Fisher <- function(
  dfTransformed,
  strOutcome = "Numerator"
) {
  stop_if(cnd = !is.data.frame(dfTransformed), message = "dfTransformed is not a data.frame")
  stop_if(cnd = !all(c("GroupID", strOutcome) %in% names(dfTransformed)), message = "GroupID or the value in strOutcome not found in dfTransformed")
  stop_if(cnd = !all(!is.na(dfTransformed[["GroupID"]])), message = "NA value(s) found in GroupID")
  stop_if(cnd = length(strOutcome) != 1, message = "strOutcome must be length 1")
  stop_if(cnd = !is.character(strOutcome), message = "strOutcome is not character")

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
