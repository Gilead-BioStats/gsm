#' Merge Domain data with subject-level data shell
#'
#' @param dfSubjects 
#' @param dfDomain 
#' @param strIDCol 
#' @param vFillZero Columns from dfDomain to fill with zeros when no matching row is found in for an ID in dfSubject
#' @param bQuiet print messages? 
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


mergeSubjects <- function(dfDomain, dfSubjects, strIDCol="SubjectID", vFillZero=NULL, bQuiet=TRUE){
    stopifnot(
        is.data.frame(dfSubjects),
        is.data.frame(dfDomain),
        is.character(strIDCol),
        is.logical(bQuiet),
        strIDCol %in% names(dfSubjects),
        strIDCol %in% names(dfDomain)
    )

    if(!is.null(vFillZero)){
        stopifnot(
            "Columns specified in vFillZero not found in dfDomain" = all(vFillZero %in% names(dfDomain)),
            is.character(vFillZero)
        )
    }

    # Check that ID is unique in both data sets
    subject_ids <- dfSubjects[[strIDCol]]
    domain_ids <- dfDomain[[strIDCol]]
    if(any(duplicated(subject_ids))) stop("Duplicate ID Values in Subject Data")
    if(any(duplicated(domain_ids))) stop("Duplicate ID Values in Domain Data")
    
    # Throw a warning if there are ID values in dfDomain that are not found in dfSubject
    domain_only_ids <- domain_ids[!domain_ids %in% subject_ids] 
    if(length(domain_only_ids > 0)){
        warning(
            paste0(
                length(domain_only_ids),
                " ID(s) in domain data not found in subject data: ",
                paste(domain_only_ids, collapse=" "),
                ". ",
                "Associated rows will not be included in merged data.\n"
            )
        )
    }

    # Print a message if rows in dfSubject are not found in dfDomain
    subject_only_ids <-  subject_ids[!subject_ids %in% domain_ids]
    if(length(subject_only_ids > 0)){
        if(!bQuiet){
            message(
                paste0(
                    length(subject_only_ids),
                    " ID(s) in subject data not found in domain data: ",
                    paste(subject_only_ids, collapse=" "),
                    ". ",
                    ifelse(is.null(vFillZero),
                        "These participants will have NA values imputed for all domain data columns:",
                        paste0(
                            "These participants will have 0s imputed for the following domain data columns: ",
                            paste(vFillZero, sep=", "), 
                            ". ",
                            "NA's will be imputed for all other columns."
                        )
                    )
                )
            )
        } 
    }

    dfOut <- left_join(dfSubjects, dfDomain, by=strIDCol)
    for(col in vFillZero){
        dfOut[[col]]<- tidyr::replace_na(dfOut[[col]], 0)
    }

    return(dfOut)
}