#' Protocol Deviation Assessment (Rate)
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Evaluates Protocol Deviation (PD) rates to identify sites that may be over- or under-reporting PDs.
#'
#' @details
#' The PD Assessment uses the standard [GSM data pipeline](
#'   https://gilead-biostats.github.io/gsm/articles/DataPipeline.html
#' ) to flag possible outliers. Additional details regarding the data pipeline and statistical
#' methods are described below.
#'
#' @param dfInput `data.frame` Input data, a data frame with one record per subject.
#' @param vThreshold `numeric` Threshold specification, a vector of length 2 or 4 that defaults to `c(-3, -2, 2, 3)` for a Normal Approximation (`strMethod = "NormalApprox"`),
#'   `c(-7, -5, 5, 7)` for a Poisson model (`strMethod = "Poisson"`), and `c(0.000895, 0.003059)` for a nominal assessment (`strMethod = "Identity"`).
#' @param strMethod `character` Statistical method. Valid values:
#'   - `"NormalApprox"` (default)
#'   - `"Poisson"`
#'   - `"Identity"`
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column. Default: package-defined Protocol Deviation Assessment mapping.
#' @param lLabels `list` Labels used to populate chart labels.
#' @param strGroup `character` Grouping variable. `"Site"` (the default) uses the column named in `mapping$strSiteCol`. Other valid options using the default mapping are `"Study"`, `"Country"`, and `"CustomGroup"`.
#' @param nMinDenominator `numeric` Specifies the minimum denominator required to return a `score` and calculate a `flag`. Default: NULL
#' @param nConfLevel `numeric` Confidence level for QTL analysis.
#' @param bMakeCharts `logical` Boolean value indicating whether to create charts.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` `lData`, a named list with:
#' - each data frame in the data pipeline
#'   - `dfTransformed`, returned by [gsm::Transform_Rate()]
#'   - `dfAnalyzed`, returned by [gsm::Analyze_NormalApprox()], [gsm::Analyze_Poisson()] or [gsm::Analyze_Identity()]
#'   - `dfFlagged`, returned by [gsm::Flag_NormalApprox()], [gsm::Flag_Poisson()], or [gsm::Flag()]
#'   - `dfSummary`, returned by [gsm::Summarize()]
#'   - `dfBounds`, returned by [gsm::Analyze_NormalApprox_PredictBounds()] when `strMethod == "NormalApprox"` or [gsm::Analyze_Poisson_PredictBounds()] when `strMethod == "Poisson"`
#' - `list` `lCharts`, a named list with:
#'   - `scatter`, a ggplot2 object returned by [gsm::Visualize_Scatter()] only when strMethod != "Identity"
#'   - `barMetric`, a ggplot2 object returned by [gsm::Visualize_Score()]
#'   - `barScore`, a ggplot2 object returned by [gsm::Visualize_Score()]
#' - `list` `lChecks`, a named list with:
#'   - `dfInput`, a named list returned by [gsm::is_mapping_valid()]
#'   - `status`, a boolean returned by [gsm::is_mapping_valid()]
#'   - `mapping`, a named list that is provided as an argument to the `lMapping` parameter in [gsm::PD_Assess_Rate()]
#'   - `spec`, a named list used to define variable specifications
#'
#' @includeRmd ./man/md/PD_Assess_Rate.md
#' @includeRmd ./man/md/analyze_rate.md
#'
#' @examples
#' dfInput <- PD_Map_Raw_Rate()
#' pd_assessment_NormalApprox <- PD_Assess_Rate(dfInput)
#' pd_assessment_poisson <- PD_Assess_Rate(dfInput, strMethod = "Poisson")
#' pd_assessment_identity <- PD_Assess_Rate(dfInput, strMethod = "Identity")
#'
#' @export

