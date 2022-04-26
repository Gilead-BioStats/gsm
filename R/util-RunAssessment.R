#' Run a single assessment
#'
#' Atempts to run a single assessments (`lAssessment`) using shared data (`lData`) and metadata (`lMapping`). Calls `RunStep` for each item in `lAssessment$Workflow` and saves the results to `lAssessment`
#'
#' @param lData a named list of domain level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lMapping a named list identifying the columns needed in each data domain.
#' @param lAssessment a named list of metadata defining how each assessment should be run. Properties should include: `label`, `tags` and `workflow`
#' @param lTags tags
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @importFrom yaml read_yaml
#' @import cli
#' @import stringr
#'
#' @return Returns `lAssessment` with `lData`, `lResults`, `bStatus` and `lChecks` added based on the results of the execution of `assessment$workflow`.
#'
#' @export

RunAssessment <- function(lAssessment, lData, lMapping, lTags=NULL, bQuiet=FALSE){
    if(!bQuiet) cli::cli_h1(paste0("Initializing `",lAssessment$name,"` assessment"))


    lAssessment$lData <- lData
    lAssessment$lChecks <- list()
    lAssessment$bStatus <- TRUE

    # Run through each step in lAssessment$workflow
    stepCount<-1
    for(step in lAssessment$workflow){
        if(!bQuiet) cli::cli_h2(paste0("Workflow Step ", stepCount, " of " ,length(lAssessment$workflow), ": `", step$name,"`"))
      if(!all(step$inputs %in% names(lAssessment$lData))){
        lAssessment$bStatus <- FALSE
      }
        if(lAssessment$bStatus){
            result <- RunStep(
                lStep=step,
                lMapping=lMapping,
                lData=lAssessment$lData,
                lTags=c(lTags, lAssessment$tags),
                bQuiet=bQuiet
            )

            lAssessment$checks[[step$name]] <- result$lChecks
            lAssessment$bStatus <- result$lChecks$status
            if(result$lChecks$status){
                cli::cli_alert_success("{.fn {step$name}} Successful")
            } else {
                cli::cli_alert_warning("{.fn {step$name}} Failed - Skipping remaining steps")
            }

            if(str_detect(step$output,"^df")){
                cli::cli_text("Saving {step$output} to `lAssessment$lData`")
                lAssessment$lData[[step$output]]<-result$df
            }else{
                cli::cli_text("Saving {step$output} to `lAssessment`")
                lAssessment[[step$output]] <- result
            }

        } else{
            cli::cli_text("Skipping {.fn {step$name}} ...")
        }

        stepCount <- stepCount+1
    }

    return(lAssessment)
}


