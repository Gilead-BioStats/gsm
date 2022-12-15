#' Consent Assessment
#'
#' `r lifecycle::badge("experimental")`
#'
#' @description
#' Evaluates sites where subject consent was:
#' - not given
#' - never obtained
#' - not followed by subject randomization
#' - obtained after subject randomization
#'
#' @details
#' The Consent Assessment uses the standard [GSM data pipeline](
#'   https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html
#' ) to flag sites with consent issues. This assessment detects sites with subjects who participated
#' in study activities before consent was finalized. The count returned in the summary represents
#' the number of subjects at a given site for whom:
#'
#' - consent was not given
#' - consent was not obtained
#' - consent did not result in randomization
#' - consent was obtained after randomization
#'
#' Additional details regarding the data pipeline and statistical methods are described below.
#'
#' @param dfInput `data.frame` Input data, a data frame with one record per subject.
#' @param nThreshold `numeric` Threshold specification. Default: `0.5`
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column. Default: package-defined Consent Assessment mapping.
#' @param strGroup `character` Grouping variable. `"Site"` (the default) uses the column named in `mapping$strSiteCol`. Other valid options using the default mapping are `"Study"` and `"CustomGroup"`.
#' @param nMinDenominator `numeric` Specifies the minimum denominator required to return a `score` and calculate a `flag`. Default: NULL
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` `lData`, a named list with:
#' - each data frame in the data pipeline
#'   - `dfTransformed`, returned by [gsm::Transform_Count()]
#'   - `dfAnalyzed`, returned by [gsm::Analyze_Identity()]
#'   - `dfFlagged`, returned by [gsm::Flag()]
#'   - `dfSummary`, returned by [gsm::Summarize()]
#' - `list` `lCharts`, a named list with:
#'   - `barMetric`, a ggplot2 object returned by [gsm::Visualize_Score()] using strType == "metric"
#'   - `barScore`, a ggplot2 object returned by [gsm::Visualize_Score()] using strType == "score"
#' - `list` `lChecks`, a named list with:
#'   - `dfInput`, a named list returned by [gsm::is_mapping_valid()]
#'   - `status`, a boolean returned by [gsm::is_mapping_valid()]
#'   - `mapping`, a named list that is provided as an argument to the `lMapping` parameter in [gsm::Consent_Assess()]
#'   - `spec`, a named list used to define variable specifications
#'
#' @includeRmd ./man/md/Consent_Assess.md
#'
#' @examples
#' dfInput <- Consent_Map_Raw()
#' consent_assessment <- Consent_Assess(dfInput)
#'
#' @importFrom cli cli_alert_info cli_alert_success cli_alert_warning cli_h2 cli_text
#' @importFrom yaml read_yaml
#' @importFrom glue glue
#' @importFrom tools toTitleCase
#'
#' @export

Consent_Assess <- function(
  dfInput,
  nThreshold = 0.5,
  lMapping = yaml::read_yaml(system.file("mappings", "Consent_Assess.yaml", package = "gsm")),
  strGroup = "Site",
  nMinDenominator = NULL,
  bQuiet = TRUE
) {

  # data checking -----------------------------------------------------------
  stopifnot(
    "nThreshold must be numeric" = is.numeric(nThreshold),
    "nThreshold must be length 1" = length(nThreshold) == 1,
    "strGroup must be one of: Site, Study, Country, or CustomGroup" = strGroup %in% c("Site", "Study", "Country", "CustomGroup"),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  lMapping$dfInput$strGroupCol <- lMapping$dfInput[[glue::glue("str{strGroup}Col")]]

  lChecks <- gsm::CheckInputs(
    context = "Consent_Assess",
    dfs = list(dfInput = dfInput),
    mapping = lMapping,
    bQuiet = bQuiet
  )

  # begin running assessment ------------------------------------------------
  if (!lChecks$status) {
    if (!bQuiet) cli::cli_alert_warning("{.fn Consent_Assess} did not run because of failed check.")
    return(list(
      lData = NULL,
      lCharts = NULL,
      lChecks = lChecks
    ))
  } else {
    if (!bQuiet) cli::cli_h2("Initializing {.fn Consent_Assess}")
    if (!bQuiet) cli::cli_text("Input data has {nrow(dfInput)} rows.")
    lData <- list()
    lData$dfTransformed <- gsm::Transform_Count(
      dfInput = dfInput,
      strGroupCol = lMapping$dfInput$strGroupCol,
      strCountCol = "Count"
    )
    if (!bQuiet) cli::cli_alert_success("{.fn Transform_Count} returned output with {nrow(lData$dfTransformed)} rows.")

    # dfAnalyzed --------------------------------------------------------------
    lData$dfAnalyzed <- gsm::Analyze_Identity(lData$dfTransformed, bQuiet = bQuiet)
    if (!bQuiet) cli::cli_alert_info("No analysis function used. {.var dfTransformed} copied directly to {.var dfAnalyzed}.")

    # dfFlagged ---------------------------------------------------------------
    lData$dfFlagged <- gsm::Flag(lData$dfAnalyzed, vThreshold = c(NA, nThreshold))
    if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lData$dfFlagged)} rows.")

    # dfSummary ---------------------------------------------------------------
    lData$dfSummary <- gsm::Summarize(lData$dfFlagged)
    if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")

    # visualizations ----------------------------------------------------------
    lCharts <- list()

    dfConfig <- MakeDfConfig(
      strMethod = "identity",
      strGroup = strGroup,
      strAbbreviation = "CONSENT",
      strMetric = "Consent Issues",
      strNumerator = "Consent Issues",
      strDenominator = "",
      vThreshold = nThreshold
    )

    lCharts$barMetric <- gsm::Visualize_Score(dfFlagged = lData$dfFlagged, strType = "metric")
    lCharts$barScore <- gsm::Visualize_Score(dfFlagged = lData$dfFlagged, strType = "score")

    lCharts$barMetricJS <- barChart(
      results = lData$dfFlagged,
      workflow = dfConfig,
      yaxis = "metric",
      elementId = "consentAssessMetric"
    )

    lCharts$barScoreJS <- barChart(
      results = lData$dfFlagged,
      workflow = dfConfig,
      yaxis = "score",
      elementId = "consentAssessScore"
    )

    if (!bQuiet) cli::cli_alert_success("Created {length(lCharts)} bar chart{?s}.")

    # return data -------------------------------------------------------------
    return(list(
      lData = lData,
      lCharts = lCharts,
      lChecks = lChecks
    ))
  }
}
