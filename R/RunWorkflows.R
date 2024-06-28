#' Convienience function to easily run multiple workflows
#'
#' This function takes a list of workflows and a list of data as input. If there
#' are multiple workflows in the list, it runs each workflow and returns the
#' results as a named list. If there is only one workflow, it runs that workflow
#' and returns the result.
#'
#' @param lWorkflows A list of workflows to be run
#' @param lData A list of data to be used in the workflows
#'
#' @return A named list of results, where the names correspond to the names of
#' the workflows

RunWorkflows <- function(lWorkflows, lData){
    if(length(lWorkflows) > 1) {
        # if there are multiple workflows, run them all
        cli::cli_h1("Running {length(lWorkflows)} Workflows")
        lResults <- purrr::map(
            lWorkflows, 
            ~RunWorkflow(., lData)
        ) %>% setNames(names(lWorkflows))
    } else {
        # if there is only one workflow, run it
        print(names(lWorkflows[[1]]))
        lResults <- RunWorkflow(lWorkflow=lWorkflows[[1]], lData=lData)
    }
    return(lResults)
}

