#' @title Make_Input_Rate
#' @description Calculate a subject level rate from numerator and denominator data
#' 
#' @param dfs `list` of `data.frame`s including dfSUBJ, dfNumerator, and dfDenominator. Default: NULL
#' @param strIDCol `character` Column name in to use for subject ID - should be included in all `dfs`. Default: NULL
#' @param strNumeratorMethod `character` Method to calculate numerator. Default: "Count"
#' @param strDenominatorMethod `character` Method to calculate denominator. Default: "Count"
#' @param strNumeratorCol `character` Column name in `dfNumerator` to use for numerator calculation. Default: NULL
#' @param strDenominatorCol `character` Column name in `dfDenominator` to use for denominator calculation. Default: NULL
#' 
#' @return `data.frame` with calculated input rate
#' 
#' @examples
#' # Run for AE KRI
#' dfInput <- Make_Input_Rate(
#'  dfs = list(
#'   dfSubjects = clindata::rawplus_dm,
#'   dfNumerator = clindata::rawplus_ae,
#'   dfDenominator = clindata::rawplus_dm
#' ),
#' strIDCol = "subjid",
#' strNumeratorMethod = "Count",
#' strDenominatorMethod = "Sum",
#' strDenominatorCol = "timeontreatment"
#' )
#' 
#' @export

Make_Input_Rate <- function(
    dfs = NULL,
    strNumeratorMethod = "Count",
    strDenominatorMethod = "Count",
    strNumeratorCol = NULL,
    strDenominatorCol = NULL,
    bQuiet = TRUE       
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
print(head(dfInput))
return(dfInput)
}