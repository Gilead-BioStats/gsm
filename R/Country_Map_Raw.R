function(dfSite = Site_Map_Raw()) {
  dfSite %>%
    dplyr::group_by(.data$country) %>%
    dplyr::summarize(enrolled_participants = sum(.data$enrolled_participants,
      na.rm = TRUE
    ))
}
