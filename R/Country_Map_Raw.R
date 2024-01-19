#' Count Participants by Country
#'
#' `r lifecycle::badge("stable")`
#'
#' @param dfSite `data.frame` Data frame returned by [gsm::Site_Map_Raw()].
#'
#' @return `data.frame` Data frame with one record per country.
#'
#' @export

Country_Map_Raw <- function(
  dfSite = Site_Map_Raw()
) {
  dfSite %>%
    dplyr::group_by(.data$country) %>%
    dplyr::summarize(
      enrolled_participants = sum(
        .data$enrolled_participants,
        na.rm = TRUE
      )
    )
}
