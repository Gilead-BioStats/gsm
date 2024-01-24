function(dfAnalyzed, vThreshold = NULL) {
  stopifnot(
    `dfAnalyzed is not a data frame` = is.data.frame(dfAnalyzed),
    `Required columns not found` = all(c("Estimate", "LowCI") %in%
      names(dfAnalyzed)), `vThreshold is not numeric` = is.numeric(vThreshold),
    `vThreshold must be length of 1` = length(vThreshold) ==
      1, `vThreshold cannot be NULL` = !is.null(vThreshold)
  )
  dfFlagged <- dfAnalyzed %>% mutate(Flag = case_when((.data$LowCI >
    vThreshold) ~ 2, (.data$Estimate > vThreshold) ~ 1, (.data$Estimate <=
    vThreshold) ~ 0))
  dfFlagged <- dfFlagged %>% arrange(match(.data$Flag, c(
    2,
    1, 0
  )))
  return(dfFlagged)
}
