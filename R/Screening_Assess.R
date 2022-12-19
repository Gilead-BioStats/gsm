#' Screening Assessment
#'
#' @description
#' Evaluates screen failure rate (SF) on mapped subject-level dataset to identify sites that may be over- or under-reporting patient discontinuations.
#'
#' @details
#' The Screening Assessment uses the standard [GSM data pipeline](
#'   https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html
#' ) to flag possible outliers. Additional details regarding the data pipeline and statistical
#' methods are described below.
#'
#' @param dfInput `data.frame` Input data, a data frame with one record per subject.
#' @param vThreshold `numeric` Threshold specification, a vector of length 2 or 4 that defaults to `c(-3, -2, 2, 3)` for a Normal Approximation (`strMethod = "NormalApprox"`),
#'  `c(0.01, 0.05)` for Fisher's exact test (`strMethod = "Fisher"`), and `c(3.491, 5.172)` for a nominal assessment (`strMethod = "Identity"`).
#' @param strMethod `character` Statistical method. Valid values:
#'   - `"NormalApprox"` (default)
#'   - `"Fisher"`
#'   - `"Identity"`
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column. Default: package-defined Screening Assessment mapping.
#' @param strGroup `character` Grouping variable. `"Site"` (the default) uses the column named in `mapping$strSiteCol`. Other valid options using the default mapping are `"Study"` and `"CustomGroup"`.
#' @param nConfLevel `numeric` Confidence level for QTL analysis.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` `lData`, a named list with:
#' - each data frame in the data pipeline
#'   - `dfTransformed`, returned by [gsm::Transform_Rate()]
#'   - `dfAnalyzed`, returned by [gsm::Analyze_NormalApprox()], [gsm::Analyze_Fisher()], or [gsm::Analyze_Identity()]
#'   - `dfFlagged`, returned by [gsm::Flag_NormalApprox()], [gsm::Flag_Fisher()], or [gsm::Flag()]
#'   - `dfSummary`, returned by [gsm::Summarize()]
#' - `list` `lCharts`, a named list with:
#'   - `scatter`, a ggplot2 object returned by [gsm::Visualize_Scatter()]
#'   - `barMetric`, a ggplot2 object returned by [gsm::Visualize_Score()] using strType == "metric"
#'   - `barScore`, a ggplot2 object returned by [gsm::Visualize_Score()] using strType == "score"
#'   - `dfBounds`, returned by [gsm::Analyze_NormalApprox_PredictBounds()] when `strMethod == "NormalApprox"`
#' - `list` `lChecks`, a named list with:
#'   - `dfInput`, a named list returned by [gsm::is_mapping_valid()]
#'   - `status`, a boolean returned by [gsm::is_mapping_valid()]
#'   - `mapping`, a named list that is provided as an argument to the `lMapping` parameter in [gsm::Screening_Assess()]
#'   - `spec`, a named list used to define variable specifications
#'
#' @includeRmd ./man/md/Screening_Assess.md
#' @includeRmd ./man/md/analyze_percent.md
#'
#' @examples
#' dfInput <- Screening_Map_Raw()
#' Screening_assessment_NormalApprox <- Screening_Assess(dfInput, strMethod = "NormalApprox")
#' Screening_assessment_fisher <- Screening_Assess(dfInput, strMethod = "Fisher")
#' Screening_assessment_identity <- Screening_Assess(dfInput, strMethod = "Identity")
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2 cli_text
#' @importFrom yaml read_yaml
#' @importFrom glue glue
#' @importFrom tools toTitleCase
#'
#' @export

