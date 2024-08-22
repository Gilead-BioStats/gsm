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

#' @param dfSubjects `data.frame` with columns for SubjectID and any other
#'   relevant subject information
#' @param dfNumerator `data.frame` with a column for SubjectID and
#'   `strNumeratorCol` if `strNumeratorMethod` is "Sum"
#' @param dfDenominator `data.frame` with a column for SubjectID and
#'   `strDenominatorCol` if `strDenominatorMethod` is "Sum"
#' @param strGroupCol `character` Column name in `dfSubjects` to use for
#'   grouping. Default: "GroupID"
#' @param strGroupLevel `character` value for the group level. Default:
#'   `strGroupCol`
#' @param strSubjectCol `character` Column name in `dfSubjects` to use for
#'   subject ID. Default: "SubjectID"
#' @param strNumeratorMethod `character` Method to calculate numerator. Default:
#'   "Count"
#' @param strDenominatorMethod `character` Method to calculate denominator.
#'   Default: "Count"
#' @param strNumeratorCol `character` Column name in `dfNumerator` to use for
#'   numerator calculation. Default: NULL
#' @param strDenominatorCol `character` Column name in `dfDenominator` to use
#'   for denominator calculation. Default: NULL
#' @param strFilterSubjects,strFilterNumerator,strFilterDenominator `character`
#'   A string with filters for `dfSubjects`, `dfNumerator`, or `dfDenominator`,
#'   or a character vector of such filters. For example, if `dfSubjects`
#'   contains a column `enrollyn` with values 'Y' and 'N', and a column `siteid`
#'   with integer IDs, `strFilterSubjects` might be "enrollyn == 'y', siteid ==
#'   5", or `c("enrollyn == 'y'", "siteid == 5")`. Default: NULL
#'
#' @return `data.frame` with the following specification:
#'
#'   | Column Name  | Description                          | Type     |
#'   |--------------|--------------------------------------|----------| |
#'   SubjectID    | The subject ID                       | Character| | GroupID
#'   | The group ID                         | Character| | GroupLevel   | The
#'   group type                       | Character| | Numerator    | The
#'   calculated numerator value       | Numeric  | | Denominator  | The
#'   calculated denominator value     | Numeric  | | Metric       | The
#'   calculated input rate/metric     | Numeric  |
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
  strGroupLevel = strGroupCol,
  strSubjectCol = "SubjectID",
  strNumeratorMethod = c("Count", "Sum"),
  strDenominatorMethod = c("Count", "Sum"),
  strNumeratorCol = NULL,
  strDenominatorCol = NULL,
  strFilterSubjects = NULL,
  strFilterNumerator = NULL,
  strFilterDenominator = NULL
) {
  dfSubjects <- validate_df(
    dfSubjects,
    required_colnames = c(strSubjectCol, strGroupCol)
  )
  dfDenominator <- validate_df(dfDenominator, required_colnames = strSubjectCol)
  dfNumerator <- validate_df(dfNumerator, required_colnames = strSubjectCol)

  # must be eit
  strNumeratorMethod <- match.arg(strNumeratorMethod)
  strDenominatorMethod <- match.arg(strDenominatorMethod)

  # Check if strNumeratorCol is Null when strNumeratorMethod is 'Sum'
  if (strNumeratorMethod == "Sum" && is.null(strNumeratorCol)) {
    stop("strNumeratorCol must be provided when strNumeratorMethod is 'Sum'")
  }

  # Check if strDenominatorCol is Null when strDenominatorMethod is 'Sum'
  if (strDenominatorMethod == "Sum" && is.null(strDenominatorCol)) {
    stop("strDenominatorCol must be provided when strDenominatorMethod is 'Sum'")
  }

  dfSubjects <- filterByStr(dfSubjects, strFilterSubjects)
  dfNumerator <- filterByStr(dfNumerator, strFilterNumerator)
  dfDenominator <- filterByStr(dfDenominator, strFilterDenominator)

  # Rename SubjectID in dfSubjects
  dfSubjects <- dfSubjects %>%
    select(
      "SubjectID" = !!strSubjectCol,
      "GroupID" = !!strGroupCol
    ) %>%
    mutate(
      "GroupLevel" = strGroupLevel
    )

  dfNumerator_subj <- calculateCol_bySubj(
    dfNumerator,
    strSubjectCol,
    "Numerator",
    strNumeratorCol,
    strNumeratorMethod
  )
  dfDenominator_subj <- calculateCol_bySubj(
    dfDenominator,
    strSubjectCol,
    "Denominator",
    strDenominatorCol,
    strDenominatorMethod
  )

  # Merge Numerator and Denominator with Subject Data. Keep all data in Subject. Fill in missing numerator/denominators with 0
  dfInput <- dfSubjects %>%
    left_join(dfNumerator_subj, by = "SubjectID") %>%
    left_join(dfDenominator_subj, by = "SubjectID") %>%
    tidyr::replace_na(list(Numerator = 0, Denominator = 0)) %>%
    mutate(Metric = .data$Numerator / .data$Denominator)

  if (any(is.na(dfInput$GroupID))) {
    cli::cli_alert_warning(glue::glue("{sum(is.na(dfInput$GroupID))} cases of NA's in GroupID, cases are removed in output"))
    dfInput <- dfInput %>%
      filter(!is.na(.data$GroupID))
  }

  return(dfInput)
}

#' Count or Sum a Column by Subject
#'
#' @inheritParams Input_Rate
#' @param df The df to modify.
#' @param strCol The column to produce.
#' @param strColOriginal The name of `strCol` in `df`.
#' @param strMethod Whether to "Count" or "Sum" the values in the column.
#'
#' @return The modified df.
#' @keywords internal
calculateCol_bySubj <- function(
    df,
    strSubjectCol = "SubjectID",
    strCol,
    strColOriginal,
    strMethod = c("Count", "Sum")
) {
  if (strMethod == "Count") {
    df[[strCol]] <- 1
  } else {
    df[[strCol]] <- df[[strColOriginal]]
  }

  df %>%
    dplyr::rename("SubjectID" = !!strSubjectCol) %>%
    dplyr::summarise(!!strCol := sum(.data[[strCol]]), .by = "SubjectID")
}

#' Filter by a String Expression
#'
#' @param df The df to filter.
#' @param strFilter The filter expression as a comma-separated string or a
#'   character vector.
#'
#' @return The filtered df.
#' @keywords internal
filterByStr <- function(df, strFilter) {
  strFilter <- gsub(",", ";", strFilter)
  dplyr::filter(df, !!!rlang::parse_exprs(strFilter))
}
