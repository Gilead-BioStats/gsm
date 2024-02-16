#' Make Covariate Data
#'
#' @param lSnapshot `list` a snapshot object from `Make_Snapshot()`
#'
#' @return `list` containing covariate tables and charts for [gsm::Covariate_Report].
#'
#' @examples
#' \dontrun{
#' snapshot <- Make_Snapshot()
#' covariate <- Make_Covariate(snapshot)
#' }
#'
#' @export
Make_Covariate <- function(lSnapshot) {

  lCovariateTables <- Covariate_Map(lSnapshot = lSnapshot)
  lCovariateCharts <- Covariate_Charts(lInput = lCovariateTables)

  return(
    list(
      lCovariateTables = lCovariateTables,
      lCovariateCharts = lCovariateCharts
    )
  )

}
