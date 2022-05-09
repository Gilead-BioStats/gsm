#' Run a single step in an assessment
#'
#' Calls a step in an assessment workflow. Currently supports `*_Map_*`, `*_Assess` and `*_FilterDomain`
#'
#' @param lStep single workflow step (typically defined in `lAssessment$workflow`). Should include the name of the function to run (`lStep$name`), data inputs (`lStep$inputs`), name of output (`lStep$output`) and configurable parameters (`lStep$params`) (if any)
#' @param lMapping List containing expected columns in each data set.
#' @param lData a named list of domain level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lTags tags
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @importFrom yaml read_yaml
#' @importFrom stringr str_detect
#'
#' @return A list containing the results of the `lStep$name` function call should contain `.$checks` parameter with results from `is_mapping_vald` for each domain in `lStep$inputs`.
#'
#' @export

RunStep <- function(lStep, lMapping, lData, lTags, bQuiet) {
  # prepare parameter list inputs
  cli::cli_text("Preparing parameters for  {.fn {lStep$name}} ...")
  params <- c(lStep$params, list(bQuiet = bQuiet, bReturnChecks = TRUE))

  # prepare data inputs by function type
  if (str_detect(lStep$name, "_Map")) {
    params$lMapping <- lMapping
    params$dfs <- lData[lStep$inputs]
  } else if (str_detect(lStep$name, "_Assess")) {
    print(names(lData))
    params$dfInput <- lData[[lStep$inputs]]
    params$lTags <- lTags
  } else if (lStep$name == "FilterDomain") {
    params$lMapping <- lMapping
    params$df <- lData[[lStep$inputs]]
  }

  # Call the workflow function and return results
  cli::cli_text("Calling {.fn {lStep$name}} ...")
  return(do.call(lStep$name, params))
}
