#' Disposition Assessment
#'
#' @description
#' Evaluates disposition rate (DISP) on mapped subject-level dataset to identify sites that may be over- or under-reporting patient discontinuations.
#'
#' @details
#' The Disposition Assessment uses the standard [GSM data pipeline](
#'   https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html
#' ) to flag possible outliers. Additional details regarding the data pipeline and statistical
#' methods are described below.
#'
#' @param dfInput `data.frame` Input data, a data frame with one record per subject.
#' @param vThreshold `numeric` Threshold specification, a vector of length 2 that defaults to
#' `c(0.01, 0.05)` for Fisher's exact test (`strMethod` = "fisher") and `c(3.491, 5.172)` for a nominal assessment (`strMethod = "identity"`).
#' @param strMethod `character` Statistical method. Valid values:
#'   - `"fisher"` (default)
#'   - `"identity"`
#' @param lMapping Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column.
#' @param strGroup `character` Grouping variable. `"Site"` (the default) uses the column named in `mapping$strSiteCol`. Other valid options using the default mapping are `"Study"` and `"CustomGroup"`.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` `lData`, a named list with:
#' - each data frame in the data pipeline
#'   - `dfTransformed`, returned by [gsm::Transform_Rate()]
#'   - `dfAnalyzed`, returned by [gsm::Analyze_Fisher()] or [gsm::Analyze_Identity()]
#'   - `dfFlagged`, returned by [gsm::Flag()] or [gsm::Flag_Fisher()]
#'   - `dfSummary`, returned by [gsm::Summarize()]
#' - `list` `lCharts`, a named list with:
#'   - `scatter`, a ggplot2 object returned by [gsm::Visualize_Scatter()]
#'   - `barMetric`, a ggplot2 object returned by [gsm::Visualize_Score()] using strType == "metric"
#'   - `barScore`, a ggplot2 object returned by [gsm::Visualize_Score()] using strType == "score"
#' - `list` `lChecks`, a named list with:
#'   - `dfInput`, a named list returned by [gsm::is_mapping_valid()]
#'   - `status`, a boolean returned by [gsm::is_mapping_valid()]
#'   - `mapping`, a named list that is provided as an argument to the `lMapping` parameter in [gsm::Disp_Assess()]
#'   - `spec`, a named list used to define variable specifications
#'
#' @includeRmd ./man/md/Disp_Assess.md
#' @includeRmd ./man/md/analyze_percent.md
#'
#' @examples
#' dfInput <- Disp_Map_Raw()
#' disp_assessment_fisher <- Disp_Assess(dfInput, strMethod = "fisher")
#' disp_assessment_identity <- Disp_Assess(dfInput, strMethod = "identity")
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2 cli_text
#' @importFrom yaml read_yaml
#' @importFrom glue glue
#' @importFrom tools toTitleCase
#'
#' @export

Disp_Assess <- function(
  dfInput,
  vThreshold = NULL,
  strMethod = "fisher",
  lMapping = yaml::read_yaml(system.file("mappings", "Disp_Assess.yaml", package = "gsm")),
  strGroup = "Site",
  bQuiet = TRUE
) {


  # data checking -----------------------------------------------------------
  stopifnot(
    "strMethod is not 'fisher' or 'identity'" = strMethod %in% c("fisher", "identity"),
    "strMethod must be length 1" = length(strMethod) == 1,
    "strGroup must be one of: Site, Study, or CustomGroup" = strGroup %in% c("Site", "Study", "CustomGroup"),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  lMapping$dfInput$strGroupCol <- lMapping$dfInput[[glue::glue("str{strGroup}Col")]]

  lChecks <- CheckInputs(
    context = "Disp_Assess",
    dfs = list(dfInput = dfInput),
    mapping = lMapping,
    bQuiet = bQuiet
  )


  # set thresholds and flagging parameters ----------------------------------
  if (is.null(vThreshold)) {
    vThreshold <- switch(strMethod,
      fisher = c(0.01, 0.05),
      identity = c(3.491, 5.172)
    )
  }

  strValueColumnVal <- switch(strMethod,
    fisher = "Score",
    identity = "Score"
  )

  # begin running assessment ------------------------------------------------
  if (!lChecks$status) {
    if (!bQuiet) cli::cli_alert_warning("{.fn Disp_Assess} did not run because of failed check.")
    return(list(
      lData = NULL,
      lCharts = NULL,
      lChecks = lChecks
    ))
  } else {
    if (!bQuiet) cli::cli_h2("Initializing {.fn Disp_Assess}")

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
    if (strMethod == "fisher") {
      lData$dfAnalyzed <- gsm::Analyze_Fisher(lData$dfTransformed, bQuiet = bQuiet)
    } else if (strMethod == "identity") {
      lData$dfAnalyzed <- gsm::Analyze_Identity(lData$dfTransformed)
    }

    strAnalyzeFunction <- paste0("Analyze_", tools::toTitleCase(strMethod))
    if (!bQuiet) cli::cli_alert_success("{.fn {strAnalyzeFunction}} returned output with {nrow(lData$dfAnalyzed)} rows.")

    # dfFlagged ---------------------------------------------------------------
    if (strMethod == "fisher") {
      lData$dfFlagged <- gsm::Flag_Fisher(lData$dfAnalyzed, vThreshold = vThreshold)
    } else {
      lData$dfFlagged <- gsm::Flag(lData$dfAnalyzed, vThreshold = vThreshold, strValueColumn = strValueColumnVal)
    }

    flag_function_name <- switch(strMethod,
      identity = "Flag",
      fisher = "Flag_Fisher"
    )

    if (!bQuiet) cli::cli_alert_success("{.fn {flag_function_name}} returned output with {nrow(lData$dfFlagged)} rows.")


    # dfSummary ---------------------------------------------------------------
    lData$dfSummary <- gsm::Summarize(lData$dfFlagged)
    if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")

    # visualizations ----------------------------------------------------------
    lCharts <- list()

    if (!hasName(lData, "dfBounds")) lData$dfBounds <- NULL

    if (strMethod != "identity") {
      lCharts$scatter <- Visualize_Scatter(dfFlagged = lData$dfFlagged, dfBounds = lData$dfBounds, strGroupLabel = strGroup)
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
