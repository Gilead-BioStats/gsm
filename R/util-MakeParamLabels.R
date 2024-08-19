#' Create Labels for Parameters
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Used to create components of the group metadata dictionary (dfGroups) for use
#' in charts and reports. This function takes a data frame and a string
#' specifying the group columns, and returns a long format data frame.
#'
#' @inheritParams shared-params
#'
#' @return `dfGroups` with an added `Label` column.
#'
#' @examples
#' head(gsm::reportingGroups)
#' MakeParamLabels(head(gsm::reportingGroups))
#' MakeParamLabels(
#'   head(gsm::reportingGroups),
#'   list(ParticipantCount = "Number of Participants")
#' )
#'
#' @export
MakeParamLabels <- function(dfGroups, lParamLabels = NULL) {
  lParamLabels <- validate_lParamLabels(lParamLabels)
  params <- sort(unique(dfGroups$Param))
  known_params <- intersect(params, names(lParamLabels))
  new_params <- setdiff(params, names(lParamLabels))
  labels <- setNames(params, params)
  labels[known_params] <- lParamLabels[known_params]
  labels[new_params] <- ParamToLabel(new_params)
  dfLabels <- tibble::enframe(labels, name = "Param", value = "Label")
  dfLabels$Label <- unlist(dfLabels$Label)
  return(dplyr::left_join(dfGroups, dfLabels, by = "Param"))
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
