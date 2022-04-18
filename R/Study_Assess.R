#' Run Multiple Assessments on a Study
#'
#' `Study_Assess()` attempts to run multiple assessments using a shared set of data (`lData`) and an associated data mapping (`lMapping`). By default, the `rawplus` data and associated mapping from the {clindata} package is used, and all assessments defined in `inst/assessments` are evaluated. Individual assessments are run using `gsm::RunAssessment()`
#'
#' @param lData a named list of domain level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lMapping a named list identifying the columns needed in each data domain.
#' @param lAssessments a named list of metadata defining how each assessment should be run. By default, `MakeAssessmentList()` imports YAML specifications from `inst/assessments`.
#' @param lSubjFilters Optionally specify Subject-level filters that will be applied to all assessments. For example `list(strRandFlagCol="Y")` could be used to subset to Randomized Participants.
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
    lSubjFilters=NULL,
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
        lMapping <- yaml::read_yaml(system.file("mapping/rawplus.yaml", package = 'clindata'))
    }

    # lAssessments from gsm inst/assessments
    if(is.null(lAssessments)){
        lAssessments <- MakeAssessmentList()
    }

    ### ---  Filter data$dfSUBJ based on lSubjFilters --- ###
    if(!is.null(lSubjFilters)){
        for(colMapping in names(lSubjFilters)){
            if(!hasName(lMapping$dfSUBJ, colMapping)){
                stop(paste0("`",colMapping, "` from lSubjFilters is not specified in lMapping$dfSUBJ"))
            }
            col <- lMapping$dfSUBJ[[colMapping]]
            vals <- lSubjFilters[[colMapping]]
            lData$dfSUBJ <- FilterDomain(df=lData$dfSUBJ, col=col, vals=vals, bQuiet=bQuiet)
        }
    }

    ### --- Attempt to run each assessment --- ###
    lAssessments <- lAssessments %>% map(
        ~RunAssessment(.x, lData=lData, lMapping=lMapping, lTags=lTags, bQuiet=bQuiet)
    )

    return(lAssessments)
}