PD_Assess_Rate <- function(
  dfInput,
  vThreshold = NULL,
  strMethod = "NormalApprox",
  lMapping = yaml::read_yaml(system.file("mappings", "PD_Assess_Rate.yaml", package = "gsm")),
  lLabels = list(
    workflowid = "",
    group = strGroup,
    abbreviation = "PD",
    metric = "Protocol Deviation Rate",
    numerator = "Protocol Deviations",
    denominator = "Days on Study",
    model = "Normal Approximation",
    score = "Adjusted Z-Score"
  ),
  strGroup = "Site",
  nMinDenominator = NULL,
  nConfLevel = NULL,
  bMakeCharts = FALSE,
  bQuiet = TRUE
) {
  # data checking -----------------------------------------------------------
  stopifnot(
    "strMethod is not 'NormalApprox', 'Poisson', 'Identity', or 'QTL'" = strMethod %in% c("NormalApprox", "Poisson", "Identity", "QTL"),
    "strMethod must be length 1" = length(strMethod) == 1,
    "strGroup must be one of: Site, Study, Country, or CustomGroup" = strGroup %in% c("Site", "Study", "Country", "CustomGroup"),
    "bQuiet must be logical" = is.logical(bQuiet)
  )


  lMapping$dfInput$strGroupCol <- lMapping$dfInput[[glue::glue("str{strGroup}Col")]]

  lChecks <- gsm::CheckInputs(
    context = "PD_Assess_Rate",
    dfs = list(dfInput = dfInput),
    mapping = lMapping,
    bQuiet = bQuiet
  )

  # set thresholds and flagging parameters ----------------------------------
  if (is.null(vThreshold)) {
    vThreshold <- switch(strMethod,
      NormalApprox = c(-3, -2, 2, 3),
      Poisson = c(-7, -5, 5, 7),
      Identity = c(0.000895, 0.003059),
      QTL = c(0.01)
    )
  }

  strValueColumnVal <- switch(strMethod,
    NormalApprox = NULL,
    Poisson = NULL,
    Identity = "Score"
  )

  # begin running assessment ------------------------------------------------
  if (!lChecks$status) {
    if (!bQuiet) cli::cli_alert_warning("{.fn PD_Assess_Rate} did not run because of failed check.")
    return(list(
      lData = NULL,
      lCharts = NULL,
      lChecks = lChecks
    ))
  } else {
    if (!bQuiet) cli::cli_h2("Initializing {.fn PD_Assess_Rate}")

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
    if (strMethod == "NormalApprox") {
      lData$dfAnalyzed <- gsm::Analyze_NormalApprox(
        dfTransformed = lData$dfTransformed,
        strType = "rate",
        bQuiet = bQuiet
      )

      lData$dfBounds <- gsm::Analyze_NormalApprox_PredictBounds(
        dfTransformed = lData$dfTransformed,
        vThreshold = vThreshold,
        strType = "rate",
        bQuiet = bQuiet
      )
    } else if (strMethod == "Poisson") {
      lData$dfAnalyzed <- gsm::Analyze_Poisson(lData$dfTransformed, bQuiet = bQuiet)
      lData$dfBounds <- gsm::Analyze_Poisson_PredictBounds(lData$dfTransformed, vThreshold = vThreshold, bQuiet = bQuiet)
    } else if (strMethod == "Identity") {
      lData$dfAnalyzed <- gsm::Analyze_Identity(lData$dfTransformed)
    } else if (strMethod == "QTL") {
      lData$dfAnalyzed <- gsm::Analyze_QTL(lData$dfTransformed, strOutcome = "rate", nConfLevel = nConfLevel)
    }


    strAnalyzeFunction <- paste0("Analyze_", tools::toTitleCase(strMethod))
    if (!bQuiet) cli::cli_alert_success("{.fn {strAnalyzeFunction}} returned output with {nrow(lData$dfAnalyzed)} rows.")

    # dfFlagged ---------------------------------------------------------------
    if (strMethod == "NormalApprox") {
      lData$dfFlagged <- gsm::Flag_NormalApprox(lData$dfAnalyzed, vThreshold = vThreshold)
    } else if (strMethod == "Poisson") {
      lData$dfFlagged <- gsm::Flag_Poisson(lData$dfAnalyzed, vThreshold = vThreshold)
    } else if (strMethod == "Identity") {
      lData$dfFlagged <- gsm::Flag(lData$dfAnalyzed, vThreshold = vThreshold, strValueColumn = strValueColumnVal)
    } else if (strMethod == "QTL") {
      lData$dfFlagged <- gsm::Flag_QTL(lData$dfAnalyzed, vThreshold = vThreshold)
    }

    flag_function_name <- switch(strMethod,
      NormalApprox = "Flag_NormalApprox",
      Identity = "Flag",
      Poisson = "Flag_Poisson",
      QTL = "Flag_QTL"
    )

    if (!bQuiet) cli::cli_alert_success("{.fn {flag_function_name}} returned output with {nrow(lData$dfFlagged)} rows.")

    # dfSummary ---------------------------------------------------------------
    lData$dfSummary <- gsm::Summarize(lData$dfFlagged, nMinDenominator = nMinDenominator, bQuiet = bQuiet)
    if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")



    # visualizations ----------------------------------------------------------
    if (strMethod != "QTL") {
      if (!hasName(lData, "dfBounds")) lData$dfBounds <- NULL

      lOutput <- list(
        lData = lData,
        lChecks = lChecks
      )

      if (bMakeCharts) {
        lOutput$lCharts <- MakeKRICharts(dfSummary = lData$dfSummary, dfBounds = lData$dfBounds, lLabels = lLabels)
        if (!bQuiet) cli::cli_alert_success("Created {length(lOutput$lCharts)} chart{?s}.")
      }
    } else {
      lOutput <- list(
        lData = lData,
        lChecks = lChecks
      )
    }

    # return data -------------------------------------------------------------
    return(lOutput)
  }
}
