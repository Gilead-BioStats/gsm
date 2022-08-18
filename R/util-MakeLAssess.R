#' Make lAssess within an Assess function.
#'
#' @description
#' Utility function to standardize the output for lAssess within an Assess function. This function captures all parameters and
#' returns the values supplied when running the Assess function.
#'
#' @return
#' A list containing key/value pairs for parameters and their respective arguments
#'
#' @importFrom rlang fn_fmls
#' @importFrom purrr map
MakeLAssess <- function() {

  browser()
  # get parent environment's function name
  strFunctionName <- deparse(sys.call(which = sys.nframe() - 1)[1])

  # create function object for use in rlang::fn_fmls
  subsetStrFunctionName <- match.fun(gsub('.{2}$', '', strFunctionName))

  # get all parameter names
  paramNames <- names(rlang::fn_fmls(fn = subsetStrFunctionName))

  # get all parameter arguments
  # rename list containing parameter names
  allArguments <- purrr::map(paramNames, ~dynGet(.)) %>%
    purrr::set_names(names(formals(subsetStrFunctionName)))

  # remove dfInput and lTags since they're added as separate values in lAssess and are
  # easily accessible in the parent environment
  allArguments$dfInput <- NULL
  allArguments$lTags <- NULL

  return(
    list(
      strFunctionName = strFunctionName,
      lParams = allArguments,
      lTags = parent.frame()$lTags,
      dfInput = parent.frame()$dfInput
    )
  )
}
