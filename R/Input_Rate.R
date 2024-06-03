#' @title Input_Rate
#'
#' @description Calculate a subject level rate from numerator and denominator data
#'
#' This function takes in a list of data frames including dfSUBJ, dfNumerator, and dfDenominator,
#' and calculates a subject level rate based on the specified numerator and denominator methods (either
#' "Count" or "Sum"). If the method is "Count", the function simply counts the number of rows in the
#' provided data frame. If the numerator method is "Sum", the function takes the sum of the values in
#' the specified column (strNumeratorCol or strDenominatorCol). The function returns a data frame with
#' the calculated input rate for each subject.
#'
#' The data requirements for the function are as follows:
#'
#' - dfSubjects: A data frame with columns for SubjectID and any other relevant subject information
#' - dfNumerator: A data frame with a column for SubjectID and `strNumeratorCol` if `strNumeratorMethod` is "Sum"
#' - dfDenominator: A data frame with a column for SubjectID and `strDenominatorCol` if `strDenominatorMethod` is "Sum"
#'
#' All other columns are dropped from the output data frame. Note that if no values for a subject are
#' found in dfNumerator/dfDenominator numerator and denominator values are filled with 0 in the output data frame.
#'

#' @param dfSubjects `data.frame` with columns for SubjectID and any other relevant subject information
#' @param dfNumerator `data.frame` with a column for SubjectID and `strNumeratorCol` if `strNumeratorMethod` is "Sum"
#' @param dfDenominator `data.frame` with a column for SubjectID and `strDenominatorCol` if `strDenominatorMethod` is "Sum"
#' @param strGroupCol `character` Column name in `dfSubjects` to use for grouping. Default: "SiteID"
#' @param strSubjectCol `character` Column name in `dfSubjects` to use for subject ID. Default: "SubjectID"
#' @param strNumeratorMethod `character` Method to calculate numerator. Default: "Count"
#' @param strDenominatorMethod `character` Method to calculate denominator. Default: "Count"
#' @param strNumeratorCol `character` Column name in `dfNumerator` to use for numerator calculation. Default: NULL
#' @param strDenominatorCol `character` Column name in `dfDenominator` to use for denominator calculation. Default: NULL
#'
#' @return `data.frame` with the following specification:
#'
#' | Column Name  | Description                          | Type     |
#' |--------------|--------------------------------------|----------|
#' | SubjectID    | The subject ID                       | Character|
#' | GroupID      | The group ID                         | Character|
#' | GroupLevel    | The group type                       | Character|
#' | Numerator    | The calculated numerator value       | Numeric  |
#' | Denominator  | The calculated denominator value     | Numeric  |
#' | Rate         | The calculated input rate            | Numeric  |
#'
#' @examples
#' # Run for AE KRI
#' dfInput <- Input_Rate(
#'  dfs = list(
#'   dfSubjects = clindata::rawplus_dm,
#'   dfNumerator = clindata::rawplus_ae,
#'   dfDenominator = clindata::rawplus_dm
#' ),
#' strNumeratorMethod = "Count",
#' strDenominatorMethod = "Sum",
#' strDenominatorCol = "timeontreatment"
#' )
#'
#' @export
#' @keywords interal

Input_Rate <- function(
    dfSubjects,
    dfNumerator,
    dfDenominator,
    strGroupCol = "GroupID",
    strSubjectCol = "SubjectID",
    strNumeratorMethod = "Count",
    strDenominatorMethod = "Count",
    strNumeratorCol = NULL,
    strDenominatorCol = NULL
) {

    #Check if data frames are NULL
    if(is.null(dfSubjects)){ stop("dfSubjects must be provided")}
    if(is.null(dfDenominator)){ stop("dfDenominator, must be provided")}
    if(is.null(dfNumerator)){ stop("dfNumerator, must be provided")}

    # Check if strNumeratorMethod and strDenominatorMethod are valid
    if (!strNumeratorMethod %in% c("Count", "Sum") | !strDenominatorMethod %in% c("Count", "Sum")) {
        stop("strNumeratorMethod and strDenominator method must be 'Count' or 'Sum'")
    }

    # Check if strNumeratorCol is Null when strNumeratorMethod is 'Sum'
    if (strNumeratorMethod == "Sum" & is.null(strNumeratorCol)) {
        stop("strNumeratorCol must be provided when strNumeratorMethod is 'Sum'")
    }

    # Check if strDenominatorCol is Null when strDenominatorMethod is 'Sum'
    if (strDenominatorMethod == "Sum" & is.null(strDenominatorCol)) {
        stop("strDenominatorCol must be provided when strDenominatorMethod is 'Sum'")
    }

    # check that "strSubjectCol" is in all dfs
    stopifnot(
        strSubjectCol %in% colnames(dfSubjects),
        strSubjectCol %in% colnames(dfNumerator),
        strSubjectCol %in% colnames(dfDenominator)
    )

    #Rename SubjectID in dfSubjects
    dfSubjects <- dfSubjects %>%
        mutate(
            SubjectID = .data[[strSubjectCol]],
            GroupID = .data[[strGroupCol]],
            GroupLevel = strGroupCol
        ) %>%
        select(SubjectID, GroupID, GroupLevel)

    #Calculate Numerator
    dfNumerator <- dfNumerator %>%
        rename('SubjectID' = !!strSubjectCol)

    if(strNumeratorMethod == "Count"){
        dfNumerator$Numerator <- 1
    } else {
        dfNumerator$Numerator <- dfNumerator[[strNumeratorCol]]
    }

    dfNumerator_subj <- dfNumerator %>%
        select(SubjectID, Numerator) %>%
        group_by(SubjectID) %>%
        summarise(Numerator= sum(Numerator)) %>%
        ungroup()

    #Calculate Denominator
    dfDenominator <- dfDenominator %>%
        rename('SubjectID' = !!strSubjectCol)

    if(strDenominatorMethod == "Count"){
        dfDenominator$Denominator <- 1
    } else {
        dfDenominator$Denominator <- dfDenominator[[strDenominatorCol]]
    }

    dfDenominator_subj <- dfDenominator %>%
        select(SubjectID, Denominator) %>%
        group_by(SubjectID) %>%
        summarise(Denominator= sum(Denominator)) %>%
        ungroup()

    # Merge Numerator and Denominator with Subject Data. Keep all data in Subject. Fill in missing numerator/denominators with 0
    dfInput <- dfSubjects %>%
        left_join(dfNumerator_subj, by = "SubjectID") %>%
        left_join(dfDenominator_subj, by = "SubjectID") %>%
        mutate(Numerator = if_else(is.na(Numerator), 0, Numerator),
            Denominator = if_else(is.na(Denominator), 0, Denominator)
        ) %>%
        mutate(Rate = Numerator/Denominator)

    return(dfInput)
}
