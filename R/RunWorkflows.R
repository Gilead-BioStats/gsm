#' Convienience function to easily run multiple workflows
#'
#' This function takes a list of workflows and a list of data as input. If there
#' are multiple workflows in the list, it runs each workflow and returns the
#' results as a named list. If there is only one workflow, it runs that workflow
#' and returns the result.
#'
#' @param lWorkflow `list` A named list of metadata defining how the workflow should be run.
#' @param lData `list` A named list of domain-level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param bKeepInputData `boolean` should the input data be returned? Default is `FALSE`.
#' @param bReturnData `boolean` should function return only bData or should meta and steps be included? Default is `TRUE`.
#' 
#' @return A named list of results, where the names correspond to the names of
#' the workflows

RunWorkflows <- function(
    lWorkflows,
    lData, 
    bReturnData = TRUE, 
    bKeepInputData = FALSE
){
    if(length(lWorkflows) > 1) {
        # if there are multiple workflows, run them all
        cli::cli_h1("Running {length(lWorkflows)} Workflows")
        lResults <- purrr::map(
            lWorkflows, 
            ~RunWorkflow(.x, lData, bReturnData, bKeepInputData)
        ) %>% setNames(names(lWorkflows))
    } else {
        # if there is only one workflow, run it
        print(names(lWorkflows[[1]]))
        lResults <- RunWorkflow(lWorkflow=lWorkflows[[1]], lData, bReturnData, bKeepInputData)
    }
    return(lResults)
}
