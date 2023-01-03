#' Title
#'
#' @param bUpdateData
#'
#' @return
#' @export
#'
#' @examples
UpdateTestData <- function(bUpdateData) {

  stopifnot("bUpdateData must be TRUE or FALSE" = is.logical(bUpdateData))

  Sys.setenv("gsm_update_tests" = bUpdateData)

}
