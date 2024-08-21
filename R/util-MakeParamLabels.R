#' Create Labels for Parameters
#'
#' @description `r lifecycle::badge("stable")`
#'
#'   Convert a vector of parameters to labels in Title Case. `MakeParamLabels`
#'   adds a `Labels` column to a `data.frame` that has a `Params` column (such
#'   as `dfGroups`), while `MakeParamLabelsList` returns just the list of named
#'   parameters.
#'
#' @inheritParams shared-params
#'
#' @return `dfGroups` with an added `Label` column, or a list of labeled
#'   parameters.
#'
#' @examples
#' head(gsm::reportingGroups)
#' MakeParamLabels(head(gsm::reportingGroups))
#' MakeParamLabels(
#'   head(gsm::reportingGroups),
#'   list(ParticipantCount = "Number of Participants")
#' )
#' MakeParamLabelsList(head(gsm::reportingGroups$Params))
#'
#' @export
MakeParamLabels <- function(dfGroups, lParamLabels = NULL) {
  chrParams <- sort(unique(dfGroups$Param))
  labels <- MakeParamLabelsList(chrParams, lParamLabels)
  dfLabels <- tibble::enframe(labels, name = "Param", value = "Label")
  dfLabels$Label <- unlist(dfLabels$Label)
  return(dplyr::left_join(dfGroups, dfLabels, by = "Param"))
}

#' @rdname MakeParamLabels
#' @param chrParams A character vector of parameters, or a list that can be
#'   coerced to a character vector.
#' @export
MakeParamLabelsList <- function(chrParams, lParamLabels) {
  chrParams <- unlist(chrParams)
  lParamLabels <- validate_lParamLabels(lParamLabels)
  known_params <- intersect(chrParams, names(lParamLabels))
  new_params <- setdiff(chrParams, names(lParamLabels))
  labels <- setNames(as.list(chrParams), chrParams)
  labels[known_params] <- lParamLabels[known_params]
  labels[new_params] <- ParamToLabel(new_params)
  return(labels)
}

validate_lParamLabels <- function(lParamLabels) {
  UseMethod("validate_lParamLabels")
}

#' @export
validate_lParamLabels.NULL <- function(lParamLabels) {
  return(NULL)
}

#' @export
validate_lParamLabels.list <- function(lParamLabels) {
  if (length(lParamLabels) && rlang::is_named(lParamLabels)) {
    # Uniquify.
    return(lParamLabels[unique(names(lParamLabels))])
  }
  return(NULL)
}

#' @export
validate_lParamLabels.character <- function(lParamLabels) {
  return(validate_lParamLabels.list(as.list(lParamLabels)))
}

ParamToLabel <- function(chrParams) {
  stringr::str_replace_all(chrParams, "[^A-Za-z0-9]", " ") %>%
    stringr::str_replace_all("([[:lower:]])([[:upper:]])", "\\1 \\2") %>%
    stringr::str_replace_all(
      "(^| )([[:lower:]])", toupper
    )
}
