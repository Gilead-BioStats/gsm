#' Extract charts from `gsm v1.8.4` and move to top-level.
#'
#' @keywords internal
ExtractCharts <- function(lResults) {

  lCharts <- purrr::map(lResults, function(kri) {
    kri$lResults$lCharts
  })

  return(lCharts)

}
