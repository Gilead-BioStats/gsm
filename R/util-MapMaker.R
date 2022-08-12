#' Read YAML mapping in Assess functions without params
#'
#' @param strFunctionName `character` Default function name derived within an Assess function.
#'
#' @return YAML mapping
#'
#' @importFrom yaml read_yaml
#'
#' @export

MapMaker <- function(strFunctionName = NULL) {
  yaml::read_yaml(
    system.file("mappings",
      paste0(substring(strFunctionName, 1, nchar(strFunctionName) - 2), ".yaml"),
      package = "gsm"
    )
  )
}
