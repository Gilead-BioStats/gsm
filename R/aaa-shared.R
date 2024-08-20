gloss_param <- function(param) {
  param_def <- yaml::read_yaml(paste0("man/glossary/", param, ".yaml"))
  glue::glue("`{param_def$class}` {param_def$definition}")
}
gloss_extra <- function(x) {
  readLines(glue::glue("man/glossary/{x}.Rmd"))
}

#' Parameters used in multiple functions
#'
#' @description
#' Reused parameter definitions are gathered here for easier usage. Edit the
#' definitions in `man/glossary/{term}.Rmd` (one file per term).
#'
#' @param dfMetrics `r gloss_param("dfMetrics")`
#' @param dfResults `r gloss_param("dfResults")`
#' @param dfBounds `r gloss_param("dfBounds")`
#' @param dfGroups `r gloss_param("dfGroups")`
#' @param dfInput `r gloss_param("dfInput")`
#' @param lMetric `r gloss_param("lMetric")`
#' @param lParamLabels `r gloss_param("lParamLabels")`
#' @param bDebug `r gloss_param("bDebug")`
#'
#'
#' @name shared-params
#' @keywords internal
NULL
