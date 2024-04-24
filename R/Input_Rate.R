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
#' - dfSubjects: A data frame with columns for SubjectID, SiteID, StudyID, and CountryID
#' - dfNumerator: A data frame with a column for SubjectID and `strNumeratorCol` if `strNumeratorMethod` is "Sum"
#' - dfDenominator: A data frame with a column for SubjectID and `strDenominatorCol` if `strDenominatorMethod` is "Sum"
#' 
#' All other columns are dropped from the output data frame. Note that if no values for a subject are 
#' found in dfNumerator/dfDenominator numerator and denominator values are filled with 0 in the output data frame.
#' 
#' @param dfs `list` of `data.frame`s including dfSUBJ, dfNumerator, and dfDenominator. Default: NULL
#' @param strNumeratorMethod `character` Method to calculate numerator. Default: "Count"
#' @param strDenominatorMethod `character` Method to calculate denominator. Default: "Count"
#' @param strNumeratorCol `character` Column name in `dfNumerator` to use for numerator calculation. Default: NULL
#' @param strDenominatorCol `character` Column name in `dfDenominator` to use for denominator calculation. Default: NULL
#' 
#' @return `data.frame` with the following columns:
#' 
#' - SubjectID: The subject ID
#' - SiteID: The site ID
#' - StudyID: The study ID
#' - CountryID: The country ID
#' - Numerator: The calculated numerator value
#' - Denominator: The calculated denominator value
#' - Rate: The calculated input rate
#' 
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

Input_Rate <- function(
    dfs = NULL,
    strNumeratorMethod = "Count",
    strDenominatorMethod = "Count",
    strNumeratorCol = NULL,
    strDenominatorCol = NULL
) {

#Check if dfs is NULL
if(is.null(dfs)){
    stop("dfs, must be provided")
}

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

# if dfs are not named, name them
if (is.null(names(dfs))) {
    names(dfs) <- c("dfSubjects", "dfNumerator", "dfDenominator")
}

# Check if dfs contains dfSubjects, dfNumerator, and dfDenominator
if (!all(c("dfSubjects", "dfNumerator", "dfDenominator") %in% names(dfs))) {
    stop("dfs must contain dfSubjects, dfNumerator, and dfDenominator")
}

# Check that dfSUBJ contains columsn for SubjectID, SiteID, StudyID, and CountryID
if (!all(c("SubjectID", "SiteID", "StudyID", "CountryID") %in% colnames(dfs$dfSubjects))) {
    stop("dfSubjects must contain columns for SubjectID, SiteID, StudyID, and CountryID")
}

# check that "SubjectID" is in all dfs
if (!all(c("SubjectID") %in% colnames(dfs$dfNumerator)) | !all(c("SubjectID") %in% colnames(dfs$dfDenominator))) {
    stop("dfNumerator and dfDenominator must contain a column for SubjectID")
}

#Get needed columns in dfSUBJ
dfSubjects <- dfs$dfSubjects %>% select(SubjectID, SiteID, StudyID, CountryID)
        
#Calculate Numerator
dfNumerator <- dfs$dfNumerator

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
dfDenominator <- dfs$dfDenominator
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