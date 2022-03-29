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
#' @return A list containing: dataChecks and results
#' 
#' @export

study_assess <- function(lData=NULL, lMapping=NULL, lAssessments=NULL, strPopFlags='strRandFlagCol', studyID="myStudy"){
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
        mapping_yaml <- readLines(system.file("mapping/rawplus.yaml", package = 'clindata'))
        mapping <- yaml::read_yaml(mapping_yaml)
    }

    # lAssessments from inst/library
    if(is.null(lAssessments)){
        lAssessments <- makeAssessmentList(system.file("assessments", package = 'gsm'))
    }

    ### ---  Filter data$subj based on strPopFlags --- ### 
    if(!is.null(strPopFlags)){
        for(flag in strPopFlags){
            # TODO run is_mapping_valid to make sure filter cols are present
            lData$demog <- lData$demog %>% filter(.data[[ mapping$demog[[flag]] ]]==TRUE)
        }
    }

    ### --- Attempt to run each assessment --- ### 
    for(assessment in lAssessments){
        # Apply filters from assessment$filter
        # run is_mapping_valid
        # Return validation status and reasons for each assessment
        # if valid, run the assessment and return results
    }

    return(lAssessments)
}