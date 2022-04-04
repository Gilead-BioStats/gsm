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
#'
#' @examples
#'  NULL
#'
#' @importFrom yaml read_yaml
#' 
#' @return A list containing: dataChecks and results
#' 
#' @export

runAssessment <- function(assessment, lData, lMapping, lTags, bQuiet=FALSE){
    amessage <- function(x){
        if(!bQuiet) message(x)
    }    

    amessage(paste0("- Running ",assessment$name," assessment"))
        assessment$lRaw<-names(assessment$requiredParameters) %>% map(~lData[[.x]])
        names(assessment$lRaw) <- names(assessment$requiredParameters)
        # TODO check that required data domains are provided in lData

        # Apply filters from assessment$filter
        # TODO replace loops with purrr::map
        amessage("-- Checking for filters on domain data")
        for(domain in names(assessment$filters)){
            for(param in names(assessment$filters[[domain]])){        
                # TODO run is_mapping_valid to make sure filter cols are present
                col <- lMapping[[domain]][[param]]
                val <- assessment$filters[[domain]][[param]]
                amessage(paste0("--- Filtering ",domain," on ",col,"=",val))
                assessment$lRaw[[domain]] <- assessment$lRaw[[domain]] %>% filter(.data[[col]]==val)
            }
        }

        # run is_mapping_valid
        amessage("-- Checking whether raw data meets requirements")
        assessment$checks <- names(assessment$lRaw) %>% map(function(domain){
            df <- assessment$lRaw[[domain]]
            mapping <- lMapping[[domain]]
            requiredParams <- assessment$requiredParameters[[domain]]
            amessage(paste0("--- Checking ",domain," domain."))
            amessage("-----------------------------------------------")
            check <- is_mapping_valid(
                df=df,
                mapping=mapping,
                vRequiredParams = requiredParams,
                bQuiet=bQuiet,
                bKeepAllParams=FALSE
            ) 
            amessage("-----------------------------------------------")
            
            # TODO add support for checking vUniqueCols and vNACols
            if(check$status){
                amessage(paste0("--- ",domain, " meets requirements."))
            }else{
                amessage(paste0("--- ",domain, " does NOT meet requirements. See `[lAssessments]$",assessment$name,"$checks$",domain,"$tests_if` for details."))
            }
            return(check)
        })
        names(assessment$checks) <- names(assessment$lRaw)
        assessment$rawValid <- all(assessment$checks$status)
        
        # Return validation status and reasons for each assessment
        # if valid, run the mapping
        if(!assessment$rawValid){
            assessment$valid <- FALSE
            assessment$status <- "Invalid Raw Data"
            amessage("-- Raw data not valid for mapping. No Results will be generated.")
        }else{
            amessage("-- Mapping Raw Data to Assessment Input Standard.")
        }
        return(assessment)
}