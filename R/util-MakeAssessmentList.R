#' Load assessments from a package/directory
#'
#' @details
#'
#' `MakeAssessmentList()` is a utility function that creates a workflow mapping for assessments used in `Study_Assess()`.
#'
#' @param names `array of character` List of workflows to include. NULL (the default) includes all workflows in the specified locations.
#' @param path `character` The location of assessment YAML files. If package is specified, function will look in `/inst` folder.
#' @param package `character` The name of the package with assessments.
#' @param recursive `boolean` Find files in nested folders? Default FALSE. 
#'
#' @examples
#' MakeAssessmentList(path = "workflow", package = "gsm")
#'
#' @return `list` A list of assessments with workflow and parameter metadata.
#'
#' @importFrom purrr map_chr
#' @importFrom utils hasName
#' @importFrom yaml read_yaml
#'
#' @export

MakeAssessmentList <- function(names=NULL, path = "workflow", package = "gsm", recursive=FALSE) {
  if (!is.null(package)) {
    path <- system.file(path, package = package)
  }

  yaml_files <- list.files(path, pattern = "\\.yaml$", full.names = TRUE, recursive=recursive)

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

  if(!is.null(names)){
    assessments <- assessments %>% purrr::keep(.x$name %in% names)
  }

  return(assessments)
}
