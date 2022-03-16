#' Merge Domain data with subject-level data shell
#'
#' @param dfRDSL 
#' @param dfDomain 
#' @param strIDCol 
#' @param bFillZero Columns from dfDomain to fill with zeros when no matching row is found in for an ID in dfSubject
#'
#' @return data set with one record per IDCol
#'
#' @examples
#' NULL
#' 
#' @importFrom dplyr left_join
#' @importFrom tidyr replace_na
#' 
#' @export
#' 

mergeSubjects <- function(dfSubjects, dfDomain, strIDCol="SubjectID", vFillZero=NULL, bQuiet=FALSE){
    stopifnot(
        is.data.frame(dfSubjects),
        is.data.frame(dfDomain),
        is.character(strIDCol),
        is.logical(bQuiet),
        strIDCol %in% dfSubjects,
        strIDCol %in% dfDomain
    )

    if(!is.null(bFillZero)){
        stopifnot(
            "Columns specified in bFillZero not found in dfDomain" = all(vFillZero %in% names(dfDomain)),
            is.character(vFillZero)
        )
    }

    # Check that ID is unique in both data sets
    subject_ids <- dfSubjects[[strIDCol]]
    domain_ids <- dfDomain[[strIDCol]]
    if(any(duplicated(subject_ids))) stop("Duplicate ID Values in Subject Data")
    if(any(duplicated(domain_ids))) stop("Duplicate ID Values in Domain Data")
    
    # Throw a warning if there are ID values in dfDomain that are not found in dfRDSL
    domain_only_ids <- domain_ids %>% map(~is.element(.x, subject_ids)) 
    if(length(domain_only_ids > 0)){
        if(!bQuiet){
            warning(
                paste0(
                    "IDs in domain data not found in subject data:",
                    paste(domain_only_ids, collapse=", ")
                )
            )
        } 
    }

    # Print a message if rows in dfSubject are not found in dfDomain
    subject_only_ids <- subject_ids %>% map(~is.element(.x, domain_ids)) 
    if(length(subject_only_ids > 0)){
        if(!bQuiet){
            message(
                paste0(
                    "IDs in subject data not found in domain data:",
                    paste(subject_only_ids, collapse=", ")
                )
            )

            if(!is.null(vFillZero)){ 
                message(
                    paste0(
                        "These participants will have 0s imputed for the following columns:",
                        paste(vFillZero, sep=", ")
                    )
                )
            }
        } 
    }


    dfOut <- left_join(dfRDSL, dfDomain, by=strIDCol)
    for(col in vFillZero){
        dfOut <- na_replace(dfOut, col, 0)
    }

    return(dfOut)
}