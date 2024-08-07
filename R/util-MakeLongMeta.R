#' Helper function to compile "long" group metadata
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Used to create components of the group metadata dictionary (dfGroups) for use
#' in charts and reports. This function takes a data frame and a string
#' specifying the group columns, and returns a long format data frame.
#'
#' @param data The input data frame.
#' @param strGroupLevel A string specifying the group type.
#' @param strGroupCols A string specifying the group columns.
#'
#' @return A long format data frame.
#'
#' @examples
#' df <- data.frame(GroupID = c(1, 2, 3), Param1 = c(10, 20, 30), Param2 = c(100, 200, 300))
#' MakeLongMeta(df, "GroupID")
#'
#' @export
MakeLongMeta <- function(data, strGroupLevel, strGroupCols = "GroupID") {
  stopifnot(
    "strGroupCols not found in data" = all(strGroupCols %in% names(data))
  )
  param_cols <- names(data)[!(names(data) %in% strGroupCols)]
  data <- data %>%
    dplyr::mutate(dplyr::across(dplyr::everything(), as.character))

  df_long <- tidyr::pivot_longer(
    data,
    cols = dplyr::all_of(param_cols),
    names_to = "Param",
    values_to = "Value",
    values_transform = list(Value = as.character)
  ) %>%
    dplyr::mutate(GroupLevel = strGroupLevel)

  return(df_long)
}
