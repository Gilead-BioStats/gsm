function (dfTransformed, strOutcome = "Numerator", bQuiet = TRUE) {
    stopifnot(`dfTransformed is not a data.frame` = is.data.frame(dfTransformed), 
        `GroupID or the value in strOutcome not found in dfTransformed` = all(c("GroupID", 
            strOutcome) %in% names(dfTransformed)), `NA value(s) found in GroupID` = all(!is.na(dfTransformed[["GroupID"]])), 
        `strOutcome must be length 1` = length(strOutcome) == 
            1, `strOutcome is not character` = is.character(strOutcome))
    fisher_model <- function(site) {
        SiteTable <- dfTransformed %>% group_by(.data$GroupID == 
            site) %>% summarize(Participants = sum(.data$Denominator), 
            Flag = sum(.data$Numerator), NoFlag = sum(.data$Participants - 
                .data$Flag)) %>% select("NoFlag", "Flag")
        stats::fisher.test(SiteTable)
    }
    dfAnalyzed <- dfTransformed %>% mutate(model = purrr::map(.data$GroupID, 
        fisher_model)) %>% mutate(summary = purrr::map(.data$model, 
        broom::glance)) %>% tidyr::unnest(summary) %>% mutate(Estimate = .data$estimate, 
        Score = .data$p.value, Numerator_All = sum(.data$Numerator), 
        Denominator_All = sum(.data$Denominator), Numerator_Other = .data$Numerator_All - 
            .data$Numerator, Denominator_Other = .data$Denominator_All - 
            .data$Denominator, Prop = .data$Numerator/.data$Denominator, 
        Prop_Other = .data$Numerator_Other/.data$Denominator_Other) %>% 
        arrange(.data$Score) %>% select("GroupID", "Numerator", 
        "Numerator_Other", "Denominator", "Denominator_Other", 
        "Prop", "Prop_Other", "Metric", "Estimate", "Score")
    return(dfAnalyzed)
}
