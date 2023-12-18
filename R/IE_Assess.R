#' Inclusion/Exclusion Assessment
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Evaluates sites exhibiting aberrant or excessive rates of unmet or missing inclusion/exclusion (IE) criteria.
#'
#' @details
#' The Inclusion/Exclusion Assessment uses the standard [GSM data pipeline](
#'   https://gilead-biostats.github.io/gsm/articles/DataPipeline.html
#' ) to flag sites with IE issues. This assessment detects sites with excessive rates of unmet or
#' missing IE criteria, as defined by `nThreshold`. The count returned in the summary represents the
#' number of subjects at a given site with at least one unmet or missing IE criterion.
#'
#' @param dfInput `data.frame` Input data, a data frame with one record per subject.
#' @param nThreshold `numeric` Threshold specification. Default: `0.5`
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column. Default: package-defined Inclusion/Exclusion Assessment mapping.
#' @param lLabels `list` Labels used to populate chart labels.
#' @param strGroup `character` Grouping variable. `"Site"` (the default) uses the column named in `mapping$strSiteCol`. Other valid options using the default mapping are `"Study"`, `"Country"`, and `"CustomGroup"`.
#' @param nMinDenominator `numeric` Specifies the minimum denominator required to return a `score` and calculate a `flag`. Default: NULL
#' @param bMakeCharts `logical` Boolean value indicating whether to create charts.
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
#'   - `mapping`, a named list that is provided as an argument to the `lMapping` parameter in [gsm::IE_Assess()]
#'   - `spec`, a named list used to define variable specifications
#'
#' @includeRmd ./man/md/IE_Assess.md
#'
#' @examples
#' dfInput <- IE_Map_Raw()
#' ie_assessment <- IE_Assess(dfInput)
#'
#' @importFrom cli cli_alert_info cli_alert_success cli_alert_warning cli_h2 cli_text
#' @importFrom yaml read_yaml
#' @importFrom glue glue
#' @import dplyr
#' @importFrom tools toTitleCase
#'
#' @export

IE_Assess <- function(
  dfInput,
  nThreshold = 0.5,
  lMapping = yaml::read_yaml(system.file("mappings", "IE_Assess.yaml", package = "gsm")),
  lLabels = list(
    workflowid = "",
    group = strGroup,
    abbreviation = "IE",
    metric = "Inclusion/Exclusion Issues",
    numerator = "Inclusion/Exclusion Issues",
    denominator = "",
    model = "Normal Approximation",
    score = "Adjusted Z-Score"
  ),
  strGroup = "Site",
  nMinDenominator = NULL,
  bMakeCharts = FALSE,
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

  lChecks <- CheckInputs(
    context = "IE_Assess",
    dfs = list(dfInput = dfInput),
    mapping = lMapping,
    bQuiet = bQuiet
  )


  # begin running assessment ------------------------------------------------
  if (!lChecks$status) {
    if (!bQuiet) cli::cli_alert_warning("{.fn IE_Assess} did not run because of failed check.")
    return(list(
      lData = NULL,
      lCharts = NULL,
      lChecks = lChecks
    ))
  } else {
    if (!bQuiet) cli::cli_h2("Initializing {.fn IE_Assess}")
    if (!bQuiet) cli::cli_text("Input data has {nrow(dfInput)} rows.")
    lData <- list()
    lData$dfTransformed <- gsm::Transform_Count(
      dfInput = dfInput,
      strGroupCol = lMapping$dfInput$strGroupCol,
      strCountCol = "Count"
    )
    if (!bQuiet) cli::cli_alert_success("{.fn Transform_Count} returned output with {nrow(lData$dfTransformed)} rows.")

    # dfAnalyzed --------------------------------------------------------------
    lData$dfAnalyzed <- Analyze_Identity(lData$dfTransformed, bQuiet = bQuiet)
    if (!bQuiet) cli::cli_alert_info("No analysis function used. {.var dfTransformed} copied directly to {.var dfAnalyzed}.")

    # dfFlagged ---------------------------------------------------------------
    lData$dfFlagged <- gsm::Flag(lData$dfAnalyzed, vThreshold = c(NA, nThreshold))
    if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lData$dfFlagged)} rows.")

    # dfSummary ---------------------------------------------------------------
    lData$dfSummary <- gsm::Summarize(lData$dfFlagged, nMinDenominator = nMinDenominator, bQuiet = bQuiet)
    if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")

    lOutput <- list(
      lData = lData,
      lChecks = lChecks
    )

    # visualizations ----------------------------------------------------------
    if (bMakeCharts) {
      lOutput$lCharts <- MakeKRICharts(dfSummary = lData$dfSummary, dfBounds = lData$dfBounds, lLabels = lLabels)
      if (!bQuiet) cli::cli_alert_success("Created {length(lOutput$lCharts)} chart{?s}.")
    }



    # return data -------------------------------------------------------------
    return(lOutput)
  }
}
