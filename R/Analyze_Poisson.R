function (dfTransformed, bQuiet = TRUE) {
    stopifnot(`dfTransformed is not a data.frame` = is.data.frame(dfTransformed), 
        `One or more of these columns not found: GroupID, Denominator, Numerator, Metric` = all(c("GroupID", 
            "Denominator", "Numerator", "Metric") %in% names(dfTransformed)), 
        `NA value(s) found in GroupID` = all(!is.na(dfTransformed[["GroupID"]])))
    dfModel <- dfTransformed %>% mutate(LogDenominator = log(.data$Denominator))
    if (!bQuiet) {
        cli::cli_alert_info(glue::glue("Fitting log-linked Poisson generalized linear model of [ Numerator ] ~ [ log( Denominator ) ]."))
    }
    cModel <- stats::glm(Numerator ~ stats::offset(LogDenominator), 
        family = stats::poisson(link = "log"), data = dfModel)
    dfAnalyzed <- broom::augment(cModel, dfModel, type.predict = "response") %>% 
        select("GroupID", "Numerator", "Denominator", "Metric", 
            Score = ".resid", PredictedCount = ".fitted") %>% 
        arrange(.data$Score)
    return(dfAnalyzed)
}
