#' Run a single step in an assessment
#'
#' @details
#'
#' Coming soon
#'
#' @param assessment assessments
#' @param lData list of data
#' @param lMapping mapping
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

RunStep <- function(step, mapping, lTags, bQuiet){

    # Pull list of data domains from spec
    step$domains <- names(step$spec)
    
    # check that required data/columns are available for each domain
    step$mapping <- step$domains %>% map(function(domain){
        if(!is.null(step$mapping[[domain]])){
            return(step$mapping[[domain]])
        } else {
            return(mapping[[domain]])
        }
    }) %>% purrr::set_names(step$domains)

    step$checks <- step$domains %>% map(function(domain){
        if(!bQuiet) cli::cli_h3(paste0("Checking ",domain," data vs. spec."))
        check <- is_mapping_valid(
            df=step$lData[[domain]],
            mapping=step$mapping[[domain]],
            vRequiredParams = step$spec[[domain]]$requiredParams,
            vUniqueCols = step$spec[[domain]]$uniqueParams,
            vNACols= step$spec[[domain]]$NAParams,
            bQuiet=bQuiet
        )
        
        
        if(check$status) {
            if(!bQuiet) cli::cli_alert_success('{domain} is valid.')
        } else {
            if(!bQuiet) cli::cli_alert_danger('{domain} is NOT valid. ')
        }

        return(check)
    })

    step$status <- all(step$checks %>% map_lgl(~.x$status))
    if(step$status) {
        if(!bQuiet) cli::cli_alert_success('All domains valid.')
    } else {
        if(!bQuiet) cli::cli_alert_danger('NOT all domains is valid. ')
    }

    if(step$status){
        if(!bQuiet) cli::cli_h3('Calling {step$name} function.')
        # execute the workflow function with requested parameters
        dataParams <- step$domains %>% map(~step$lData[[.x]]) %>% set_names(step$domains)
        params <- c(dataParams, step$params)
        if(tolower(step$type) =="filter"){
            domain <- step$outputDomain
            col <- step$mapping[[domain]][[params$col]]
            val <- step$mapping[[domain]][[params$val]]
            params <- list(df=step$lData[[domain]], col=col, val=val, bQuiet = bQuiet)
            step$outData[[domain]] <- do.call(step$name, params)
        }else if(tolower(step$type) =="mapping"){
            params$bQuiet <- bQuiet
            step$outData[[step$outputDomain]] <- do.call(step$name, params)
        }else if(tolower(step$type) =="assess"){
            params$lTags <- lTags
            print(params)
            step$lResults <- do.call(step$name, params)
        }
    }

    return(step)
}