function(
    dfAnalyzed, strColumn = "Score", vThreshold = NULL,
    strValueColumn = NULL) {
  stopifnot(
    `dfAnalyzed is not a data frame` = is.data.frame(dfAnalyzed),
    `strColumn is not character` = is.character(strColumn),
    `vThreshold is not numeric` = is.numeric(vThreshold),
    `vThreshold must be length of 2` = length(vThreshold) ==
      2, `vThreshold cannot be NULL` = !is.null(vThreshold),
    `strColumn must be length of 1` = length(strColumn) ==
      1, `strColumn not found in dfAnalyzed` = strColumn %in%
      names(dfAnalyzed), `strValueColumn not found in dfAnalyzed` = strValueColumn %in%
      names(dfAnalyzed), `GroupID not found in dfAnalyzed` = "GroupID" %in%
      names(dfAnalyzed)
  )
  if (all(!is.na(vThreshold))) {
    stopifnot(`vThreshold must contain a minimum and maximum value (i.e., vThreshold = c(1, 2))` = vThreshold[2] >
      vThreshold[1])
  }
  dfFlagged <- dfAnalyzed %>% mutate(Flag = case_when(!is.na(vThreshold[1]) &
    (.data[[strColumn]] < vThreshold[1]) ~ -1, !is.na(vThreshold[2]) &
    (.data[[strColumn]] > vThreshold[2]) ~ 1, !is.na(.data[[strColumn]]) &
    !is.nan(.data[[strColumn]]) ~ 0))
  if (!is.null(strValueColumn)) {
    nMedian <- dfFlagged %>%
      pull(strValueColumn) %>%
      stats::median(na.rm = TRUE)
    dfFlagged <- dfFlagged %>% mutate(Flag = case_when(Flag !=
      0 & .data[[strValueColumn]] >= nMedian ~ 1, Flag !=
      0 & .data[[strValueColumn]] < nMedian ~ -1, TRUE ~
      Flag))
  }
  dfFlagged <- dfFlagged %>% arrange(match(.data$Flag, c(
    1,
    -1, 0
  )))
  return(dfFlagged)
}
