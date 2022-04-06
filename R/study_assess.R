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
            dfSUBJ= clindata::rawplus_rdsl,
            dfAE=clindata::rawplus_ae,
            dfPD=clindata::rawplus_pd,
            dfCONSENT=clindata::rawplus_consent,
            dfIE=clindata::rawplus_ie
        )
    }

    # lMapping from clindata
    if(is.null(lMapping)){
        lMapping <- yaml::read_yaml(system.file("mapping/rawplus.yaml", package = 'clindata'))
    }

    # lAssessments from inst/library
    if(is.null(lAssessments)){
        lAssessments <- makeAssessmentList()
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
    lAssessments <- lAssessments %>% map(
        ~runAssessment(.x, lData=lData, lMapping=lMapping, lTags=lTags, bQuiet=bQuiet)
    )

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
