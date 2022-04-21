#' Run a single assessment
#'
#' @details
#'
#' Coming soon
#'
#' @param assessment assessment
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
    assessment$checks <- list()
    assessment$lSteps <- list()
    assessment$bStatus <- TRUE
    
    # Run through each step in assessment$workflow
    
    stepCount<-1
    for(step in assessment$workflow){
        if(!bQuiet) cli::cli_h2(paste0("Workflow Step ", stepCount, " of " ,length(assessment$workflow), ": `", step$name,"`"))
        if(bStatus){
            cli::cli_text("Calling {.fn {step$name}} ...")
            result <- RunStep(
                step=step, 
                mapping=lMapping, 
                lData=lData, 
                lTags=c(lTags, assessment$tags), 
                bQuiet=bQuiet
            )

            assessment$checks[step$name]<- result$checks
            assessment$bStatus <- results$checks$status
            if(step$status){
                cli::cli_alert_success("{.fn {step$name}} Successful")
            } else{
                cli::cli_alert_warning("{.fn {step$name}} Failed - Skipping remaining steps")
            }

            if(str_detect(step$output,"^df")){
                cli::cli_text("Saving {step$output} to `assessment$lData`")
                assessment$lData[[output]]<-result$df
            }else{
                cli{"Saving {step$output} to `assessment`"}
                assessment[[output]] <- result
            }
            
        }else{
            cli::cli_text("Skipping {.fn {step$name}} ...")
        }

        stepCount <- stepCount+1
    }
    
    return(assessment)
}


