function (dfInput, strNumeratorCol, strDenominatorCol = NULL, 
    strGroupCol = "SiteID", bQuiet = TRUE) {
    stopifnot(`dfInput is not a data frame` = is.data.frame(dfInput), 
        `strNumeratorColumn is not numeric` = is.numeric(dfInput[[strNumeratorCol]]), 
        `strDenominatorColumn is not numeric` = is.numeric(dfInput[[strDenominatorCol]]), 
        `NA's found in numerator` = !anyNA(dfInput[[strNumeratorCol]]), 
        `NA's found in denominator` = !anyNA(dfInput[[strDenominatorCol]]), 
        `Required columns not found in input data` = c(strNumeratorCol, 
            strDenominatorCol, strGroupCol) %in% names(dfInput))
    dfTransformed <- dfInput %>% group_by(GroupID = .data[[strGroupCol]]) %>% 
        summarise(Numerator = sum(.data[[strNumeratorCol]]), 
            Denominator = sum(.data[[strDenominatorCol]])) %>% 
        mutate(Metric = .data$Numerator/.data$Denominator) %>% 
        select("GroupID", everything()) %>% filter(!is.nan(.data$Metric), 
        .data$Metric != Inf)
    if (nrow(dfTransformed) < length(unique(dfInput[[strGroupCol]]))) {
        if (!bQuiet) {
            cli::cli_alert_warning("{length(unique(dfInput[[ strGroupCol ]])) - nrow(dfTransformed)} values of [ {strGroupCol} ] with a [ {strDenominatorCol} ] value of 0 removed.")
        }
    }
    return(dfTransformed)
}
