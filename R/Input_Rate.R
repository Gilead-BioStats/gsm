#' Input_Rate
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Calculate a subject level rate from numerator and denominator data
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
#' @param strGroupCol `character` Column name in `dfSubjects` to use for grouping. Default: "GroupID"
#' @param strGroupLevel `character` value for the group level. Default: NULL which is parsed to `strGroupCol`
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
#' | GroupLevel   | The group type                       | Character|
#' | Numerator    | The calculated numerator value       | Numeric  |
#' | Denominator  | The calculated denominator value     | Numeric  |
#' | Metric       | The calculated input rate/metric     | Numeric  |
#'
#' @examples
#' # Run for AE KRI
#' dfInput <- Input_Rate(
#'   dfSubjects = clindata::rawplus_dm,
#'   dfNumerator = clindata::rawplus_ae,
#'   dfDenominator = clindata::rawplus_dm,
#'   strSubjectCol = "subjid",
#'   strGroupCol = "siteid",
#'   strGroupLevel = "Site",
#'   strNumeratorMethod = "Count",
#'   strDenominatorMethod = "Sum",
#'   strDenominatorCol = "timeontreatment"
#' )
#'
#' @export
#' @keywords internal

Input_Rate <- function(
  dfSubjects,
  dfNumerator,
  dfDenominator,
  strGroupCol = "GroupID",
  strGroupLevel = NULL,
  strSubjectCol = "SubjectID",
  strNumeratorMethod = c("Count", "Sum"),
  strDenominatorMethod = c("Count", "Sum"),
  strNumeratorCol = NULL,
  strDenominatorCol = NULL
) {
  # Check if data frames are NULL
  if (is.null(dfSubjects)) {
    LogMessage(level = "error", message = "dfSubjects must be provided")
  }
  if (is.null(dfDenominator)) {
    LogMessage(level = "error", message = "dfDenominator, must be provided")
  }
  if (is.null(dfNumerator)) {
    LogMessage(level = "error", message = "dfNumerator, must be provided")
  }

  # must be eit
  strNumeratorMethod <- match.arg(strNumeratorMethod)
  strDenominatorMethod <- match.arg(strDenominatorMethod)

  # Check if strNumeratorCol is Null when strNumeratorMethod is 'Sum'
  if (strNumeratorMethod == "Sum") {
    if (is.null(strNumeratorCol)) {
      LogMessage(level = "error", message = "strNumeratorCol must be provided when strNumeratorMethod is 'Sum'")
    }
    if (!is.numeric(dfNumerator[[strNumeratorCol]])) {
      LogMessage(level = "error", message = "strNumeratorCol must be numeric when strNumeratorMethod is `Sum`")
    }
  }

  # Check if strDenominatorCol is Null when strDenominatorMethod is 'Sum'
  if (strDenominatorMethod == "Sum") {
    if (is.null(strDenominatorCol)) {
      LogMessage(level = "error", message = "strDenominatorCol must be provided when strDenominatorMethod is 'Sum'")
    }
    if (!is.numeric(dfDenominator[[strDenominatorCol]])) {
      LogMessage(level = "error", message = "strDenominatorCol must be numeric when strDenominatorMethod is `Sum`")
    }
  }

  # check that "strSubjectCol" is in all dfs
  stopifnot(
    strSubjectCol %in% colnames(dfSubjects),
    strSubjectCol %in% colnames(dfNumerator),
    strSubjectCol %in% colnames(dfDenominator)
  )

  # check that "strGroupCol" is in dfSubjects
  stopifnot(strGroupCol %in% colnames(dfSubjects))

  # if `strGroupLevel` is null, use `strGroupCol`
  if (is.null(strGroupLevel)) {
    strGroupLevel <- strGroupCol
  }

  # Rename SubjectID in dfSubjects
  dfSubjects <- dfSubjects %>%
    select(
      "SubjectID" = !!strSubjectCol,
      "GroupID" = !!strGroupCol
    ) %>%
    mutate(
      "GroupLevel" = strGroupLevel
    )

  # Calculate Numerator
  dfNumerator_subj <- dfNumerator %>%
    rename(SubjectID = {{ strSubjectCol }}) %>%
    mutate(Numerator = if (strNumeratorMethod == "Count") 1 else .data[[strNumeratorCol]]) %>%
    group_by(.data$SubjectID) %>%
    summarise(Numerator = sum(.data$Numerator, na.rm = TRUE))

  # Calculate Denominator
  dfDenominator_subj <- dfDenominator %>%
    rename(SubjectID = {{ strSubjectCol }}) %>%
    mutate(Denominator = if (strDenominatorMethod == "Count") 1 else .data[[strDenominatorCol]]) %>%
    group_by(.data$SubjectID) %>%
    summarise(Denominator = sum(.data$Denominator, na.rm = TRUE))

  if (all(dfDenominator_subj$Denominator == 0)) {
    LogMessage(
      level = "fatal",
      message = "All denominator values are 0, please check `dfDenominator`"
    )
  }

  # Merge Numerator and Denominator with Subject Data. Keep all data in Subject. Fill in missing numerator/denominators with 0
  dfInput <- dfSubjects %>%
    left_join(dfNumerator_subj, by = "SubjectID") %>%
    left_join(dfDenominator_subj, by = "SubjectID") %>%
    mutate(
      "Numerator" = if_else(is.na(.data$Numerator), 0, .data$Numerator),
      "Denominator" = if_else(is.na(.data$Denominator), 0, .data$Denominator)
    ) %>%
    mutate(Metric = .data$Numerator / .data$Denominator)

  if (any(is.na(dfInput$GroupID))) {
    LogMessage(
      level = "warn",
      message = "{sum(is.na(dfInput$GroupID))} cases of NA's in GroupID, cases are removed in output",
    )
    dfInput <- dfInput %>%
      filter(!is.na(.data$GroupID))
  }

  return(dfInput)
}
