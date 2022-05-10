#' Load assessments from a package/directory
#'
#' @details
#'
#' `MakeAssessmentList()` is a utility function that creates a workflow mapping for assessments used in `Study_Assess()`.
#'
#' @param path `character` The location of assessment YAML files. If package is specified, function will look in `/inst` folder.
#' @param package `character` package with assessments
#'
#' @examples
#' MakeAssessmentList(path = "assessments", package = "gsm")
#'
#' @importFrom utils hasName
#' @importFrom yaml read_yaml
#'
#' @return `list` A list of assessments with workflow and parameter metadata.
#'
#' @export

MakeAssessmentList <- function(path = "assessments", package = "gsm") {
  if (!is.null(package)) {
    path <- system.file(path, package = "gsm")
  }

  yaml_files <- list.files(path, pattern = "\\.yaml$", full.names = TRUE)

  # copied from tools package
  file_path_sans_ext <- function(x) {
    sub("([^.]+)\\.[[:alnum:]]+$", "\\1", x)
  }

  assessments <- yaml_files %>%
    map(function(path) {
      assessment <- yaml::read_yaml(path)
      assessment$path <- path
      if (!utils::hasName(assessment, "name")) {
        assessment$name <- path %>%
          file_path_sans_ext() %>%
          basename()
      }
      return(assessment)
    })
  names(assessments) <- assessments %>% map_chr(~ .x$name)
  return(assessments)
}
