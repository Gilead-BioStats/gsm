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

    amessage <- function(x){
        if(!bQuiet) message(x)
    }

    assessment$valid <- TRUE
    amessage(paste0("- ##### ",assessment$name," assessment ##### -"))
    assessment$data <- lData


    # Run through each step in assessment$workflow
    for(stepname in names(assessment$workflow)){

        # Create a mapping for each data domain used in the workflow
        step <- assessment$workflow[[stepname]]

        fullMapping <- names(step$data) %>% map(function(domain){

            # assign column names each mapping specified in workflow$domain
            if(is.character(step$data[[domain]])){
                params<-step$data[[domain]]
            }else{
                params<-names(step$data[[domain]])
            }

            mapping <- params %>% map(function(param){

                # if user provides a value, use it
                if(hasName(step$data[[domain]], param)){
                    return(step$data[[domain]][[param]])

                }else{

                    if(hasName(lMapping[[domain]], param)){

                        return(lMapping[[domain]][[param]])

                    }else{

                        return(NA)
                    }
                }
            }) %>%
            set_names(params)

            return(mapping)
        }) %>%
        set_names(names(step$data))

        assessment$workflow[[stepname]]$mapping <- fullMapping


        # check that required data/columns are available
        for(domain in names(assessment$workflow[[stepname]]$data)){
            df <- assessment$data[[domain]]
            mapping <- assessment$workflow[[stepname]]$mapping[[domain]]
            assessment$workflow[[stepname]]$checks[[domain]] <- is_mapping_valid(df=df,mapping=mapping)
        }
        assessment$workflow[[stepname]]$status <- all(assessment$workflow[[stepname]]$checks %>% map_lgl(~.x$status))

        #if (assessment$workflow[[stepname]]$status){}

        # execute the workflow function with requested parameters
        domains <- names(assessment$workflow[[stepname]]$data)
        dataParams <- domains %>% map(~assessment$data[[.x]]) %>% set_names(domains)
        params <- c(dataParams, assessment$workflow[[stepname]]$params)
        if(tolower(assessment$workflow[[stepname]]$type) =="filter"){
            df <- assessment$data[[domains[[1]]]]
            col <- mapping[[params$col]]
            val <- mapping[[params$val]]
            params <- list(df=df, col=col, val=val )
            assessment$data[[assessment$workflow[[stepname]]$outputName]] <- do.call(stepname, params)
        }else if(tolower(assessment$workflow[[stepname]]$type) =="mapping"){
            #params <- list(...)
            assessment$data$dfInput <- do.call(stepname, params)
        }else if(tolower(assessment$workflow[[stepname]]$type) =="assess"){
            assessment$data$results <- do.call(stepname, params)
        }
    }

    return(assessment)
}


