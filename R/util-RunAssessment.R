#' Run a single assessment
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

RunAssessment <- function(assessment, lData, lMapping, lTags=NULL, bQuiet=FALSE){
    if(!bQuiet) cli::cli_h1(paste0("Initializing `",assessment$name,"` assessment"))
    
    assessment$lData <- lData
    assessment$lResults <- list()
    assessment$lSteps <- list()
    assessment$bStatus <- TRUE

    # Run through each step in assessment$workflow
    
    stepCount<-1
    for(step in assessment$workflow){
        if(!bQuiet) cli::cli_h2(paste0("Workflow step ", stepCount, " of " ,length(assessment$workflow), ": `", step$name,"`"))
        step$lData <- assessment$lData
        step <- RunStep(step=step, mapping=lMapping, lTags=c(lTags, assessment$tags), bQuiet=bQuiet)

        #Update Assessment Data and results based on current step
        for(domain in names(step$outData)){
            assessment$lData[[domain]] <- step$outData[[domain]]
        } 

        if(step$type=="assess"){
            assessment$lResults <- step$lResults
        }
        
        assessment$lSteps[[step$name]] <- step
        stepCount <- stepCount+1
    }
    
    m <- paste0(assessment$name," assessment status is ", assessment$valid)

    # if(assessment$valid) {
    #     cli::cli_alert_success(m)
    # } else {
    #     cli::cli_alert_danger(m)
    # }

    return(assessment)
}


