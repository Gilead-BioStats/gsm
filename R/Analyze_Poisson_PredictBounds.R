function (dfTransformed, vThreshold = c(-5, 5), nStep = NULL, 
    bQuiet = TRUE) {
    if (is.null(vThreshold)) {
        vThreshold <- c(-5, 5)
        if (bQuiet == FALSE) {
            cli::cli_alert("vThreshold was not provided. Setting default threshold to c(-5, 5)")
        }
    }
    vThreshold <- unique(c(vThreshold, 0))
    dfTransformed$LogDenominator <- log(dfTransformed$Denominator)
    if (is.null(nStep)) {
        nMinLogDenominator <- min(dfTransformed$LogDenominator)
        nMaxLogDenominator <- max(dfTransformed$LogDenominator)
        nRange <- nMaxLogDenominator - nMinLogDenominator
        if (!is.null(nRange) & !is.na(nRange) & nRange != 0) {
            nStep <- nRange/250
        }
        else {
            nStep <- 0.05
        }
        if (bQuiet == FALSE) {
            cli::cli_alert("nStep was not provided. Setting default step to {nStep}")
        }
    }
    cModel <- glm(Numerator ~ stats::offset(LogDenominator), 
        family = poisson(link = "log"), data = dfTransformed)
    vRange <- seq(min(dfTransformed$LogDenominator) - nStep, 
        max(dfTransformed$LogDenominator) + nStep, by = nStep)
    dfBounds <- tidyr::expand_grid(Threshold = vThreshold, LogDenominator = vRange) %>% 
        mutate(vMu = as.numeric(exp(.data$LogDenominator * cModel$coefficients[2] + 
            cModel$coefficients[1])), vEst = .data$Threshold^2 - 
            2 * .data$vMu, vWEst = .data$vEst/(2 * exp(1) * .data$vMu), 
            PredictYPositive = .data$vEst/(2 * lamW::lambertW0(.data$vWEst)), 
            PredictYNegative = .data$vEst/(2 * lamW::lambertWm1(.data$vWEst)), 
            Numerator = case_when(.data$Threshold < 0 ~ PredictYNegative, 
                .data$Threshold > 0 ~ PredictYPositive, .data$Threshold == 
                  0 ~ vMu), Denominator = exp(.data$LogDenominator)) %>% 
        filter(!is.nan(.data$Numerator)) %>% select("Threshold", 
        "LogDenominator", "Denominator", "Numerator")
    return(dfBounds)
}
