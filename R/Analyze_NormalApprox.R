function (dfTransformed, strType = "binary", bQuiet = TRUE) {
    stopifnot(`dfTransformed is not a data.frame` = is.data.frame(dfTransformed), 
        `One or more of these columns not found: GroupID, Denominator, Numerator, Metric` = all(c("GroupID", 
            "Denominator", "Numerator", "Metric") %in% names(dfTransformed)), 
        `NA value(s) found in GroupID` = all(!is.na(dfTransformed[["GroupID"]])), 
        `strType is not 'binary' or 'rate'` = strType %in% c("binary", 
            "rate"))
    if (strType == "binary") {
        dfScore <- dfTransformed %>% mutate(vMu = sum(.data$Numerator)/sum(.data$Denominator), 
            z_0 = ifelse(.data$vMu == 0 | .data$vMu == 1, 0, 
                (.data$Metric - .data$vMu)/sqrt(.data$vMu * (1 - 
                  .data$vMu)/.data$Denominator)), phi = mean(.data$z_0^2), 
            z_i = ifelse(.data$vMu == 0 | .data$vMu == 1 | .data$phi == 
                0, 0, (.data$Metric - .data$vMu)/sqrt(.data$phi * 
                .data$vMu * (1 - .data$vMu)/.data$Denominator)))
    }
    else if (strType == "rate") {
        dfScore <- dfTransformed %>% mutate(vMu = sum(.data$Numerator)/sum(.data$Denominator), 
            z_0 = ifelse(.data$vMu == 0, 0, (.data$Metric - .data$vMu)/sqrt(.data$vMu/.data$Denominator)), 
            phi = mean(.data$z_0^2), z_i = ifelse(.data$vMu == 
                0 | .data$phi == 0, 0, (.data$Metric - .data$vMu)/sqrt(.data$phi * 
                .data$vMu/.data$Denominator)))
    }
    dfAnalyzed <- dfScore %>% select("GroupID", "Numerator", 
        "Denominator", "Metric", OverallMetric = "vMu", Factor = "phi", 
        Score = "z_i") %>% arrange(.data$Score)
    if (!bQuiet) {
        cli::cli_text("{.var OverallMetric}, {.var Factor}, and {.var Score} columns created from normal approximation.")
    }
    return(dfAnalyzed)
}
