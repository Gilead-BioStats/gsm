function(assessment, strType) {
  any_dropped <- map(assessment, function(names) {
    "bActive" %in% names(names)
  }) %>%
    unlist(.data) %>%
    any()
  if (any_dropped) {
    active <- assessment[map_df(assessment, function(status) {
      status[["bActive"]] == TRUE
    }) %>%
      pivot_longer(everything()) %>%
      filter(.data$value) %>%
      pull(.data$name)]
    dropped <- assessment[map_df(assessment, function(status) {
      status[["bActive"]] == FALSE
    }) %>%
      pivot_longer(everything()) %>%
      filter(.data$value) %>%
      pull(.data$name)]
    output <- list(
      active = active[grep(strType, names(active))],
      dropped = dropped[grep(strType, names(dropped))]
    )
  } else {
    output <- assessment[grep(strType, names(assessment))]
  }
  return(output)
}
