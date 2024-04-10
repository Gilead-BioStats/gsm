#' @title Make_Input_Rate
#' @description Calculate a subject level rate from numerator and denominator data
#' 
#' @param dfs `list` of `data.frame`s including dfSUBJ, dfNumerator, and dfDenominator. Default: NULL
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#' @param lDomains `list` List of domains to use for mapping subj, domain and mapping dfata defaults. Default: NULL
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
#' lMapping = gsm::Read_Mapping("rawplus"),
#' lDomains = list(
#'  dfSubjects="dfSUBJ",
#'  dfNumerator="dfAE",
#'  dfDenominator="dfSUBJ"
#' ),
#' strNumeratorMethod = "Count",
#' strDenominatorMethod = "Sum",
#' strDenominatorCol = "strTimeOnStudyCol"
#' )
#' 
#' @export

Make_Input_Rate <- function(
    dfs = NULL,
    lMapping = NULL,
    lDomains = NULL,
    strNumeratorMethod = "Count",
    strDenominatorMethod = "Count",
    strNumeratorCol = NULL,
    strDenominatorCol = NULL,
    bQuiet = TRUE       
) {

#Get needed columns in dfSUBJ
subjMapping <- lMapping[[lDomains$dfSubjects]]
dfSUBJ_mapped <- dfs$dfSubjects %>%
      select(
        SubjectID = subjMapping[["strIDCol"]],
        any_of(
          c(
            SiteID = subjMapping[["strSiteCol"]],
            StudyID = subjMapping[["strStudyCol"]],
            CountryID = subjMapping[["strCountryCol"]],
            CustomGroupID = subjMapping[["strCustomGroupCol"]]
          )
        )
      )

#Calculate Numerator
numeratorMapping <- lMapping[[lDomains$dfNumerator]]
dfNumerator <- dfs$dfNumerator
dfNumerator$SubjectID <- dfNumerator[[numeratorMapping[["strIDCol"]]]]
if(strNumeratorMethod == "Count"){
    dfNumerator$numerator <- 1
} else {
    dfNumerator$numerator <- dfNumerator[[numeratorMapping[[strNumeratorCol]]]]
}

dfNumerator_subj <- dfNumerator %>%
    select(SubjectID, numerator) %>%
    group_by(SubjectID) %>%
    summarise(numerator= sum(numerator)) %>%
    ungroup()

#Calculate Denominator
denominatorMapping <- lMapping[[lDomains$dfDenominator]]
dfDenominator <- dfs$dfDenominator
dfDenominator$SubjectID <- dfDenominator[[denominatorMapping[["strIDCol"]]]]
if(strDenominatorMethod == "Count"){
    dfDenominator$denominator <- 1
} else {
    dfDenominator$denominator <- dfDenominator[[denominatorMapping[[strDenominatorCol]]]]
}


dfDenominator_subj <- dfDenominator %>%  
    select(SubjectID, denominator) %>%
    group_by(SubjectID) %>%
    summarise(denominator= sum(denominator)) %>%
    ungroup()

# Merge Numerator and Denominator with Subject Data. Keep all data in Subject. Fill in missing numerator/denominators with 0
dfInput <- dfSUBJ_mapped %>%
    left_join(dfNumerator_subj, by = "SubjectID") %>%
    left_join(dfDenominator_subj, by = "SubjectID") %>%
    mutate(numerator = if_else(is.na(numerator), 0, numerator),
           denominator = if_else(is.na(denominator), 0, denominator)
    ) %>%
    select(SubjectID, numerator, denominator) %>%
    mutate(rate = numerator/denominator)

return(dfInput)
}