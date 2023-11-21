#' LB_Assess Function
#'
#' The LB_Assess function performs an assessment on a given input data frame. It checks the validity of the input parameters, sets thresholds and flagging parameters based on the chosen method, and then runs the assessment using the specified method. It returns a list containing the transformed data, analyzed data, flagged data, summary data, and charts.
#'
#' @param dfInput The input data frame containing the data to be assessed.
#' @param vThreshold The threshold values used for flagging abnormality.
#' @param strMethod The method used for analysis, which can be "NormalApprox", "Fisher", or "Identity".
#' @param lMapping A mapping object used for data checking.
#' @param strGroup The grouping variable used for analysis.
#' @param nMinDenominator The minimum denominator value for calculating summary statistics.
#' @param bQuiet A logical value indicating whether to display progress messages.
#'
#' @return A list containing the transformed data, analyzed data, flagged data, summary data, and charts.
#'
#' @examples
#' df <- data.frame(
#'   Site = c("A", "A", "B", "B"),
#'   Count = c(10, 5, 8, 4),
#'   Total = c(100, 200, 150, 300)
#' )
#'
#' result <- LB_Assess(df, vThreshold = c(-2, 2), strMethod = "NormalApprox", strGroup = "Site")
#'
#' print(result$lData$dfTransformed)
#' print(result$lData$dfAnalyzed)
#' print(result$lData$dfFlagged)
#' print(result$lData$dfSummary)
#' print(result$lCharts$scatter)
#' print(result$lCharts$barMetric)
#' print(result$lCharts$barScore)
#'
#' @export
LB_Assess <- function(
    dfInput,
    vThreshold = NULL,
    strMethod = "NormalApprox",
    lMapping = yaml::read_yaml(system.file("mappings", "LB_Assess.yaml", package = "gsm")),
    strGroup = "Site",
    nMinDenominator = NULL,
    bQuiet = TRUE) {
  # function code
}
LB_Assess <- function(
    dfInput,
    vThreshold = NULL,
    strMethod = "NormalApprox",
    lMapping = yaml::read_yaml(system.file("mappings", "LB_Assess.yaml", package = "gsm")),
    strGroup = "Site",
    nMinDenominator = NULL,
    bQuiet = TRUE) {
  # data checking -----------------------------------------------------------
  stopifnot(
    "strMethod is not 'NormalApprox', 'Fisher' or 'Identity'" = strMethod %in% c("NormalApprox", "Fisher", "Identity"),
    "strMethod must be length 1" = length(strMethod) == 1,
    "strGroup must be one of: Site, Study, Country, or CustomGroup" = strGroup %in% c("Site", "Study", "Country", "CustomGroup"),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  lMapping$dfInput$strGroupCol <- lMapping$dfInput[[glue::glue("str{strGroup}Col")]]

  lChecks <- gsm::CheckInputs(
    context = "LB_Assess",
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
    if (!bQuiet) cli::cli_alert_warning("{.fn LB_Assess} did not run because of failed check.")
    return(list(
      lData = NULL,
      lCharts = NULL,
      lChecks = lChecks
    ))
  } else {
    if (!bQuiet) cli::cli_h2("Initializing {.fn LB_Assess}")

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

    dfConfig <- MakeDfConfig(
      strMethod = strMethod,
      strGroup = strGroup,
      strAbbreviation = "LB",
      strMetric = "Lab Abnormality Rate",
      strNumerator = "Abnormal Lab Samples",
      strDenominator = "Total Lab Samples",
      vThreshold = vThreshold
    )



    if (strMethod != "Identity") {
      lCharts$scatter <- gsm::Visualize_Scatter(dfSummary = lData$dfSummary, dfBounds = lData$dfBounds, strGroupLabel = strGroup)


      # rbm-viz charts ----------------------------------------------------------
      lCharts$scatterJS <- gsm::Widget_ScatterPlot(
        results = lData$dfSummary,
        workflow = dfConfig,
        bounds = lData$dfBounds,
        elementId = "lbAssessScatter",
        siteSelectLabelValue = strGroup
      )

      if (!bQuiet) cli::cli_alert_success("Created {length(lCharts)} scatter plot{?s}.")
    }

    lCharts$barMetric <- gsm::Visualize_Score(dfSummary = lData$dfSummary, strType = "metric")
    lCharts$barScore <- gsm::Visualize_Score(dfSummary = lData$dfSummary, strType = "score", vThreshold = vThreshold)

    lCharts$barMetricJS <- gsm::Widget_BarChart(
      results = lData$dfSummary,
      workflow = dfConfig,
      yaxis = "metric",
      elementId = "lbAssessMetric",
      siteSelectLabelValue = strGroup
    )

    lCharts$barScoreJS <- gsm::Widget_BarChart(
      results = lData$dfSummary,
      workflow = dfConfig,
      yaxis = "score",
      elementId = "lbAssessScore",
      siteSelectLabelValue = strGroup
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
