function (dfInput, nThreshold = 0.5, lMapping = yaml::read_yaml(system.file("mappings", 
    "Consent_Assess.yaml", package = "gsm")), strGroup = "Site", 
    nMinDenominator = NULL, bQuiet = TRUE) {
    stopifnot(`nThreshold must be numeric` = is.numeric(nThreshold), 
        `nThreshold must be length 1` = length(nThreshold) == 
            1, `strGroup must be one of: Site, Study, Country, or CustomGroup` = strGroup %in% 
            c("Site", "Study", "Country", "CustomGroup"), `bQuiet must be logical` = is.logical(bQuiet))
    lMapping$dfInput$strGroupCol <- lMapping$dfInput[[glue::glue("str{strGroup}Col")]]
    lChecks <- gsm::CheckInputs(context = "Consent_Assess", dfs = list(dfInput = dfInput), 
        mapping = lMapping, bQuiet = bQuiet)
    if (!lChecks$status) {
        if (!bQuiet) 
            cli::cli_alert_warning("{.fn Consent_Assess} did not run because of failed check.")
        return(list(lData = NULL, lCharts = NULL, lChecks = lChecks))
    }
    else {
        if (!bQuiet) 
            cli::cli_h2("Initializing {.fn Consent_Assess}")
        if (!bQuiet) 
            cli::cli_text("Input data has {nrow(dfInput)} rows.")
        lData <- list()
        lData$dfTransformed <- gsm::Transform_Count(dfInput = dfInput, 
            strGroupCol = lMapping$dfInput$strGroupCol, strCountCol = "Count")
        if (!bQuiet) 
            cli::cli_alert_success("{.fn Transform_Count} returned output with {nrow(lData$dfTransformed)} rows.")
        lData$dfAnalyzed <- gsm::Analyze_Identity(lData$dfTransformed, 
            bQuiet = bQuiet)
        if (!bQuiet) 
            cli::cli_alert_info("No analysis function used. {.var dfTransformed} copied directly to {.var dfAnalyzed}.")
        lData$dfFlagged <- gsm::Flag(lData$dfAnalyzed, vThreshold = c(NA, 
            nThreshold))
        if (!bQuiet) 
            cli::cli_alert_success("{.fn Flag} returned output with {nrow(lData$dfFlagged)} rows.")
        lData$dfSummary <- gsm::Summarize(lData$dfFlagged, nMinDenominator = nMinDenominator, 
            bQuiet = bQuiet)
        if (!bQuiet) 
            cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")
        lCharts <- list()
        dfConfig <- MakeDfConfig(strMethod = "Identity", strGroup = strGroup, 
            strAbbreviation = "CONSENT", strMetric = "Consent Issues", 
            strNumerator = "Consent Issues", strDenominator = "", 
            vThreshold = nThreshold)
        lCharts$barMetric <- gsm::Visualize_Score(dfSummary = lData$dfSummary, 
            strType = "metric")
        lCharts$barScore <- gsm::Visualize_Score(dfSummary = lData$dfSummary, 
            strType = "score", vThreshold = nThreshold)
        lCharts$barMetricJS <- gsm::Widget_BarChart(results = lData$dfSummary, 
            workflow = dfConfig, yaxis = "metric", elementId = "consentAssessMetric", 
            siteSelectLabelValue = strGroup)
        lCharts$barScoreJS <- gsm::Widget_BarChart(results = lData$dfSummary, 
            workflow = dfConfig, yaxis = "score", elementId = "consentAssessScore", 
            siteSelectLabelValue = strGroup)
        if (!bQuiet) 
            cli::cli_alert_success("Created {length(lCharts)} bar chart{?s}.")
        return(list(lData = lData, lCharts = lCharts, lChecks = lChecks))
    }
}
