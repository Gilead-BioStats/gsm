#' Run multiple assessments on a single study
#'
#' @details
#'
#' Coming soon
#' 
#' @param lData list of data 
#' @param lMapping mapping
#' @param lAssessments assessments
#' @param strPopFlags filter demog data? 
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

Study_Assess <- function(
    lData=NULL, 
    lMapping=NULL, 
    lAssessments=NULL, 
    lPopFlags=list(strRandFlagCol="Y"), 
    strStudyID="myStudy",
    bReturnInputs=FALSE,
    bQuiet=FALSE
){
    #### --- load defaults --- ###
    # lData from clindata
    if(is.null(lData)){
        lData <- list(
            subj= clindata::rawplus_rdsl,
            ae=clindata::rawplus_ae,
            pd=clindata::rawplus_pd,
            consent=clindata::rawplus_consent,
            ie=clindata::rawplus_ie
        )
    }

    # lMapping from clindata
    if(is.null(lMapping)){
        lMapping <- yaml::read_yaml(system.file("mapping/rawplus.yaml", package = 'clindata'))
    }

    # lAssessments from inst/library
    if(is.null(lAssessments)){
        lAssessments <- MakeAssessmentList()
    }
    
    ### ---  Filter data$subj based on strPopFlags --- ### 
    if(!is.null(lPopFlags)){
        for(flag in names(lPopFlags)){
            # TODO run is_mapping_valid to make sure filter cols are present
            col <- lMapping$subj[[flag]]
            val <- lPopFlags[[flag]]
            oldRows <- nrow(lData$subj)
            lData$subj <- lData$subj %>% filter(.data[[col]]==val)
            newRows<-nrow(lData$subj)
            if(!bQuiet){
                message(paste0(
                    "- Filtered subject data on `",
                    col,
                    "=",
                    val,
                    "`, to drop ",
                    oldRows-newRows, 
                    " rows from ",
                    oldRows,
                    " to ",
                    newRows,
                    " rows.")
                )
            }
        }
    }

    ### --- Attempt to run each assessment --- ### 
    lAssessments <- lAssessments %>% map(function(assessment){
        message(paste0("- Running ",assessment$name," assessment"))
        assessment$lRaw<-names(assessment$requiredParameters) %>% map(~lData[[.x]])
        names(assessment$lRaw) <- names(assessment$requiredParameters)
        
        # Apply filters from assessment$filter
        # TODO replace loops with purrr::map
        message("-- Checking for filters on domain data")
        for(domain in names(assessment$filters)){
            for(param in names(assessment$filters[[domain]])){        
                # TODO run is_mapping_valid to make sure filter cols are present
                col <- lMapping[[domain]][[param]]
                val <- assessment$filters[[domain]][[param]]
                message(paste0("--- Filtering ",domain," on ",col,"=",val))
                assessment$lRaw[[domain]] <- assessment$lRaw[[domain]] %>% filter(.data[[col]]==val)
            }
        }

        # run is_mapping_valid
        message("-- Checking whether raw data meets requirements")
        assessment$checks <- names(assessment$lRaw) %>% map(function(domain){
            df <- assessment$lRaw[[domain]]
            mapping <- lMapping[[domain]]
            requiredParams <- assessment$requiredParameters[[domain]]
            print(requiredParams)
            message(paste0("--- Checking ",domain," domain."))
            message("-----------------------------------------------")
            check <- is_mapping_valid(
                df=df,
                mapping=mapping,
                vRequiredParams = requiredParams,
                bQuiet=bQuiet,
                bKeepAllParams=FALSE
            ) 
            message("-----------------------------------------------")
            # TODO add support for checking vUniqueCols and vNACols
            if(check$status){
                message(paste0("--- ",domain, " meets requirements."))
            }else{
                message(paste0("--- ",domain, " does NOT meet requirements. See `[lAssessments]$",assessment$name,"$checks$",domain,"$tests_if` for details."))
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
            message("-- Raw data not valid for mapping. No Results will be generated.")
        }else{
            message("-- Mapping Raw Data to Assessment Input Standard.")
        }
        return(assessment)
    })

    if(bReturnInputs){
        return(
            list(
                lAssessments = lAssessments,
                lData = lData,
                lMapping= lMapping
            )
        )
    }else{
        return(lAssessments)
    }
    
}