Screening_Assess <- function(
  dfInput,
  vThreshold = NULL,
  strMethod = "NormalApprox",
  lMapping = yaml::read_yaml(system.file("mappings", "Screening_Assess.yaml", package = "gsm")),
  strGroup = "Site",
  nConfLevel = NULL,
  bQuiet = TRUE
) {


  # data checking -----------------------------------------------------------
  stopifnot(
    "strMethod is not 'NormalApprox', 'Fisher', 'Identity', or 'QTL'" = strMethod %in% c("NormalApprox", "Fisher", "Identity", "QTL"),
    "strMethod must be length 1" = length(strMethod) == 1,
    "strGroup must be one of: Site, Study, Country, or CustomGroup" = strGroup %in% c("Site", "Study", "Country", "CustomGroup"),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  lMapping$dfInput$strGroupCol <- lMapping$dfInput[[glue::glue("str{strGroup}Col")]]

  lChecks <- CheckInputs(
    context = "Screening_Assess",
    dfs = list(dfInput = dfInput),
    mapping = lMapping,
    bQuiet = bQuiet
  )


  # set thresholds and flagging parameters ----------------------------------
  if (is.null(vThreshold)) {
    vThreshold <- switch(strMethod,
      NormalApprox = c(-3, -2, 2, 3),
      Fisher = c(0.01, 0.05),
      Identity = c(3.491, 5.172),
      QTL = c(0.2)
    )
  }

  strValueColumnVal <- switch(strMethod,
    NormalApprox = NULL,
    Fisher = "Score",
    Identity = "Score"
  )

  # begin running assessment ------------------------------------------------
  if (!lChecks$status) {
    if (!bQuiet) cli::cli_alert_warning("{.fn Screening_Assess} did not run because of failed check.")
    return(list(
      lData = NULL,
      lCharts = NULL,
      lChecks = lChecks
    ))
  } else {
    if (!bQuiet) cli::cli_h2("Initializing {.fn Screening_Assess}")

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
    } else if (strMethod == "QTL") {
      lData$dfAnalyzed <- gsm::Analyze_QTL(lData$dfTransformed, strOutcome = "binary", nConfLevel = nConfLevel)
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
    } else if (strMethod == "QTL") {
      lData$dfFlagged <- gsm::Flag_QTL(lData$dfAnalyzed, vThreshold = vThreshold)
    }

    flag_function_name <- switch(strMethod,
      NormalApprox = "Flag_NormalApprox",
      Identity = "Flag",
      Fisher = "Flag_Fisher",
      QTL = "Flag_QTL"
    )

    if (!bQuiet) cli::cli_alert_success("{.fn {flag_function_name}} returned output with {nrow(lData$dfFlagged)} rows.")


    # dfSummary ---------------------------------------------------------------
    lData$dfSummary <- gsm::Summarize(lData$dfFlagged)
    if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")

    # visualizations ----------------------------------------------------------
    lCharts <- list()
    if (strMethod != "QTL") {
      if (!hasName(lData, "dfBounds")) lData$dfBounds <- NULL



      # rbm-viz setup -----------------------------------------------------------
      dfConfig <- MakeDfConfig(
        strMethod = strMethod,
        strGroup = strGroup,
        strAbbreviation = "SF",
        strMetric = "Screen Failure Rate",
        strNumerator = "Screen Failures",
        strDenominator = "Screened Subjects",
        vThreshold = vThreshold
      )

      if (strMethod != "Identity") {
        lCharts$scatter <- gsm::Visualize_Scatter(dfFlagged = lData$dfFlagged, dfBounds = lData$dfBounds, strGroupLabel = strGroup)

        if (exists("dfBounds", lData)) {
          bounds <- lData$dfBounds
        } else {
          bounds <- NULL
        }

        lCharts$scatterJS <- scatterPlot(
          results = lData$dfFlagged,
          workflow = dfConfig,
          bounds = bounds,
          elementId = "screeningAssessScatter"
        )
        if (!bQuiet) cli::cli_alert_success("Created {length(lCharts)} scatter plot{?s}.")
      }


      # bar charts --------------------------------------------------------------

      lCharts$barMetric <- gsm::Visualize_Score(dfFlagged = lData$dfFlagged, strType = "metric")
      lCharts$barScore <- gsm::Visualize_Score(dfFlagged = lData$dfFlagged, strType = "score", vThreshold = vThreshold)

      lCharts$barMetricJS <- barChart(
        results = lData$dfFlagged,
        workflow = dfConfig,
        yaxis = "metric",
        elementId = "screeningAssessMetric"
      )

      lCharts$barScoreJS <- barChart(
        results = lData$dfFlagged,
        workflow = dfConfig,
        yaxis = "score",
        elementId = "screeningAssessScore"
      )

      if (!bQuiet) cli::cli_alert_success("Created {length(names(lCharts)[!names(lCharts) %in% c('scatter', 'scatterJS')])} bar chart{?s}.")
    }

    # return data -------------------------------------------------------------
    return(list(
      lData = lData,
      lCharts = lCharts,
      lChecks = lChecks
    ))
  }
}
