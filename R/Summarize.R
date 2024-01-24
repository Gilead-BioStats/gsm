function (dfFlagged, nMinDenominator = NULL, strScoreCol = "Score", 
    bQuiet = TRUE) {
    stopifnot(`dfFlagged is not a data frame` = is.data.frame(dfFlagged), 
        `One or more of these columns: GroupID, Flag , strScoreCol, not found in dfFlagged` = all(c("GroupID", 
            "Flag", strScoreCol) %in% names(dfFlagged)))
    if (!("Numerator" %in% colnames(dfFlagged))) {
        dfFlagged$Numerator <- NA
    }
    if (!("Denominator" %in% colnames(dfFlagged))) {
        dfFlagged$Denominator <- NA
    }
    dfSummary <- dfFlagged %>% select("GroupID", "Numerator", 
        "Denominator", "Metric", "Score", "Flag") %>% arrange(desc(abs(.data$Metric))) %>% 
        arrange(match(.data$Flag, c(2, -2, 1, -1, 0)))
    if (!is.null(nMinDenominator)) {
        dfSummary$Score[dfSummary$Denominator < nMinDenominator] <- NA
        dfSummary$Flag[dfSummary$Denominator < nMinDenominator] <- NA
        if (!bQuiet) {
            cli::cli_alert_info(paste0(sum(dfSummary$Denominator < 
                nMinDenominator), " Site(s) have insufficient sample size due to KRI denominator less than {nMinDenominator}. \nThese site(s) will not have KRI score and flag summarized."))
        }
    }
    return(dfSummary)
}
