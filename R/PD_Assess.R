#' Protocol Deviation Assessment
#'
#' @description
#' Evaluates protocol deviation (PD) rates to identify sites that may be over- or under-reporting PDs.
#'
#' @details
#' The PD Assessment uses the standard [GSM data pipeline](
#'   https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html
#' ) to flag possible outliers. Additional details regarding the data pipeline and statistical
#' methods are described below.
#'
#' @param dfInput `data.frame` Input data, a data frame with one record per subject.
#' @param vThreshold `numeric` Threshold specification, a vector of length 4 that defaults to
#'   `c(-7, -5, 5, 7)` for a Poisson model (`strMethod = "poisson"`) and a vector of length 2
#'   that defaults to `c(0.000895, 0.003059)` for a nominal assessment (`strMethod = "identity"`).
#' @param strMethod `character` Statistical method. Valid values:
#'   - `"poisson"` (default)
#'   - `"identity"`
#' @param lMapping Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column.
#' @param strGroup `character` Grouping variable. `"Site"` (the default) uses the column named in `mapping$strSiteCol`. Other valid options using the default mapping are `"Study"` and `"CustomGroup"`.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` `lData`, a named list with:
#' - each data frame in the data pipeline
#'   - `dfTransformed`, returned by [gsm::Transform_Rate()]
#'   - `dfAnalyzed`, returned by [gsm::Analyze_Poisson()] or [gsm::Analyze_Identity()]
#'   - `dfFlagged`, returned by [gsm::Flag_Poisson()] or [gsm::Flag()]
#'   - `dfSummary`, returned by [gsm::Summarize()]
#'   - `dfBounds`, returned by [gsm::Analyze_Poisson_PredictBounds()] only when strMethod == "poisson"
#' - `list` `lCharts`, a named list with:
#'   - `scatter`, a ggplot2 object returned by [gsm::Visualize_Scatter()] only when strMethod != "identity"
#'   - `barMetric`, a ggplot2 object returned by [gsm::Visualize_Score()]
#'   - `barScore`, a ggplot2 object returned by [gsm::Visualize_Score()]
#' - `list` `lChecks`, a named list with:
#'   - `dfInput`, a named list returned by [gsm::is_mapping_valid()]
#'   - `status`, a boolean returned by [gsm::is_mapping_valid()]
#'   - `mapping`, a named list that is provided as an argument to the `lMapping` parameter in [gsm::PD_Assess()]
#'   - `spec`, a named list used to define variable specifications
#'
#' @includeRmd ./man/md/PD_Assess.md
#' @includeRmd ./man/md/analyze_rate.md
#'
#' @examples
#' dfInput <- PD_Map_Raw()
#' pd_assessment_poisson <- PD_Assess(dfInput)
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2 cli_text
#' @importFrom yaml read_yaml
#' @importFrom glue glue
#'
#' @export

