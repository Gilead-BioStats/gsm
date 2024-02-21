#' Covariate Map
#'
#' @return
#' @export
#'
#' @examples
Covariate_Map <- function(dfCovariate, strCovariteColName, strWorkflowId) {

  # do the mapping

  # return table with count and percentage of each covariate

  covariates[[strWorkflowId]] <- list(
    study = data.frame(),
    site = data.frame()
  )

  return(covariates)

}


