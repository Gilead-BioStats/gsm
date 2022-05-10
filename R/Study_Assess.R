#' Run Multiple Assessments on a Study
#'
#' Attempts to run one or more assessments (`lAssessments`) using shared data (`lData`) and metadata (`lMapping`). By default, the sample `rawplus` data from the {clindata} package is used, and all assessments defined in `inst/assessments` are evaluated. Individual assessments are run using `gsm::RunAssessment()`
#'
#' @param lData a named list of domain level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lMapping a named list identifying the columns needed in each data domain.
#' @param lAssessments a named list of metadata defining how each assessment should be run. By default, `MakeAssessmentList()` imports YAML specifications from `inst/assessments`.
#' @param lTags a named list of Tags to be passed to each assessment. Default is `list(Study="myStudy")` could be expanded to include other important metadata such as analysis population or study phase.
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @examples
#' Study_Assess() # run using defaults
#'
#' @import dplyr
#' @importFrom purrr map
#' @importFrom yaml read_yaml
#'
#' @return A list of assessments containing status information and results.
#'
#' @export

Study_Assess <- function(
    lData=NULL,
    lMapping=NULL,
    lAssessments=NULL,
    lTags=list(Study="myStudy"),
    bQuiet=FALSE
){
    #### --- load defaults --- ###
    # lData from clindata
    if(is.null(lData)){
        lData <- list(
            dfSUBJ= clindata::rawplus_subj,
            dfAE=clindata::rawplus_ae,
            dfPD=clindata::rawplus_pd,
            dfCONSENT=clindata::rawplus_consent,
            dfIE=clindata::rawplus_ie
        )
    }

    # lMapping from clindata
    if(is.null(lMapping)){
        lMapping <- clindata::mapping_rawplus
    }

    # lAssessments from gsm inst/assessments
    if(is.null(lAssessments)){
        lAssessments <- MakeAssessmentList()
    }

    ### --- Attempt to run each assessment --- ###
    lAssessments <- lAssessments %>% map(
        ~gsm::RunAssessment(.x, lData=lData, lMapping=lMapping, lTags=lTags, bQuiet=bQuiet)
    )

    return(lAssessments)
}
