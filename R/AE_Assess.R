function(
    dfInput, vThreshold = NULL, strMethod = "NormalApprox",
    lMapping = yaml::read_yaml(system.file("mappings", "AE_Assess.yaml",
      package = "gsm"
    )), strGroup = "Site", nMinDenominator = NULL,
    bQuiet = TRUE) {
  stopifnot(`strMethod is not 'NormalApprox', 'Poisson' or 'Identity'` = strMethod %in%
    c("NormalApprox", "Poisson", "Identity"), `strMethod must be length 1` = length(strMethod) ==
    1, `strGroup must be one of: Site, Study, Country, or CustomGroup` = strGroup %in%
    c("Site", "Study", "Country", "CustomGroup"), `bQuiet must be logical` = is.logical(bQuiet))
  lMapping$dfInput$strGroupCol <- lMapping$dfInput[[glue::glue("str{strGroup}Col")]]
  lChecks <- gsm::CheckInputs(
    context = "AE_Assess", dfs = list(dfInput = dfInput),
    mapping = lMapping, bQuiet = bQuiet
  )
  if (is.null(vThreshold)) {
    vThreshold <- switch(strMethod,
      NormalApprox = c(
        -3,
        -2, 2, 3
      ),
      Poisson = c(-7, -5, 5, 7),
      Identity = c(
        6e-05,
        0.01
      )
    )
  }
  strValueColumnVal <- switch(strMethod,
    NormalApprox = NULL,
    Poisson = NULL,
    Identity = "Score"
  )
  if (!lChecks$status) {
    if (!bQuiet) {
      cli::cli_alert_warning("{.fn AE_Assess} did not run because of failed check.")
    }
    return(list(lData = NULL, lCharts = NULL, lChecks = lChecks))
  } else {
    if (!bQuiet) {
      cli::cli_h2("Initializing {.fn AE_Assess}")
    }
    if (!bQuiet) {
      cli::cli_text("Input data has {nrow(dfInput)} rows.")
    }
    lData <- list()
    lData$dfTransformed <- gsm::Transform_Rate(
      dfInput = dfInput,
      strGroupCol = lMapping$dfInput$strGroupCol, strNumeratorCol = "Count",
      strDenominatorCol = "Exposure", bQuiet = bQuiet
    )
    if (!bQuiet) {
      cli::cli_alert_success("{.fn Transform_Rate} returned output with {nrow(lData$dfTransformed)} rows.")
    }
    if (strMethod == "NormalApprox") {
      lData$dfAnalyzed <- gsm::Analyze_NormalApprox(
        dfTransformed = lData$dfTransformed,
        strType = "rate", bQuiet = bQuiet
      )
      lData$dfBounds <- gsm::Analyze_NormalApprox_PredictBounds(
        dfTransformed = lData$dfTransformed,
        vThreshold = vThreshold, strType = "rate", bQuiet = bQuiet
      )
    } else if (strMethod == "Poisson") {
      lData$dfAnalyzed <- gsm::Analyze_Poisson(
        dfTransformed = lData$dfTransformed,
        bQuiet = bQuiet
      )
      lData$dfBounds <- gsm::Analyze_Poisson_PredictBounds(
        dfTransformed = lData$dfTransformed,
        vThreshold = vThreshold, bQuiet = bQuiet
      )
    } else if (strMethod == "Identity") {
      lData$dfAnalyzed <- gsm::Analyze_Identity(dfTransformed = lData$dfTransformed)
    }
    strAnalyzeFunction <- paste0("Analyze_", tools::toTitleCase(strMethod))
    if (!bQuiet) {
      cli::cli_alert_success("{.fn {strAnalyzeFunction}} returned output with {nrow(lData$dfAnalyzed)} rows.")
    }
    if (strMethod == "NormalApprox") {
      lData$dfFlagged <- gsm::Flag_NormalApprox(lData$dfAnalyzed,
        vThreshold = vThreshold
      )
    } else if (strMethod == "Poisson") {
      lData$dfFlagged <- gsm::Flag_Poisson(lData$dfAnalyzed,
        vThreshold = vThreshold
      )
    } else if (strMethod == "Identity") {
      lData$dfFlagged <- gsm::Flag(lData$dfAnalyzed,
        vThreshold = vThreshold,
        strValueColumn = strValueColumnVal
      )
    }
    flag_function_name <- switch(strMethod,
      NormalApprox = "Flag_NormalApprox",
      Identity = "Flag",
      Poisson = "Flag_Poisson"
    )
    if (!bQuiet) {
      cli::cli_alert_success("{.fn {flag_function_name}} returned output with {nrow(lData$dfFlagged)} rows.")
    }
    lData$dfSummary <- gsm::Summarize(lData$dfFlagged,
      nMinDenominator = nMinDenominator,
      bQuiet = bQuiet
    )
    if (!bQuiet) {
      cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")
    }
    lCharts <- list()
    if (!hasName(lData, "dfBounds")) {
      lData$dfBounds <- NULL
    }
    dfConfig <- MakeDfConfig(
      strMethod = strMethod, strGroup = strGroup,
      strAbbreviation = "AE", strMetric = "Adverse Event Rate",
      strNumerator = "Adverse Events", strDenominator = "Days on Study",
      vThreshold = vThreshold
    )
    if (strMethod != "Identity") {
      lCharts$scatter <- gsm::Visualize_Scatter(
        dfSummary = lData$dfSummary,
        dfBounds = lData$dfBounds, strGroupLabel = strGroup
      )
      lCharts$scatterJS <- gsm::Widget_ScatterPlot(
        results = lData$dfSummary,
        workflow = dfConfig, bounds = lData$dfBounds,
        elementId = "aeAssessScatter", siteSelectLabelValue = strGroup
      )
      if (!bQuiet) {
        cli::cli_alert_success("Created {length(lCharts)} scatter plot{?s}.")
      }
    }
    lCharts$barMetric <- gsm::Visualize_Score(
      dfSummary = lData$dfSummary,
      strType = "metric"
    )
    lCharts$barScore <- gsm::Visualize_Score(
      dfSummary = lData$dfSummary,
      strType = "score", vThreshold = vThreshold
    )
    lCharts$barMetricJS <- gsm::Widget_BarChart(
      results = lData$dfSummary,
      workflow = dfConfig, yaxis = "metric", elementId = "aeAssessMetric",
      siteSelectLabel = strGroup
    )
    lCharts$barScoreJS <- gsm::Widget_BarChart(
      results = lData$dfSummary,
      workflow = dfConfig, yaxis = "score", elementId = "aeAssessScore",
      siteSelectLabelValue = strGroup
    )
    if (!bQuiet) {
      cli::cli_alert_success("Created {length(names(lCharts)[!names(lCharts) %in% c('scatter', 'scatterJS')])} bar chart{?s}.")
    }
    return(list(lData = lData, lCharts = lCharts, lChecks = lChecks))
  }
}
