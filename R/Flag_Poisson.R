function(dfAnalyzed, vThreshold = NULL) {
  stopifnot(
    `dfAnalyzed is not a data frame` = is.data.frame(dfAnalyzed),
    `vThreshold is not numeric` = is.numeric(vThreshold),
    `vThreshold must be length of 4` = length(vThreshold) ==
      4, `vThreshold cannot be NULL` = !is.null(vThreshold)
  )
  if (all(!is.na(vThreshold))) {
    stopifnot(`vThreshold must contain cutoff for moderate/high risks in two directions (i.e., vThreshold = c(-7, -5, 5, 7))` = vThreshold[1] <
      vThreshold[2], `vThreshold must contain cutoff for moderate/high risks in two directions (i.e., vThreshold = c(-7, -5, 5, 7))` = vThreshold[2] <
      vThreshold[3], `vThreshold must contain cutoff for moderate/high risks in two directions (i.e., vThreshold = c(-7, -5, 5, 7))` = vThreshold[3] <
      vThreshold[4])
  }
  dfFlagged <- dfAnalyzed %>% mutate(Flag = case_when((.data$Score <
    vThreshold[1]) ~ -2, (.data$Score < vThreshold[2]) ~
    -1, (.data$Score < vThreshold[3]) ~ 0, (.data$Score <
    vThreshold[4]) ~ 1, (.data$Score >= vThreshold[4]) ~
    2))
  dfFlagged <- dfFlagged %>% arrange(match(.data$Flag, c(
    2,
    -2, 1, -1, 0
  )))
  return(dfFlagged)
}
