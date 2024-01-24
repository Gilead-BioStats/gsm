function (dfTransformed, vThreshold = c(-3, -2, 2, 3), strType = "binary", 
    nStep = NULL, bQuiet = TRUE) {
    if (is.null(vThreshold)) {
        vThreshold <- c(-3, -2, 2, 3)
        if (bQuiet == FALSE) {
            cli::cli_alert("vThreshold was not provided. Setting default threshold to {vThreshold}")
        }
    }
    if (is.null(nStep)) {
        nRange <- max(dfTransformed$Denominator) - min(dfTransformed$Denominator)
        if (!is.null(nRange) & !is.na(nRange) & nRange != 0) {
            nStep <- nRange/250
        }
        else {
            nStep <- 1
        }
        if (bQuiet == FALSE) {
            cli::cli_alert("nStep was not provided. Setting default step to {nStep}")
        }
    }
    vThreshold <- unique(c(vThreshold, 0))
    vRange <- seq(min(dfTransformed$Denominator) - nStep, max(dfTransformed$Denominator) + 
        nStep, by = nStep)
    if (strType == "binary") {
        dfBounds <- tidyr::expand_grid(Threshold = vThreshold, 
            Denominator = vRange) %>% filter(.data$Denominator > 
            0) %>% mutate(LogDenominator = log(.data$Denominator), 
            vMu = sum(dfTransformed$Numerator)/sum(dfTransformed$Denominator), 
            phi = mean(((dfTransformed$Metric - sum(dfTransformed$Numerator)/sum(dfTransformed$Denominator))/sqrt(sum(dfTransformed$Numerator)/sum(dfTransformed$Denominator) * 
                (1 - sum(dfTransformed$Numerator)/sum(dfTransformed$Denominator))/dfTransformed$Denominator))^2), 
            Metric = .data$vMu + .data$Threshold * sqrt(.data$phi * 
                .data$vMu * (1 - .data$vMu)/.data$Denominator), 
            Numerator = .data$Metric * .data$Denominator) %>% 
            filter(.data$Numerator >= 0) %>% select("Threshold", 
            "Denominator", "LogDenominator", "Numerator", "Metric")
    }
    else if (strType == "rate") {
        dfBounds <- tidyr::expand_grid(Threshold = vThreshold, 
            Denominator = vRange) %>% filter(.data$Denominator > 
            0) %>% mutate(LogDenominator = log(.data$Denominator), 
            vMu = sum(dfTransformed$Numerator)/sum(dfTransformed$Denominator), 
            phi = mean(((dfTransformed$Metric - sum(dfTransformed$Numerator)/sum(dfTransformed$Denominator))/sqrt(sum(dfTransformed$Numerator)/sum(dfTransformed$Denominator)/dfTransformed$Denominator))^2), 
            Metric = .data$vMu + .data$Threshold * sqrt(.data$phi * 
                .data$vMu/.data$Denominator), Numerator = .data$Metric * 
                .data$Denominator) %>% filter(.data$Numerator >= 
            0) %>% select("Threshold", "Denominator", "LogDenominator", 
            "Numerator", "Metric")
    }
    return(dfBounds)
}
