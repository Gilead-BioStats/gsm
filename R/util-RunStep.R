#' Run a single step in an assessment
#'
#' @details
#'
#' Wrapper function to call a step in an assessment workflow. Currently support *_Map_*, *_Assess and *_FilterDomain
#'
#' @param step list of data
#' @param mapping mapping
#' @param lData
#' @param lTags tags
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @examples
#'  NULL
#'
#' @importFrom yaml read_yaml
#'
#' @return A list containing: dataChecks and results
#'
#' @export

RunStep <- function(step, mapping, lData, lTags, bQuiet){
    dataParams <- step$inputs %>% map(~lData[[.x]]) %>% set_names(step$inputs)
    params <- c(dataParams, step$paramslMapping=mapping, bQuiet=bQuiet, lTags=lTags, bCheckInputs=TRUE)
    step$result <- do.call(step$name, params)
    return(step)
}
