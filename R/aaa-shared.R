#' Parameters used in multiple functions
#'
#' @description
#' Reused parameter definitions are gathered here for easier usage. Edit the
#' definitions in `man/glossary/{term}.Rmd` (one file per term).
#'
#' ```{r include = FALSE}
#' param_from_yaml <- function(param) {
#'   param_def <- yaml::read_yaml(paste0("man/glossary/", param, ".yaml"))
#'   glue::glue("`{param_def$class}` {param_def$definition}")
#' }
#' ```
#'
#' @param dfMetrics `r param_from_yaml("dfMetrics")`
#' @param dfResults `r param_from_yaml("dfResults")`
#'
#' @name shared-params
#' @keywords internal
NULL
