function (dfAnalyzed, vThreshold = NULL) {
    stopifnot(`dfAnalyzed is not a data frame` = is.data.frame(dfAnalyzed), 
        `vThreshold is not numeric` = is.numeric(vThreshold), 
        `vThreshold must be length of 2` = length(vThreshold) == 
            2, `vThreshold cannot be NULL` = !is.null(vThreshold), 
        `GroupID not found in dfAnalyzed` = "GroupID" %in% names(dfAnalyzed))
    if (all(!is.na(vThreshold))) {
        stopifnot(`vThreshold must contain a minimum and maximum value (i.e., vThreshold = c(1, 2))` = vThreshold[2] > 
            vThreshold[1])
    }
    dfFlagged <- dfAnalyzed %>% mutate(Flag = case_when((.data$Score < 
        vThreshold[1]) & (.data$Prop < .data$Prop_Other) ~ -2, 
        (.data$Score < vThreshold[1]) & (.data$Prop >= .data$Prop_Other) ~ 
            2, (.data$Score < vThreshold[2]) & (.data$Prop < 
            .data$Prop_Other) ~ -1, (.data$Score < vThreshold[2]) & 
            (.data$Prop >= .data$Prop_Other) ~ 1, !is.na(.data$Score) & 
            !is.nan(.data$Score) ~ 0))
    dfFlagged <- dfFlagged %>% arrange(match(.data$Flag, c(2, 
        -2, 1, -1, 0)))
    return(dfFlagged)
}