PD_Assess <- function(
  dfInput,
  vThreshold = NULL,
  strMethod = "poisson",
  lMapping = yaml::read_yaml(system.file("mappings", "PD_Assess.yaml", package = "gsm")),
  strGroup = "Site",
  bQuiet = TRUE
) {

  # data checking -----------------------------------------------------------
  stopifnot(
    "strMethod is not 'poisson' or 'identity'" = strMethod %in% c("poisson", "identity"),
    "strMethod must be length 1" = length(strMethod) == 1,
    "strGroup must be one of: Site, Study, or CustomGroup" = strGroup %in% c("Site", "Study", "CustomGroup"),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  lMapping$dfInput$strGroupCol <- lMapping$dfInput[[glue::glue("str{strGroup}Col")]]

  lChecks <- CheckInputs(
    context = "PD_Assess",
    dfs = list(dfInput = dfInput),
    mapping = lMapping,
    bQuiet = bQuiet
  )

  # set thresholds and flagging parameters ----------------------------------
  if (is.null(vThreshold)) {
    vThreshold <- switch(strMethod,
      poisson = c(-7, -5, 5, 7),
      identity = c(0.000895, 0.003059)
    )
  }

  strValueColumnVal <- switch(strMethod,
    poisson = NULL,
    identity = "Score"
  )

  # begin running assessment ------------------------------------------------
  if (!lChecks$status) {
    if (!bQuiet) cli::cli_alert_warning("{.fn PD_Assess} did not run because of failed check.")
    return(list(
      lData = NULL,
      lCharts = NULL,
      lChecks = lChecks
    ))
  } else {
    if (!bQuiet) cli::cli_h2("Initializing {.fn PD_Assess}")

    # dfTransformed -----------------------------------------------------------
    if (!bQuiet) cli::cli_text("Input data has {nrow(dfInput)} rows.")
    lData <- list()
    lData$dfTransformed <- gsm::Transform_Rate(
      dfInput = dfInput,
      strGroupCol = lMapping$dfInput$strGroupCol,
      strNumeratorCol = "Count",
      strDenominatorCol = "Exposure",
      bQuiet = bQuiet
    )
    if (!bQuiet) cli::cli_alert_success("{.fn Transform_Rate} returned output with {nrow(lData$dfTransformed)} rows.")

    # dfAnalyzed --------------------------------------------------------------
    if (strMethod == "poisson") {
      lData$dfAnalyzed <- gsm::Analyze_Poisson(lData$dfTransformed, bQuiet = bQuiet)
      lData$dfBounds <- gsm::Analyze_Poisson_PredictBounds(lData$dfTransformed, vThreshold = vThreshold, bQuiet = bQuiet)
    } else if (strMethod == "identity") {
      lData$dfAnalyzed <- gsm::Analyze_Identity(lData$dfTransformed)
    }

    strAnalyzeFunction <- paste0("Analyze_", tools::toTitleCase(strMethod))
    if (!bQuiet) cli::cli_alert_success("{.fn {strAnalyzeFunction}} returned output with {nrow(lData$dfAnalyzed)} rows.")

    # dfFlagged ---------------------------------------------------------------
    if (strMethod != "identity") {
      lData$dfFlagged <- gsm::Flag_Poisson(lData$dfAnalyzed, vThreshold = vThreshold)
    } else {
      lData$dfFlagged <- gsm::Flag(lData$dfAnalyzed, vThreshold = vThreshold, strValueColumn = strValueColumnVal)
    }

    flag_function_name <- switch(strMethod,
      identity = "Flag",
      poisson = "Flag_Poisson"
    )

    if (!bQuiet) cli::cli_alert_success("{.fn {flag_function_name}} returned output with {nrow(lData$dfFlagged)} rows.")

    # dfSummary ---------------------------------------------------------------
    lData$dfSummary <- gsm::Summarize(lData$dfFlagged)
    if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")

    # visualizations ----------------------------------------------------------
    lCharts <- list()

    if (!hasName(lData, "dfBounds")) lData$dfBounds <- NULL

    if (strMethod != "identity") {
      lCharts$scatter <- gsm::Visualize_Scatter(dfFlagged = lData$dfFlagged, dfBounds = lData$dfBounds, strGroupLabel = strGroup)
      if (!bQuiet) cli::cli_alert_success("{.fn Visualize_Scatter} created {length(lCharts)} chart.")
    }

    lCharts$barMetric <- Visualize_Score(dfFlagged = lData$dfFlagged, strType = "metric")
    lCharts$barScore <- Visualize_Score(dfFlagged = lData$dfFlagged, strType = "score", vThreshold = vThreshold)
    if (!bQuiet) cli::cli_alert_success("{.fn Visualize_Score} created {length(names(lCharts)[names(lCharts) != 'scatter'])} chart{?s}.")

    # return data -------------------------------------------------------------
    return(list(
      lData = lData,
      lCharts = lCharts,
      lChecks = lChecks
    ))
  }
}
