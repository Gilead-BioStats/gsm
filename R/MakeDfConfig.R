function (strMethod, strGroup, strAbbreviation, strMetric, strNumerator, 
    strDenominator, vThreshold) {
    modelLabel <- switch(strMethod, NormalApprox = "Normal Approximation", 
        Poisson = "Poisson", Fisher = "Fisher", Identity = "Identity")
    scoreLabel <- switch(strMethod, NormalApprox = "Adjusted Z-Score", 
        Poisson = "Residual", Identity = "Count", Fisher = "P-value")
    dfConfig <- dplyr::tibble(workflowid = "temp", group = strGroup, 
        abbreviation = strAbbreviation, metric = strMetric, numerator = strNumerator, 
        denominator = strDenominator, model = modelLabel, score = scoreLabel) %>% 
        mutate(thresholds = list(vThreshold))
    return(dfConfig)
}
