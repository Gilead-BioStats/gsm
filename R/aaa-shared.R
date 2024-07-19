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
#'
#' @name shared-params
#' @keywords internal
NULL
