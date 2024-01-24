function (dfInput, vThreshold = NULL, strMethod = "NormalApprox", 
    lMapping = yaml::read_yaml(system.file("mappings", "Disp_Assess.yaml", 
        package = "gsm")), strGroup = "Site", nMinDenominator = NULL, 
    nConfLevel = NULL, bQuiet = TRUE) {
    stopifnot(`strMethod is not 'NormalApprox', 'Fisher', 'Identity', or 'QTL'` = strMethod %in% 
        c("NormalApprox", "Fisher", "Identity", "QTL"), `strMethod must be length 1` = length(strMethod) == 
        1, `strGroup must be one of: Site, Study, Country, or CustomGroup` = strGroup %in% 
        c("Site", "Study", "Country", "CustomGroup"), `bQuiet must be logical` = is.logical(bQuiet))
    lMapping$dfInput$strGroupCol <- lMapping$dfInput[[glue::glue("str{strGroup}Col")]]
    lChecks <- CheckInputs(context = "Disp_Assess", dfs = list(dfInput = dfInput), 
        mapping = lMapping, bQuiet = bQuiet)
    if (is.null(vThreshold)) {
        vThreshold <- switch(strMethod, NormalApprox = c(-3, 
            -2, 2, 3), Fisher = c(0.01, 0.05), Identity = c(3.491, 
            5.172), QTL = c(0.2))
    }
    strValueColumnVal <- switch(strMethod, NormalApprox = NULL, 
        Fisher = "Score", Identity = "Score")
    if (!lChecks$status) {
        if (!bQuiet) 
            cli::cli_alert_warning("{.fn Disp_Assess} did not run because of failed check.")
        return(list(lData = NULL, lCharts = NULL, lChecks = lChecks))
    }
    else {
        if (!bQuiet) 
            cli::cli_h2("Initializing {.fn Disp_Assess}")
        if (!bQuiet) 
            cli::cli_text("Input data has {nrow(dfInput)} rows.")
        lData <- list()
        lData$dfTransformed <- gsm::Transform_Rate(dfInput = dfInput, 
            strGroupCol = lMapping$dfInput$strGroupCol, strNumeratorCol = "Count", 
            strDenominatorCol = "Total", bQuiet = bQuiet)
        if (!bQuiet) 
            cli::cli_alert_success("{.fn Transform_Rate} returned output with {nrow(lData$dfTransformed)} rows.")
        if (strMethod == "NormalApprox") {
            lData$dfAnalyzed <- gsm::Analyze_NormalApprox(dfTransformed = lData$dfTransformed, 
                strType = "binary", bQuiet = bQuiet)
            lData$dfBounds <- gsm::Analyze_NormalApprox_PredictBounds(dfTransformed = lData$dfTransformed, 
                vThreshold = vThreshold, strType = "binary", 
                bQuiet = bQuiet)
        }
        else if (strMethod == "Fisher") {
            lData$dfAnalyzed <- gsm::Analyze_Fisher(lData$dfTransformed, 
                bQuiet = bQuiet)
        }
        else if (strMethod == "Identity") {
            lData$dfAnalyzed <- gsm::Analyze_Identity(lData$dfTransformed)
        }
        else if (strMethod == "QTL") {
            lData$dfAnalyzed <- gsm::Analyze_QTL(lData$dfTransformed, 
                strOutcome = "binary", nConfLevel = nConfLevel)
        }
        strAnalyzeFunction <- paste0("Analyze_", tools::toTitleCase(strMethod))
        if (!bQuiet) 
            cli::cli_alert_success("{.fn {strAnalyzeFunction}} returned output with {nrow(lData$dfAnalyzed)} rows.")
        if (strMethod == "NormalApprox") {
            lData$dfFlagged <- gsm::Flag_NormalApprox(lData$dfAnalyzed, 
                vThreshold = vThreshold)
        }
        else if (strMethod == "Fisher") {
            lData$dfFlagged <- gsm::Flag_Fisher(lData$dfAnalyzed, 
                vThreshold = vThreshold)
        }
        else if (strMethod == "Identity") {
            lData$dfFlagged <- gsm::Flag(lData$dfAnalyzed, vThreshold = vThreshold, 
                strValueColumn = strValueColumnVal)
        }
        else if (strMethod == "QTL") {
            lData$dfFlagged <- gsm::Flag_QTL(lData$dfAnalyzed, 
                vThreshold = vThreshold)
        }
        flag_function_name <- switch(strMethod, NormalApprox = "Flag_NormalApprox", 
            Identity = "Flag", Fisher = "Flag_Fisher", QTL = "Flag_QTL")
        if (!bQuiet) 
            cli::cli_alert_success("{.fn {flag_function_name}} returned output with {nrow(lData$dfFlagged)} rows.")
        lData$dfSummary <- gsm::Summarize(lData$dfFlagged, nMinDenominator = nMinDenominator, 
            bQuiet = bQuiet)
        if (!bQuiet) 
            cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")
        lCharts <- list()
        if (strMethod != "QTL") {
            if (!hasName(lData, "dfBounds")) 
                lData$dfBounds <- NULL
            dfConfig <- MakeDfConfig(strMethod = strMethod, strGroup = strGroup, 
                strAbbreviation = "DSC", strMetric = "Discontinuation Rate", 
                strNumerator = "Subjects Discontinued", strDenominator = "Total Subjects", 
                vThreshold = vThreshold)
            if (strMethod != "Identity") {
                lCharts$scatter <- gsm::Visualize_Scatter(dfSummary = lData$dfSummary, 
                  dfBounds = lData$dfBounds, strGroupLabel = strGroup)
                if (exists("dfBounds", lData)) {
                  bounds <- lData$dfBounds
                }
                else {
                  bounds <- NULL
                }
                lCharts$scatterJS <- gsm::Widget_ScatterPlot(results = lData$dfSummary, 
                  workflow = dfConfig, bounds = bounds, elementId = "dispAssessScatter", 
                  siteSelectLabelValue = strGroup)
                if (!bQuiet) 
                  cli::cli_alert_success("Created {length(lCharts)} scatter plot{?s}.")
            }
            lCharts$barMetric <- gsm::Visualize_Score(dfSummary = lData$dfSummary, 
                strType = "metric")
            lCharts$barScore <- gsm::Visualize_Score(dfSummary = lData$dfSummary, 
                strType = "score", vThreshold = vThreshold)
            lCharts$barMetricJS <- gsm::Widget_BarChart(results = lData$dfSummary, 
                workflow = dfConfig, yaxis = "metric", elementId = "dispAssessMetric", 
                siteSelectLabelValue = strGroup)
            lCharts$barScoreJS <- gsm::Widget_BarChart(results = lData$dfSummary, 
                workflow = dfConfig, yaxis = "score", elementId = "dispAssessScore", 
                siteSelectLabelValue = strGroup)
            if (!bQuiet) 
                cli::cli_alert_success("Created {length(names(lCharts)[!names(lCharts) %in% c('scatter', 'scatterJS')])} bar chart{?s}.")
        }
        return(list(lData = lData, lCharts = lCharts, lChecks = lChecks))
    }
}
