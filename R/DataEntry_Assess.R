#' Data Entry Lag Assessment
#'
#' @description
#' Evaluates rate of reported Data Entry Lag >10 days.
#'
#' @details
#' The Data Entry Lag Assessment uses the standard [GSM data pipeline](
#'   https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html
#' ) to flag possible outliers. Additional details regarding the data pipeline and statistical
#' methods are described below.
#'
#' @param dfInput `data.frame` Input data, a data frame with one record per data pages.
#' @param vThreshold `numeric` Threshold specification, a vector of length 2 or 4 that defaults to `c(-3, -2, 2, 3)` for a Normal Approximation (`strMethod = "NormalApprox"`),
#' `c(.01, .05)` for Fisher's exact test (`strMethod = "Fisher"`), and `c(3.491, 5.172)` for a nominal assessment (`strMethod = "Identity"`).
#' @param strMethod `character` Statistical method. Valid values:
#'   - `"NormalApprox"` (default)
#'   - `"Fisher"`
#'   - `"Identity"`
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column. Default: package-defined Labs Assessment mapping.
#' @param strGroup `character` Grouping variable. `"Site"` (the default) uses the column named in `mapping$strSiteCol`. Other valid options using the default mapping are `"Study"` and `"CustomGroup"`.
#' @param nMinDenominator `numeric` Specifies the minimum denominator required to return a `score` and calculate a `flag`. Default: NULL
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` `lData`, a named list with:
#' - each data frame in the data pipeline
#'   - `dfTransformed`, returned by [gsm::Transform_Rate()]
#'   - `dfAnalyzed`, returned by [gsm::Analyze_NormalApprox()], [gsm::Analyze_Fisher()], or [gsm::Analyze_Identity()]
#'   - `dfFlagged`, returned by [gsm::Flag_NormalApprox()], [gsm::Flag_Fisher()], or [gsm::Flag()]
#'   - `dfSummary`, returned by [gsm::Summarize()]
#'   - `dfBounds`, returned by [gsm::Analyze_NormalApprox_PredictBounds()] when `strMethod == "NormalApprox"`
#' - `list` `lCharts`, a named list with:
#'   - `scatter`, a ggplot2 object returned by [gsm::Visualize_Scatter()] only when strMethod != "Identity"
#'   - `barMetric`, a ggplot2 object returned by [gsm::Visualize_Score()]
#'   - `barScore`, a ggplot2 object returned by [gsm::Visualize_Score()]
#' - `list` `lChecks`, a named list with:
#'   - `dfInput`, a named list returned by [gsm::is_mapping_valid()]
#'   - `status`, a boolean returned by [gsm::is_mapping_valid()]
#'   - `mapping`, a named list that is provided as an argument to the `lMapping` parameter in [gsm::DataEntry_Assess()]
#'   - `spec`, a named list used to define variable specifications
#'
#' @includeRmd ./man/md/QueryAge_Assess.md
#' @includeRmd ./man/md/analyze_percent.md
#'
#' @examples
#' dfInput <- DataEntry_Map_Raw()
#' DataEntry_assessment_NormalApprox <- DataEntry_Assess(dfInput, strMethod = "NormalApprox")
#' DataEntry_assessment_fisher <- DataEntry_Assess(dfInput, strMethod = "Fisher")
#' DataEntry_assessment_identity <- DataEntry_Assess(dfInput, strMethod = "Identity")
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2 cli_text
#' @importFrom yaml read_yaml
#' @importFrom glue glue
#' @importFrom tools toTitleCase
#'
#' @export

DataEntry_Assess <- function(
  dfInput,
  vThreshold = NULL,
  strMethod = "NormalApprox",
  lMapping = yaml::read_yaml(system.file("mappings", "DataEntry_Assess.yaml", package = "gsm")),
  strGroup = "Site",
  nMinDenominator = 30,
  bQuiet = TRUE
) {

  # data checking -----------------------------------------------------------
  stopifnot(
    "strMethod is not 'NormalApprox', 'Fisher' or 'Identity'" = strMethod %in% c("NormalApprox", "Fisher", "Identity"),
    "strMethod must be length 1" = length(strMethod) == 1,
    "strGroup must be one of: Site, Study, Country, or CustomGroup" = strGroup %in% c("Site", "Study", "Country", "CustomGroup"),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  lMapping$dfInput$strGroupCol <- lMapping$dfInput[[glue::glue("str{strGroup}Col")]]

  lChecks <- gsm::CheckInputs(
    context = "DataEntry_Assess",
    dfs = list(dfInput = dfInput),
    mapping = lMapping,
    bQuiet = bQuiet
  )

  # set thresholds and flagging parameters ----------------------------------
  if (is.null(vThreshold)) {
    vThreshold <- switch(strMethod,
      NormalApprox = c(-3, -2, 2, 3),
      Fisher = c(0.01, 0.05),
      Identity = c(3.491, 5.172)
    )
  }

  strValueColumnVal <- switch(strMethod,
    NormalApprox = NULL,
    Fisher = "Score",
    Identity = "Score"
  )

  # begin running assessment ------------------------------------------------
  if (!lChecks$status) {
    if (!bQuiet) cli::cli_alert_warning("{.fn DataEntry_Assess} did not run because of failed check.")
    return(list(
      lData = NULL,
      lCharts = NULL,
      lChecks = lChecks
    ))
  } else {
    if (!bQuiet) cli::cli_h2("Initializing {.fn DataEntry_Assess}")

    # dfTransformed -----------------------------------------------------------
    if (!bQuiet) cli::cli_text("Input data has {nrow(dfInput)} rows.")
    lData <- list()
    lData$dfTransformed <- gsm::Transform_Rate(
      dfInput = dfInput,
      strGroupCol = lMapping$dfInput$strGroupCol,
      strNumeratorCol = "Count",
      strDenominatorCol = "Total",
      bQuiet = bQuiet
    )
    if (!bQuiet) cli::cli_alert_success("{.fn Transform_Rate} returned output with {nrow(lData$dfTransformed)} rows.")

    # dfAnalyzed --------------------------------------------------------------

    if (strMethod == "NormalApprox") {
      lData$dfAnalyzed <- gsm::Analyze_NormalApprox(
        dfTransformed = lData$dfTransformed,
        strType = "binary",
        bQuiet = bQuiet
      )

      lData$dfBounds <- gsm::Analyze_NormalApprox_PredictBounds(
        dfTransformed = lData$dfTransformed,
        vThreshold = vThreshold,
        strType = "binary",
        bQuiet = bQuiet
      )
    } else if (strMethod == "Fisher") {
      lData$dfAnalyzed <- gsm::Analyze_Fisher(lData$dfTransformed, bQuiet = bQuiet)
    } else if (strMethod == "Identity") {
      lData$dfAnalyzed <- gsm::Analyze_Identity(lData$dfTransformed)
    }

    strAnalyzeFunction <- paste0("Analyze_", tools::toTitleCase(strMethod))
    if (!bQuiet) cli::cli_alert_success("{.fn {strAnalyzeFunction}} returned output with {nrow(lData$dfAnalyzed)} rows.")

    # dfFlagged ---------------------------------------------------------------
    if (strMethod == "NormalApprox") {
      lData$dfFlagged <- gsm::Flag_NormalApprox(lData$dfAnalyzed, vThreshold = vThreshold)
    } else if (strMethod == "Fisher") {
      lData$dfFlagged <- gsm::Flag_Fisher(lData$dfAnalyzed, vThreshold = vThreshold)
    } else if (strMethod == "Identity") {
      lData$dfFlagged <- gsm::Flag(lData$dfAnalyzed, vThreshold = vThreshold, strValueColumn = strValueColumnVal)
    }

    flag_function_name <- switch(strMethod,
      NormalApprox = "Flag_NormalApprox",
      Identity = "Flag",
      Fisher = "Flag_Fisher"
    )

    if (!bQuiet) cli::cli_alert_success("{.fn {flag_function_name}} returned output with {nrow(lData$dfFlagged)} rows.")

    # dfSummary ---------------------------------------------------------------
    lData$dfSummary <- gsm::Summarize(lData$dfFlagged, nMinDenominator = nMinDenominator, bQuiet = bQuiet)
    if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")

    # visualizations ----------------------------------------------------------
    lCharts <- list()

    if (!hasName(lData, "dfBounds")) lData$dfBounds <- NULL

    # rbm-viz setup -----------------------------------------------------------

    dfConfig <- MakeDfConfig(
      strMethod = strMethod,
      strGroup = strGroup,
      strAbbreviation = "ODAT",
      strMetric = "Outstanding Data Entry Rate",
      strNumerator = "Data Pages Entered > 10 Days",
      strDenominator = "Total Data Pages",
      vThreshold = vThreshold
    )

    if (strMethod != "Identity") {
      lCharts$scatter <- gsm::Visualize_Scatter(dfSummary = lData$dfSummary, dfBounds = lData$dfBounds, strGroupLabel = strGroup)

      lCharts$scatterJS <- scatterPlot(
        results = lData$dfSummary,
        workflow = dfConfig,
        bounds = lData$dfBounds,
        elementId = "dataEntryAssessScatter"
      )

      if (!bQuiet) cli::cli_alert_success("Created {length(lCharts)} scatter plot{?s}.")
    }

    lCharts$barMetric <- gsm::Visualize_Score(dfSummary = lData$dfSummary, strType = "metric")
    lCharts$barScore <- gsm::Visualize_Score(dfSummary = lData$dfSummary, strType = "score", vThreshold = vThreshold)

    lCharts$barMetricJS <- barChart(
      results = lData$dfSummary,
      workflow = dfConfig,
      yaxis = "metric",
      elementId = "dataEntryAssessMetric"
    )

    lCharts$barScoreJS <- barChart(
      results = lData$dfSummary,
      workflow = dfConfig,
      yaxis = "score",
      elementId = "dataEntryAssessScore"
    )

    if (!bQuiet) cli::cli_alert_success("Created {length(names(lCharts)[!names(lCharts) %in% c('scatter', 'scatterJS')])} bar chart{?s}.")


    # return data -------------------------------------------------------------
    return(list(
      lData = lData,
      lCharts = lCharts,
      lChecks = lChecks
    ))
  }
}
